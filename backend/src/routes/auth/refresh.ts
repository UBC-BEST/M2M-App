import { RequestHandler } from 'express'
import jwt from 'jsonwebtoken'
import { REFRESH_TOKEN_SECRET } from '../../utils/env'
import { generateAccessToken, useRefreshToken } from '../../utils/tokens'
import { dbRefreshTokens } from '../../utils/database'
import { ObjectId } from 'mongodb'
import { RefreshTokenPayload } from '../../types/tokens'
import { ForbiddenError, UnauthorizedError } from '../../utils/errors'

export const refresh: RequestHandler = async (req, res) => {
  const { refreshToken } = req.cookies

  if (!refreshToken) {
    throw new UnauthorizedError('No refresh token provided')
  }

  let userId: ObjectId
  try {
    const payload = jwt.verify(refreshToken, REFRESH_TOKEN_SECRET)
    userId = new ObjectId((payload as RefreshTokenPayload).userId)
  } catch (error) {
    throw new ForbiddenError('Malformed or expired refresh token')
  }

  // Delete and regenerate the refresh token after each use to prevent token stealing attacks
  // and maintain a rolling expiry date
  const deleteResult = await dbRefreshTokens.deleteOne({ token: refreshToken })
  if (!deleteResult.deletedCount) {
    throw new ForbiddenError('Invalid or revoked refresh token')
  }

  const accessToken = generateAccessToken(userId)
  await useRefreshToken(userId, res)

  res.status(200).json({ accessToken })
}
