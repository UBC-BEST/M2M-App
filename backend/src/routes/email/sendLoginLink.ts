import { RequestHandler } from 'express'
import { dbLinkTokens, dbUsers } from '../../utils/database'
import { NotFoundError, ServiceUnavailableError } from '../../utils/errors'
import { generateEmailToken } from '../../utils/tokens'
import { loadTemplate, sendEmail, useTemplate } from '../../utils/email'
import { CLIENT_URL } from '../../utils/env'

const loginLinkForm = loadTemplate('loginLinkEmail')

export const sendLoginLink: RequestHandler = async (req, res) => {
  const { email } = req.body

  const user = await dbUsers.findOne({ email })
  if (!user) {
    throw new NotFoundError('No account associated with this email')
  }

  // Make sure no duplicate login links exist in the system
  await dbLinkTokens.findOneAndDelete({ email, type: 'login_link' })

  const { token, createdAt, expiresAt } = await generateEmailToken()
  await dbLinkTokens.insertOne({
    userId: user._id,
    email,
    token,
    createdAt,
    expiresAt,
    type: 'login_link',
  })

  const success = await sendEmail({
    to: [email],
    html: useTemplate(loginLinkForm, {
      loginLink: `${CLIENT_URL}/link-login?token=${encodeURIComponent(token)}`,
    }),
    subject: 'Login Link - Muscle to Movement',
  })

  if (!success) {
    throw new ServiceUnavailableError('Failed to send login link email')
  }

  res.status(200).send('Sent login link email')
}
