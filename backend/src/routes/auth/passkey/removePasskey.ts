import { RequestHandler } from 'express'
import { validateAccessToken } from '../../../utils/tokens'
import { dbPasskeys } from '../../../utils/database'
import { NotFoundError } from '../../../utils/errors'

export const removePasskey: RequestHandler = async (req, res) => {
  const userId = validateAccessToken(req).userId
  const { id } = req.params

  const existingPasskey = await dbPasskeys.findOneAndDelete({
    userId,
    credentialId: id,
  })

  if (!existingPasskey) {
    throw new NotFoundError('Passkey could not be found')
  }

  res.status(200).send('Passkey deleted')
}
