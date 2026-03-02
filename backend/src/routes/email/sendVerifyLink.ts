import { RequestHandler } from 'express'
import { CLIENT_URL } from '../../utils/env'
import { dbUsers, dbVerifyTokens } from '../../utils/database'
import { loadTemplate, sendEmail, useTemplate } from '../../utils/email'
import { NotFoundError, ServiceUnavailableError } from '../../utils/errors'
import { generateEmailToken, validateAccessToken } from '../../utils/tokens'

const verifyEmailForm = loadTemplate('verifyEmail')

/**
 * Generates a revocable email verification token for the caller
 * then saves the token to database and sends out an email
 */
export const sendVerifyLink: RequestHandler = async (req, res) => {
  const userId = validateAccessToken(req).userId
  const { email } = req.body

  const user = await dbUsers.findOne({ _id: userId })
  if (!user) {
    throw new NotFoundError('User with specified id not found')
  }

  if (user.email !== email) {
    throw new NotFoundError('Email not associated with specified user')
  }

  // Make sure no duplicate verification codes exist in the system
  await dbVerifyTokens.findOneAndDelete({ email })

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
