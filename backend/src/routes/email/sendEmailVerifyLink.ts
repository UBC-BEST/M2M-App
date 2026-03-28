import { RequestHandler } from 'express'
import { CLIENT_URL } from '../../utils/env'
import { dbUsers, dbLinkTokens } from '../../utils/database'
import { loadTemplate, sendEmail, useTemplate } from '../../utils/email'
import {
  ForbiddenError,
  NotFoundError,
  ServiceUnavailableError,
} from '../../utils/errors'
import { generateLinkToken, validateAccessToken } from '../../utils/tokens'

const verifyEmailForm = loadTemplate('verifyLinkEmail')

/**
 * Generates a revocable email verification token for the caller
 * then saves the token to database and sends out an email
 */
export const sendEmailVerifyLink: RequestHandler = async (req, res) => {
  const userId = validateAccessToken(req).userId
  const { email } = req.body

  const user = await dbUsers.findOne({ _id: userId })
  if (!user) {
    throw new NotFoundError('User with specified id not found')
  }

  if (user.email !== email) {
    throw new NotFoundError('Email not associated with specified user')
  }

  if (user.verified) {
    throw new ForbiddenError('User email has already been verified')
  }

  const token = await generateLinkToken(email, 'email_verify')

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

  res.status(200).send('Sent verification email')
}
