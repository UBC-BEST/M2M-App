import { randomBytes } from 'node:crypto'
import jwt from 'jsonwebtoken'
import { ACCESS_TOKEN_SECRET, IS_PRODUCTION, REFRESH_TOKEN_SECRET } from './env'
import { ObjectId } from 'mongodb'
import { CookieOptions, Response } from 'express'
import { dbRefreshTokens } from './database'
import ms from 'ms'

const refreshTokenExpiry = '90d'
export const refreshTokenOptions: CookieOptions = {
  httpOnly: true, // Not readable by client scripts (OAuth2 compliant)
  sameSite: 'strict',
  secure: IS_PRODUCTION,
  maxAge: ms(refreshTokenExpiry),
}

/** Generate a temporary access token for the specified user */
export const generateAccessToken = (userId: ObjectId): string => {
  const payload = { userId }
  return jwt.sign(payload, ACCESS_TOKEN_SECRET, { expiresIn: '15m' })
}

/** Generate a revocable refresh token for the specified user, then save it to database and response cookies */
export const useRefreshToken = async (userId: ObjectId, res: Response) => {
  const payload = { userId, token: randomBytes(64).toString('hex') }
  const token = jwt.sign(payload, REFRESH_TOKEN_SECRET, {
    expiresIn: refreshTokenExpiry,
  })

  await dbRefreshTokens.insertOne({ userId, token })

  res.cookie('refreshToken', token, refreshTokenOptions)
}
