import { RequestHandler } from 'express'
import {
  generateAccessToken,
  useRefreshToken,
  validateLinkToken,
} from '../../../utils/tokens'

export const applyLoginLink: RequestHandler = async (req, res) => {
  const { token } = req.body

  // Delete on retrieval since tokens are single use
  const tokenData = await validateLinkToken(token, 'login_link')

  // Auto-login user
  const accessToken = generateAccessToken(tokenData.userId)
  await useRefreshToken(tokenData.userId, res)

  res.status(200).json({ accessToken })
}
