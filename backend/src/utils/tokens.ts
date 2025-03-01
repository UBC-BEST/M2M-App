import { randomBytes } from 'node:crypto'
import jwt, { SignOptions } from 'jsonwebtoken'
import { ACCESS_TOKEN_SECRET, IS_PRODUCTION, REFRESH_TOKEN_SECRET } from './env'
import { ObjectId } from 'mongodb'
import { Response } from 'express'
import { dbRefreshTokens } from './database'
import ms from 'ms'

/** Generate a temporary access token for the specified user */
export const generateAccessToken = (userId: ObjectId): string => {
  const payload = { userId: userId }
  return jwt.sign(payload, ACCESS_TOKEN_SECRET, { expiresIn: '15m' })
}

/** Generate a revocable refresh token for the specified user, then save it to database and response cookies */
export const useRefreshToken = async (userId: ObjectId, res: Response) => {
  const expiresIn = '90d'

  const payload = { userId, token: randomBytes(64).toString('hex') }
  const token = jwt.sign(payload, REFRESH_TOKEN_SECRET, { expiresIn })

  await dbRefreshTokens.insertOne({ userId, token })

  res.cookie('m2m_refresh_token', token, {
    httpOnly: true, // Not readable by client scripts (OAuth2 compliant)
    sameSite: 'none',
    secure: IS_PRODUCTION,
    maxAge: ms(expiresIn),
  })
}
