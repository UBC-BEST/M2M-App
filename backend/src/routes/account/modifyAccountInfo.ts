import { RequestHandler } from 'express'
import { validateAccessToken } from '../../utils/tokens'
import { dbUsers } from '../../utils/database'
import { UserDocument } from '../../types/documents'
import { BadRequestError, NotFoundError } from '../../utils/errors'

export const modifyAccountInfo: RequestHandler = async (req, res) => {
  const userId = validateAccessToken(req).userId

  if (!(await dbUsers.findOne({ userId }))) {
    throw new NotFoundError('User not found')
  }

  const { displayName, email } = req.body
  const updateObject: Partial<UserDocument> = {}

  if (displayName) {
    updateObject.displayName = displayName
  }

  if (email) {
    updateObject.email = email
  }

  if (!Object.keys(updateObject).length) {
    throw new BadRequestError('No valid update values provided')
  }

  await dbUsers.updateOne({ userId: userId }, { $set: updateObject })

  res.status(200).send('Changes applied to account')
}
