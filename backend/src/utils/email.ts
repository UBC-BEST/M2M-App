import { ObjectId } from 'mongodb'
import { VerifyTokenPayload } from '../types/tokens'
import jwt from 'jsonwebtoken'
import { REFRESH_TOKEN_EXPIRY, REFRESH_TOKEN_SECRET } from './env'
import { dbVerifyTokens } from './database'
import { DateTime } from 'luxon'
import { randomBytes } from 'node:crypto'

/**
 * Generate a revocable email verification token for the specified user, then save it to
 * database
 */
export const useVerifyToken = async (userId: ObjectId, email: string) => {
  const payload: VerifyTokenPayload = {
    userId,
    email,
    value: randomBytes(16).toString('hex'),
  }

  const refreshToken = jwt.sign(payload, REFRESH_TOKEN_SECRET, {
    expiresIn: REFRESH_TOKEN_EXPIRY,
  })

  await dbVerifyTokens.insertOne({
    userId,
    email,
    token: refreshToken,
    createdAt: DateTime.now().toUnixInteger(),
  })

  return refreshToken
}
