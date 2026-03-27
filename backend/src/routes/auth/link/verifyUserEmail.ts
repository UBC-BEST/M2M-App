import { RequestHandler } from 'express'
import { dbUsers, dbVerifyTokens } from '../../../utils/database'
import jwt from 'jsonwebtoken'
import { EMAIL_TOKEN_SECRET } from '../../../utils/env'
import { ForbiddenError, NotFoundError } from '../../../utils/errors'
import { generateAccessToken, useRefreshToken } from '../../../utils/tokens'

export const verifyUserEmail: RequestHandler = async (req, res) => {
  const { token } = req.body

  // Delete on retrieval since tokens are single use
  const tokenData = await dbVerifyTokens.findOneAndDelete({ token })

  if (!tokenData) {
    throw new NotFoundError('Invalid or revoked email verification token')
  }

  try {
    jwt.verify(token, EMAIL_TOKEN_SECRET)
  } catch (error) {
    throw new ForbiddenError('Malformed or expired email verification token')
  }

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
