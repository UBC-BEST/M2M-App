import { RequestHandler } from 'express'
import { validateAccessToken } from '../../utils/tokens'
import { dbUsers } from '../../utils/database'
import { UserDocument } from '../../types/documents'
import { NotFoundError } from '../../utils/errors'

export const getAccountInfo: RequestHandler = async (req, res) => {
  const userId = validateAccessToken(req).userId

  const user = await dbUsers.findOne({ userId })
  if (!user) {
    throw new NotFoundError('User with specified id not found')
  }

  const userResult: Partial<UserDocument> = {
    email: user.email,
    displayName: user.displayName,
    verified: user.verified,
    createdAt: user.createdAt,
  }

  res.status(200).send(userResult)
}
