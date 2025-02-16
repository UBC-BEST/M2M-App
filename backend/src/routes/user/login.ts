import { RequestHandler } from 'express'
import argon2 from 'argon2'
import jwt from 'jsonwebtoken'
import { dbUsers } from '../../utils/database'
import { JWT_SECRET } from '../../utils/env'

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

  // Generate a JSON Web Token for this session
  const payload = { user: user._id }
  const token = jwt.sign(payload, JWT_SECRET, { expiresIn: '1h' })

  return res.status(200).json({ message: `Login successful`, token })
}
