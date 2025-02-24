import { RequestHandler } from 'express'
import argon2 from 'argon2'
import jwt from 'jsonwebtoken'
import { dbTokens, dbUsers } from '../../utils/database'
import { ACCESS_TOKEN_SECRET, REFRESH_TOKEN_SECRET } from '../../utils/env'
import { randomBytes } from 'node:crypto'

export const login: RequestHandler = async (req, res): Promise<any> => {
  const { email, password } = req.body

  if (!email || !password) {
    return res.status(400).send('Malformed request')
  }

  // Check existence of user in database
  const user = await dbUsers.findOne({ email })
  if (!user) {
    return res.status(401).send('No account associated with this email')
  }

  // Verify input against password hash
  const pwMatch = await argon2.verify(user.pwHash, password)
  if (!pwMatch) {
    return res.status(401).send('Email and password do not match')
  }

  // Generate initial JWT access token for this login
  const accessPayload = { user: user._id, email }
  const accessOptions = { expiresIn: '15m' }
  const accessToken = jwt.sign(
    accessPayload,
    ACCESS_TOKEN_SECRET,
    accessOptions
  )

  // Generate refresh token
  const refreshPayload = {
    user: user._id,
    token: randomBytes(64).toString('hex'),
  }
  const refreshOptions = { expiresIn: '30d' }
  const refreshToken = jwt.sign(
    refreshPayload,
    REFRESH_TOKEN_SECRET,
    refreshOptions
  )

  await dbTokens.insertOne({ userId: user._id, token: refreshToken })

  return res.status(200).json({ accessToken, refreshToken })
}
