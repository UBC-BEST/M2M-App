import { RequestHandler } from 'express'
import argon2 from 'argon2'
import { dbUsers } from '../../utils/database'
import { useRefreshToken, generateAccessToken } from '../../utils/tokens'

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

  // Generate access and refresh tokens for the user client
  const accessToken = generateAccessToken(user._id)
  await useRefreshToken(user._id, res)

  return res.status(200).json({ accessToken })
}
