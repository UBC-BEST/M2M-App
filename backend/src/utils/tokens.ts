import { randomBytes } from 'node:crypto'
import jwt, { SignOptions } from 'jsonwebtoken'
import { ACCESS_TOKEN_SECRET, REFRESH_TOKEN_SECRET } from './env'
import { ObjectId } from 'mongodb'
import { dbRefreshTokens } from './database'

/** Generate a revocable refresh token for the specified user and save it to the database */
export const generateRefreshToken = async (
  userId: ObjectId
): Promise<string> => {
  const payload = { userId, token: randomBytes(64).toString('hex') }
  const options: SignOptions = { expiresIn: '90d' }
  const token = jwt.sign(payload, REFRESH_TOKEN_SECRET, options)

  await dbRefreshTokens.insertOne({ userId, token })

  return token
}

/** Generate a temporary access token for the specified user */
export const generateAccessToken = (userId: ObjectId): string => {
  const payload = { userId: userId }
  const options = { expiresIn: '15m' }
  return jwt.sign(payload, ACCESS_TOKEN_SECRET, options)
}
