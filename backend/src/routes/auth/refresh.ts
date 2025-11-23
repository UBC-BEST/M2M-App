import { RequestHandler } from 'express'
import {
  generateAccessToken,
  useRefreshToken,
  validateRefreshToken,
} from '../../utils/tokens'
import { dbRefreshTokens } from '../../utils/database'
import { ForbiddenError, UnauthorizedError } from '../../utils/errors'

export const refresh: RequestHandler = async (req, res) => {
  const { refreshToken } = req.cookies

  if (!refreshToken) {
    throw new UnauthorizedError('No refresh token provided')
  }

  let userId = validateRefreshToken(refreshToken).userId

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
