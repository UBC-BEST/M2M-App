import { RequestHandler } from 'express'
import { BadRequestError, NotFoundError } from '../../../utils/errors'
import {
  dbPasskeyChallenges,
  dbPasskeys,
  dbUsers,
} from '../../../utils/database'
import { generateAuthenticationOptions } from '@simplewebauthn/server'
import { WEBAUTHN_CHALLENGE_EXPIRY, WEBAUTHN_RP_ID } from '../../../utils/env'
import { DateTime } from 'luxon'
import ms from 'ms'

export const beginPasskeyLogin: RequestHandler = async (req, res) => {
  const { email } = req.body

  if (!email) {
    throw new BadRequestError('Missing required field `email` in request body')
  }

  const user = await dbUsers.findOne({ email })
  if (!user) {
    throw new NotFoundError('No account associated with this email')
  }

  const passkeys = await dbPasskeys.find({ userId: user._id }).toArray()

  if (!passkeys.length) {
    throw new NotFoundError('No passkeys registered for this account')
  }

  const options = await generateAuthenticationOptions({
    rpID: WEBAUTHN_RP_ID,
    allowCredentials: passkeys.map(passkey => ({
      id: passkey.credentialId,
      transports: passkey.transports,
    })),
    userVerification: 'preferred',
  })

  await dbPasskeyChallenges.deleteMany({
    userId: user._id,
    type: 'authentication',
  })

  await dbPasskeyChallenges.insertOne({
    userId: user._id,
    type: 'authentication',
    challenge: options.challenge,
    createdAt: DateTime.now().toUnixInteger(),
    expiresAt: DateTime.now()
      .plus(ms(WEBAUTHN_CHALLENGE_EXPIRY))
      .toUnixInteger(),
  })

  res.status(200).json(options)
}
