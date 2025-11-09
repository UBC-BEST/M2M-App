import { RequestHandler } from 'express'
import argon2 from 'argon2'
import { dbUsers } from '../../utils/database'
import { useRefreshToken, generateAccessToken } from '../../utils/tokens'
import { BadRequestError, UnauthorizedError } from '../../utils/errors'

export const login: RequestHandler = async (req, res) => {
  const { email, password } = req.body

  if (!email || !password) {
    throw new BadRequestError('Malformed request')
  }

  const user = await dbUsers.findOne({ email })
  if (!user) {
    throw new UnauthorizedError('No account associated with this email')
  }

  const isPwMatch = await argon2.verify(user.pwHash, password)
  if (!isPwMatch) {
    throw new UnauthorizedError('Email and password do not match')
  }

  const accessToken = generateAccessToken(user._id)
  await useRefreshToken(user._id, res)

  res.status(200).json({ accessToken })
}
