import { RequestHandler } from 'express'
import { CLIENT_URL } from '../../utils/env'
import { dbVerifyTokens } from '../../utils/database'
import { loadTemplate, sendEmail, useTemplate } from '../../utils/email'
import { ServiceUnavailableError } from '../../utils/errors'
import { generateEmailToken } from '../../utils/tokens'

const verifyEmailForm = loadTemplate('verifyEmail')

/**
 * Generates a revocable email verification token for the specified user,
 * then saves the token to database and sends out an email
 */
export const sendVerifyLink: RequestHandler = async (req, res) => {
  const { userId, email } = req.body

  const { token, createdAt, expiresAt } = await generateEmailToken()
  await dbVerifyTokens.insertOne({
    userId,
    email,
    token,
    createdAt,
    expiresAt,
  })

  const success = await sendEmail({
    to: [email],
    html: useTemplate(verifyEmailForm, {
      verifyLink: `${CLIENT_URL}/verify?token=${encodeURIComponent(token)}`,
    }),
    subject: 'Verify Your Email - Muscle to Movement',
  })

  if (!success) {
    throw new ServiceUnavailableError('Failed to send verification email')
  }

  res.send('Sent verification email')
}
