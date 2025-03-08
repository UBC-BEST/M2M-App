import { RequestHandler } from 'express'
import argon2 from 'argon2'
import { ObjectId } from 'mongodb'
import { DateTime } from 'luxon'
import { randomBytes } from 'node:crypto'
import { dbUsers } from '../../utils/database'
import { generateAccessToken, useRefreshToken } from '../../utils/tokens'

export const register: RequestHandler = async (req, res): Promise<any> => {
  const { email, displayName, password } = req.body

  if (!email || !password || !displayName) {
    return res.status(400).send('Malformed request')
  }

  // Check if there exists an account associated with this email
  if (await dbUsers.findOne({ email })) {
    return res.status(409).send('Duplicate email')
  }

  // One-way hash ensures password can be verified but not decrypted
  const pwHash = await argon2.hash(password)
  const userId = new ObjectId(randomBytes(12).toString('hex'))

  // Add the new user to the database
  await dbUsers.insertOne({
    _id: userId,
    email,
    pwHash,
    displayName,
    createdAt: DateTime.now().toUnixInteger(),
    verified: false,
  })

  // Generate access and refresh tokens for the user client
  const accessToken = generateAccessToken(userId)
  await useRefreshToken(userId, res)

  return res.status(201).json({ accessToken })
}
