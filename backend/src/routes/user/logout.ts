import { RequestHandler } from 'express'
import { dbRefreshTokens } from '../../utils/database'
import { refreshTokenOptions } from '../../utils/tokens'

export const logout: RequestHandler = async (req, res): Promise<any> => {
  const { refreshToken } = req.cookies

  if (!refreshToken) {
    return res.status(400).send('No provided session to invalidate')
  }

  // Remove refresh token from database
  const deleteResult = await dbRefreshTokens.deleteOne({ value: refreshToken })
  if (!deleteResult.deletedCount) {
    return res.status(401).send('Invalid login session provided')
  }

  // Remove refresh token from cookies
  res.clearCookie('refreshToken', refreshTokenOptions)

  res.status(200).send('Logout successful')
}
