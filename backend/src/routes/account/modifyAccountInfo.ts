import { RequestHandler } from 'express'
import { validateAccessToken } from '../../utils/tokens'
import { dbUsers } from '../../utils/database'

export const modifyAccountInfo: RequestHandler = async (
  req,
  res
): Promise<any> => {
  const userId = validateAccessToken(req).userId

  if (!(await dbUsers.findOne({ userId }))) {
    return res.status(404).send('User not found')
  }

  const { displayName } = req.body

  if (!displayName) {
    return res.status(400).send('Malformed request')
  }

  await dbUsers.updateOne({ userId: userId }, { $set: { displayName } })

  return res.status(200).send('Changes applied to account')
}
