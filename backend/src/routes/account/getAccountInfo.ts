import { RequestHandler } from 'express'
import { validateAccessToken } from '../../utils/tokens'
import { dbUsers } from '../../utils/database'
import { UserDocument } from '../../types/documents'

export const getAccountInfo: RequestHandler = async (
  req,
  res
): Promise<any> => {
  const userId = validateAccessToken(req).userId

  const user = await dbUsers.findOne({ userId })
  if (!user) {
    return res.status(404).send('User not found')
  }

  const userResult: Partial<UserDocument> = {
    email: user.email,
    displayName: user.displayName,
    verified: user.verified,
    createdAt: user.createdAt,
  }

  return res.status(200).send(userResult)
}
