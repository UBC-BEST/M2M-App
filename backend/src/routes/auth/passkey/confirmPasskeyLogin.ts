import { RequestHandler } from 'express'
import {
  BadRequestError,
  ForbiddenError,
  NotFoundError,
  UnauthorizedError,
} from '../../../utils/errors'
import {
  dbPasskeyChallenges,
  dbPasskeys,
  dbUsers,
} from '../../../utils/database'
import { DateTime } from 'luxon'
import { verifyAuthenticationResponse } from '@simplewebauthn/server'
import { WEBAUTHN_RP_ID, WEBAUTHN_RP_ORIGIN } from '../../../utils/env'
import { generateAccessToken, useRefreshToken } from '../../../utils/tokens'

export const confirmPasskeyLogin: RequestHandler = async (req, res) => {
  const { email, auth } = req.body

  if (!email) {
    throw new BadRequestError('Missing required field `email` in request body')
  }

  if (!auth) {
    throw new BadRequestError('Missing required field `auth` in request body')
  }

  const user = await dbUsers.findOne({ email })
  if (!user) {
    throw new NotFoundError('No account associated with this email')
  }

  const challenge = await dbPasskeyChallenges.findOneAndDelete({
    userId: user._id,
    type: 'authentication',
  })

  if (!challenge) {
    throw new BadRequestError('Passkey login challenge not found')
  }

  if (challenge.expiresAt < DateTime.now().toUnixInteger()) {
    throw new ForbiddenError('Passkey login challenge expired')
  }

  const passkey = await dbPasskeys.findOne({
    userId: user._id,
    credentialId: auth.id,
  })

  if (!passkey) {
    throw new UnauthorizedError('Passkey not recognized')
  }

  const verification = await verifyAuthenticationResponse({
    response: auth,
    expectedChallenge: challenge.challenge,
    expectedOrigin: WEBAUTHN_RP_ORIGIN,
    expectedRPID: WEBAUTHN_RP_ID,
    credential: {
      id: passkey.credentialId,
      publicKey: new Uint8Array(Buffer.from(passkey.publicKey, 'base64url')),
      counter: passkey.counter,
      transports: passkey.transports,
    },
    requireUserVerification: false,
  })

  const { verified, authenticationInfo } = verification

  if (!verified || !authenticationInfo) {
    throw new ForbiddenError('Passkey login could not be verified')
  }

  await dbPasskeys.updateOne(
    { userId: user._id, credentialId: passkey.credentialId },
    {
      $set: {
        counter: verification.authenticationInfo.newCounter,
        lastUsedAt: DateTime.now().toUnixInteger(),
      },
    }
  )

  const accessToken = generateAccessToken(user._id)
  await useRefreshToken(user._id, res)

  res.status(200).json({
    accessToken,
  })
}
