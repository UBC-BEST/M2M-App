import { RequestHandler } from 'express'
import { db } from '../../app'
import * as env from '../../utils/env'
import argon2 from 'argon2'
import jwt from 'jsonwebtoken'

export const login: RequestHandler = async (req, res): Promise<any> => {
  const { email, password } = req.body

  if (!email || !password) {
    return res.status(400).send('Malformed request')
  }

  const users = db.collection('users')

  // Verify existence of user
  const user = await users.findOne({ email })
  if (!user) {
    return res.status(401).send('No account associated with this email')
  }

  const pwMatch = await argon2.verify(user.pwHash, password)
  if (!pwMatch) {
    return res.status(401).send('Email and password do not match')
  }

  const payload = { user: user._id }
  const token = jwt.sign(payload, env.JWT_SECRET, { expiresIn: '1h' })

  return res.status(200).json({ message: `Login successful`, token })
}
