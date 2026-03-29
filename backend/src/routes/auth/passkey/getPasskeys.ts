import { RequestHandler } from 'express'
import { validateAccessToken } from '../../../utils/tokens'
import { dbPasskeys } from '../../../utils/database'

export const getPasskeys: RequestHandler = async (req, res) => {
  const userId = validateAccessToken(req).userId

  const passkeys = await dbPasskeys
    .find({ userId })
    .sort({ createdAt: -1 })
    .toArray()

  res.status(200).json(
    passkeys.map(passkey => ({
      credentialId: passkey.credentialId,
      label: passkey.label,
      deviceType: passkey.deviceType,
      backedUp: passkey.backedUp,
      createdAt: passkey.createdAt,
      lastUsedAt: passkey.lastUsedAt,
      transports: passkey.transports,
    }))
  )
}
