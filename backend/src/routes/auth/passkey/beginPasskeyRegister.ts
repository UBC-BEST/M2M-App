import { RequestHandler } from 'express'
import { validateAccessToken } from '../../../utils/tokens'
import {
  dbPasskeyChallenges,
  dbPasskeys,
  dbUsers,
} from '../../../utils/database'
import { NotFoundError } from '../../../utils/errors'
import { generateRegistrationOptions } from '@simplewebauthn/server'
import { WEBAUTHN_CHALLENGE_EXPIRY, WEBAUTHN_RP_NAME } from '../../../utils/env'
import { DateTime } from 'luxon'
import ms from 'ms'

export const beginPasskeyRegister: RequestHandler = async (req, res) => {
  const userId = validateAccessToken(req).userId

  const user = await dbUsers.findOne({ _id: userId })
  if (!user) {
    throw new NotFoundError('User with specified id not found')
  }

  const existingPasskeys = await dbPasskeys.find({ userId }).toArray()

  const options = await generateRegistrationOptions({
    rpName: WEBAUTHN_RP_NAME,
    rpID: WEBAUTHN_RP_NAME,
    userName: user.email,
    userID: Buffer.from(user._id.toString()),
    userDisplayName: user.displayName ?? user.email,
    attestationType: 'none',
    excludeCredentials: existingPasskeys.map(passkey => ({
      id: passkey.credentialId,
      transports: passkey.transports,
    })),
    authenticatorSelection: {
      residentKey: 'preferred',
      userVerification: 'preferred',
    },
  })

  await dbPasskeyChallenges.deleteMany({
    userId,
    type: 'registration',
  })

  await dbPasskeyChallenges.insertOne({
    userId,
    type: 'registration',
    challenge: options.challenge,
    createdAt: DateTime.now().toUnixInteger(),
    expiresAt: DateTime.now()
      .plus(ms(WEBAUTHN_CHALLENGE_EXPIRY))
      .toUnixInteger(),
  })

  res.json(options)
}
