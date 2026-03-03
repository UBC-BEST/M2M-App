import 'dotenv/config'
import env from 'env-var'
import { StringValue } from 'ms'

export const PORT = env.get('PORT').default(9000).asPortNumber()
export const HOST = env.get('HOST').default('http://localhost').asString()

const NODE_ENV = env.get('NODE_ENV').default('development').asString()
export const IS_PRODUCTION = NODE_ENV === 'production'

export const MONGODB_CONNECTION_URI = env
  .get('MONGODB_CONNECTION_URI')
  .required()
  .asString()
export const DB_NAME = env.get('DB_NAME').required().asString()

export const ACCESS_TOKEN_SECRET = env
  .get('ACCESS_TOKEN_SECRET')
  .required()
  .asString()
export const ACCESS_TOKEN_EXPIRY = env
  .get('ACCESS_TOKEN_EXPIRY')
  .default('15m')
  .asString() as StringValue

export const REFRESH_TOKEN_SECRET = env
  .get('REFRESH_TOKEN_SECRET')
  .required()
  .asString()
export const REFRESH_TOKEN_EXPIRY = env
  .get('REFRESH_TOKEN_EXPIRY')
  .default('90d')
  .asString() as StringValue

export const EMAIL_TOKEN_SECRET = env
  .get('EMAIL_TOKEN_SECRET')
  .required()
  .asString()
export const EMAIL_TOKEN_EXPIRY = env
  .get('EMAIL_TOKEN_EXPIRY')
  .default('7d')
  .asString() as StringValue
export const EMAIL_SENDER_DOMAIN = env
  .get('EMAIL_SENDER_DOMAIN')
  .required()
  .asString()
export const DISABLE_EMAILS = env
  .get('DISABLE_EMAILS')
  .default('false')
  .asBoolStrict()
export const MAILGUN_API_SECRET = env
  .get('MAILGUN_API_SECRET')
  .required(!DISABLE_EMAILS)
  .asString()

export const WEBAUTHN_RP_ID = env.get('WEBAUTHN_RP_ID').default(HOST).asString()
export const WEBAUTHN_RP_NAME = env
  .get('WEBAUTHN_RP_NAME')
  .required()
  .asString()
export const WEBAUTHN_RP_ORIGIN = env
  .get('WEBAUTHN_RP_ORIGIN')
  .default(`${HOST}:${PORT}`)
  .asString()
export const WEBAUTHN_ALLOW_INSECURE_ORIGIN = env
  .get('WEBAUTHN_ALLOW_INSECURE_ORIGIN')
  .default(`${!IS_PRODUCTION}`)
  .asBoolStrict()
export const WEBAUTHN_CHALLENGE_EXPIRY = env
  .get('WEBAUTHN_CHALLENGE_EXPIRY')
  .default('15m')
  .asString() as StringValue

export const CLIENT_URL = env
  .get('CLIENT_URL')
  .default('http://localhost:8080')
  .asString()
