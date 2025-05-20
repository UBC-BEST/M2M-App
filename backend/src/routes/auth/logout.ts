import { RequestHandler } from 'express'
import { dbRefreshTokens } from '../../utils/database'
import { refreshTokenOptions } from '../../utils/tokens'

export const logout: RequestHandler = async (req, res): Promise<any> => {
  const { refreshToken } = req.cookies

  if (!refreshToken) {
    return res.status(400).send('No refresh token provided')
  }

  const deleteResult = await dbRefreshTokens.deleteOne({ token: refreshToken })
  if (!deleteResult.deletedCount) {
    return res.status(401).send('Invalid login session provided')
  }

  res.clearCookie('refreshToken', refreshTokenOptions)

  res.status(200).send('Logout successful')
}
