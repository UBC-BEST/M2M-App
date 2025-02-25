import { RequestHandler } from 'express'
import { dbRefreshTokens } from '../../utils/database'

export const logout: RequestHandler = async (req, res): Promise<any> => {
  const headerToken = req.headers.authorization?.at(-1)

  if (!headerToken) {
    return res.status(401).send('No refresh token provided')
  }

  const deleteResult = await dbRefreshTokens.deleteOne({ token: headerToken })
  if (!deleteResult.deletedCount) {
    return res.status(400).send('Invalid login session')
  }

  res.status(200).send('Logout successful')
}
