import { RequestHandler } from 'express'
import { dbRefreshTokens } from '../../utils/database'
import { refreshTokenOptions } from '../../utils/tokens'
import { BadRequestError, UnauthorizedError } from '../../utils/errors'

export const logout: RequestHandler = async (req, res) => {
  const { refreshToken } = req.cookies

  if (!refreshToken) {
    throw new BadRequestError('No refresh token provided')
  }

  const deleteResult = await dbRefreshTokens.deleteOne({ token: refreshToken })
  if (!deleteResult.deletedCount) {
    throw new UnauthorizedError('Invalid login session provided')
  }

  res.clearCookie('refreshToken', refreshTokenOptions)
  res.status(200).send('Logout successful')
}
