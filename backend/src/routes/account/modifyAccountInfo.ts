import { RequestHandler } from 'express'
import { validateAccessToken } from '../../utils/tokens'
import { ObjectId } from 'mongodb'
import { dbUsers } from '../../utils/database'

export const modifyAccountInfo: RequestHandler = async (
  req,
  res
): Promise<any> => {
  let userId: ObjectId
  try {
    const payload = validateAccessToken(req)
    userId = payload.userId
  } catch (error: any) {
    return res.status(error.status || 500).send(error.message)
  }

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
