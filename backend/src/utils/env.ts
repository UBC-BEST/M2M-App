import 'dotenv/config'
import env from 'env-var'
import { StringValue } from 'ms'

export const PORT = env.get('PORT').default(9000).asPortNumber()
export const HOST = env.get('HOST').default('http://localhost').asString()

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

const NODE_ENV = env.get('NODE_ENV').default('development').asString()
export const IS_PRODUCTION = NODE_ENV === 'production'
