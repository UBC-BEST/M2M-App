import { RequestHandler } from 'express'
import { dbLinkTokens } from '../../../utils/database'
import jwt from 'jsonwebtoken'
import { EMAIL_TOKEN_SECRET } from '../../../utils/env'
import { ForbiddenError, NotFoundError } from '../../../utils/errors'
import { generateAccessToken, useRefreshToken } from '../../../utils/tokens'

export const applyLoginLink: RequestHandler = async (req, res) => {
  const { token } = req.body

  // Delete on retrieval since tokens are single use
  const tokenData = await dbLinkTokens.findOneAndDelete({
    type: 'login_link',
    token,
  })

  if (!tokenData) {
    throw new NotFoundError('Invalid or revoked login link token')
  }

  try {
    jwt.verify(token, EMAIL_TOKEN_SECRET)
  } catch (error) {
    throw new ForbiddenError('Malformed or expired login link token')
  }

  // Auto-login user
  const accessToken = generateAccessToken(tokenData.userId)
  await useRefreshToken(tokenData.userId, res)

  res.status(200).json({ accessToken })
}
