import { RequestHandler } from 'express'
import { validateAccessToken } from '../../../utils/tokens'
import { dbPasskeyChallenges, dbPasskeys } from '../../../utils/database'
import {
  BadRequestError,
  DataConflictError,
  ForbiddenError,
} from '../../../utils/errors'
import { DateTime } from 'luxon'
import { verifyRegistrationResponse } from '@simplewebauthn/server'
import { WEBAUTHN_RP_ID, WEBAUTHN_RP_ORIGIN } from '../../../utils/env'

export const confirmPasskeyRegister: RequestHandler = async (req, res) => {
  const userId = validateAccessToken(req).userId

  const { auth, label } = req.body

  const challenge = await dbPasskeyChallenges.findOneAndDelete({
    userId,
    type: 'registration',
  })

  if (!challenge) {
    throw new BadRequestError('Passkey egistration challenge not found')
  }

  if (challenge.expiresAt < DateTime.now().toUnixInteger()) {
    throw new ForbiddenError('Passkey registration challenge expired')
  }

  const verification = await verifyRegistrationResponse({
    response: auth,
    expectedChallenge: challenge.challenge,
    expectedOrigin: WEBAUTHN_RP_ORIGIN,
    expectedRPID: WEBAUTHN_RP_ID,
    requireUserVerification: false,
  })

  const { verified, registrationInfo } = verification

  if (!verified || !registrationInfo) {
    throw new ForbiddenError('Passkey registration could not be verified')
  }

  const { credential, credentialDeviceType, credentialBackedUp } =
    registrationInfo

  if (await dbPasskeys.findOne({ credentialId: credential.id })) {
    throw new DataConflictError('This passkey is already registered')
  }

  await dbPasskeys.insertOne({
    userId,
    credentialId: credential.id,
    publicKey: Buffer.from(credential.publicKey).toString('base64url'),
    counter: credential.counter,
    deviceType: credentialDeviceType,
    backedUp: credentialBackedUp,
    createdAt: DateTime.now().toUnixInteger(),
    lastUsedAt: undefined,
    transports: auth.response.transports,
    label: label?.trim() || 'Passkey',
  })

  res.status(200).send('New passkey registered')
}
