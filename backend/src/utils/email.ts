import { EMAIL_SENDER_DOMAIN, MAILGUN_API_SECRET } from './env'
import fs from 'fs'
import Mailgun from 'mailgun.js'
import FormData from 'form-data'

const mailgun = new Mailgun(FormData)

export const mailgunClient = mailgun.client({
  username: 'api',
  key: MAILGUN_API_SECRET,
})

const cssStyles = fs.readFileSync('src/templates/styles.css', 'utf-8')

/**
 * Loads an HTML template from the templates directory and inlines the shared
 * stylesheet in place of the external CSS link
 *
 * @param fileName The template file name without the `.html` extension
 */
export const loadTemplate = (fileName: string) => {
  const filePath = `src/templates/${fileName}.html`
  return fs.readFileSync(filePath, 'utf-8').replace(
    // Replace the external stylesheet reference with inlined CSS
    '<link rel="stylesheet" href="styles.css" />',
    `<style>${cssStyles}</style>`
  )
}

/**
 * Replaces placeholder tokens in an HTML template with the provided values
 *
 * @param rawTemplate The source HTML template as a string
 * @param variables A key-value map that specifies which values should be used
 * for `{{key}}` placeholders in the template
 */
export const useTemplate = (
  rawTemplate: string,
  variables: { [key: string]: string }
) => {
  let result = rawTemplate
  for (const [key, entry] of Object.entries(variables)) {
    result = result.replaceAll(`{{${key}}}`, entry)
  }
  return result
}

// Placeholder since version 12.7.0 of mailgun.js appears to not export the
// MailgunMessageData type as expected
type MailgunMessageData = Parameters<typeof mailgunClient.messages.create>[1]

/**
 * Sends an email through Mailgun using the provided message data
 *
 * @param data The Mailgun message payload to send
 *
 * @returns `true` if the send was successful and `false` otherwise
 */
export const sendEmail = async (data: MailgunMessageData): Promise<boolean> => {
  const formOptions: MailgunMessageData = {
    from: `Muscle to Movement <noreply@${EMAIL_SENDER_DOMAIN}>`,
    ...data,
  }

  try {
    const result = await mailgunClient.messages.create(
      EMAIL_SENDER_DOMAIN,
      formOptions
    )

    const success = result.status === 200

    if (!success) {
      console.warn('sendEmail: Unexpected output from Mailgun', result)
    }

    return success
  } catch (error) {
    console.error('sendEmail: Attempt failed', error)
    return false
  }
}
