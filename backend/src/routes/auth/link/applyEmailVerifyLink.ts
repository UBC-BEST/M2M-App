import { RequestHandler } from 'express'
import { dbUsers } from '../../../utils/database'
import {
  generateAccessToken,
  useRefreshToken,
  validateLinkToken,
} from '../../../utils/tokens'

export const applyEmailVerifyLink: RequestHandler = async (req, res) => {
  const { token } = req.body

  const tokenData = await validateLinkToken(token, 'email_verify')

  // All checks passed: verify user email
  await dbUsers.updateOne(
    { _id: tokenData.userId },
    { $set: { verified: true } }
  )

  // Auto-login user
  const accessToken = generateAccessToken(tokenData.userId)
  await useRefreshToken(tokenData.userId, res)

  res.status(200).json({ accessToken })
}
