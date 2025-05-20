import { randomBytes } from 'node:crypto'
import jwt from 'jsonwebtoken'
import {
  ACCESS_TOKEN_EXPIRY,
  ACCESS_TOKEN_SECRET,
  IS_PRODUCTION,
  REFRESH_TOKEN_EXPIRY,
  REFRESH_TOKEN_SECRET,
} from './env'
import { ObjectId } from 'mongodb'
import { CookieOptions, Response } from 'express'
import { dbRefreshTokens } from './database'
import ms from 'ms'
import { AccessTokenPayload, RefreshTokenPayload } from '../types/auth'
import { DateTime } from 'luxon'

export const refreshTokenOptions: CookieOptions = {
  httpOnly: true, // Not readable by client scripts (OAuth2 compliant)
  sameSite: 'strict',
  secure: IS_PRODUCTION,
  path: '/auth/',
}

/** Generate a temporary access token for the specified user */
export const generateAccessToken = (userId: ObjectId): string => {
  const payload: AccessTokenPayload = { userId }
  return jwt.sign(payload, ACCESS_TOKEN_SECRET, {
    expiresIn: ACCESS_TOKEN_EXPIRY,
  })
}

/**
 * Generate a long-term but revocable refresh token for the specified user, then save it to
 * database and response cookies
 */
export const useRefreshToken = async (userId: ObjectId, res: Response) => {
  const payload: RefreshTokenPayload = {
    userId,
    value: randomBytes(64).toString('hex'),
  }
  const refreshToken = jwt.sign(payload, REFRESH_TOKEN_SECRET, {
    expiresIn: REFRESH_TOKEN_EXPIRY,
  })

  // We save the entire signed JWT instead of only the randomly generated token value
  // for simplicity and to preempt potential expiry tampering
  await dbRefreshTokens.insertOne({
    userId,
    token: refreshToken,
    createdAt: DateTime.now().toUnixInteger(),
  })

  res.cookie('refreshToken', refreshToken, {
    ...refreshTokenOptions,
    maxAge: ms(REFRESH_TOKEN_EXPIRY),
  })
}
