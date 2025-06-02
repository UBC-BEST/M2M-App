import { RequestHandler } from 'express'
import jwt from 'jsonwebtoken'
import { REFRESH_TOKEN_SECRET } from '../../utils/env'
import { generateAccessToken, useRefreshToken } from '../../utils/tokens'
import { dbRefreshTokens } from '../../utils/database'
import { ObjectId } from 'mongodb'
import { RefreshTokenPayload } from '../../types/tokens'

export const refresh: RequestHandler = async (req, res): Promise<any> => {
  const { refreshToken } = req.cookies

  if (!refreshToken) {
    return res.status(401).send('No refresh token provided')
  }

  let userId: ObjectId
  try {
    const payload = jwt.verify(refreshToken, REFRESH_TOKEN_SECRET)
    userId = (payload as RefreshTokenPayload).userId
  } catch (error) {
    console.error(error)
    return res.status(403).send('Malformed or expired refresh token')
  }

  // Delete and regenerate the refresh token after each use to prevent token stealing attacks
  // and maintain a rolling expiry date
  const deleteResult = await dbRefreshTokens.deleteOne({ token: refreshToken })
  if (!deleteResult.deletedCount) {
    return res.status(403).send('Invalid or revoked refresh token')
  }

  const accessToken = generateAccessToken(userId)
  await useRefreshToken(userId, res)

  return res.status(200).json({ accessToken })
}
