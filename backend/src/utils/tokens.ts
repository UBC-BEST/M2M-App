import { randomBytes } from 'node:crypto'
import jwt from 'jsonwebtoken'
import {
  ACCESS_TOKEN_EXPIRY,
  ACCESS_TOKEN_SECRET,
  EMAIL_TOKEN_EXPIRY,
  EMAIL_TOKEN_SECRET,
  IS_PRODUCTION,
  REFRESH_TOKEN_EXPIRY,
  REFRESH_TOKEN_SECRET,
} from './env'
import { ObjectId } from 'mongodb'
import { CookieOptions, Request, Response } from 'express'
import { dbRefreshTokens } from './database'
import ms from 'ms'
import { DateTime } from 'luxon'
import { BadRequestError, ForbiddenError } from './errors'
import { AccessTokenPayload, RefreshTokenPayload } from '../types/tokens'

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
 * Checks if the access token in the given request is legitimate and returns the payload if so
 * @param req fetch request with authorization header containing access token
 * @throws ResponseError if not provided with a valid access token
 */
export const validateAccessToken = (req: Request): AccessTokenPayload => {
  // Access token is retrieved from header `Authorization: Bearer <TOKEN>`
  const encodedToken = req.headers['authorization']?.split(' ').at(1)

  if (!encodedToken) {
    throw new BadRequestError('No access token provided')
  }

  try {
    const jwtResult = jwt.verify(
      encodedToken,
      ACCESS_TOKEN_SECRET
    ) as AccessTokenPayload

    // Cannot use decoded JWT directly because userId was compressed from ObjectId to string
    return {
      userId: new ObjectId(jwtResult.userId),
    }
  } catch (error) {
    throw new ForbiddenError('Malformed or expired access token')
  }
}

/**
 * Checks if the given refresh token  is legitimate and returns the payload if so
 * @param encodedToken encoded JWT refresh token
 * @throws ResponseError if not provided with a valid access token
 */
export const validateRefreshToken = (
  encodedToken: string
): RefreshTokenPayload => {
  try {
    const payload = jwt.verify(
      encodedToken,
      REFRESH_TOKEN_SECRET
    ) as RefreshTokenPayload

    // Cannot use decoded JWT directly because userId was compressed from ObjectId to string
    return {
      userId: new ObjectId(payload.userId),
      value: payload.value,
    }
  } catch (error) {
    throw new ForbiddenError('Malformed or expired refresh token')
  }
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

/**
 * Generates a token for use in
 */
export const generateEmailToken = async () => {
  // Use a randomized payload to ensure length and uniqueness of JWT
  const payload = randomBytes(16).toString('hex')
  const token = jwt.sign(payload, EMAIL_TOKEN_SECRET, {
    expiresIn: EMAIL_TOKEN_EXPIRY,
  })

  const createdAt = DateTime.now().toUnixInteger()
  const expiresAt = DateTime.now().plus(ms(EMAIL_TOKEN_EXPIRY)).toUnixInteger()

  return { token, createdAt, expiresAt }
}
