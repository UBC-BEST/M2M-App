import { RequestHandler } from 'express'
import { ServiceUnavailableError } from '../../utils/errors'
import { generateLinkToken } from '../../utils/tokens'
import { loadTemplate, sendEmail, useTemplate } from '../../utils/email'
import { CLIENT_URL } from '../../utils/env'

const loginLinkForm = loadTemplate('loginLinkEmail')

export const sendLoginLink: RequestHandler = async (req, res) => {
  const { email } = req.body
  const token = await generateLinkToken(email, 'login_link')

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
