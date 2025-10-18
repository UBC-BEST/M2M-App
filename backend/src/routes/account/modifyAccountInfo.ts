import { RequestHandler } from 'express'
import { validateAccessToken } from '../../utils/tokens'
import { dbUsers } from '../../utils/database'
import { UserDocument } from '../../types/documents'

export const modifyAccountInfo: RequestHandler = async (
  req,
  res
): Promise<any> => {
  const userId = validateAccessToken(req).userId

  if (!(await dbUsers.findOne({ userId }))) {
    return res.status(404).send('User not found')
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
    return res.status(400).send('Malformed request')
  }

  await dbUsers.updateOne({ userId: userId }, { $set: updateObject })

  return res.status(200).send('Changes applied to account')
}
