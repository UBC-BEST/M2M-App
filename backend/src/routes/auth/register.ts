import { RequestHandler } from 'express'
import argon2 from 'argon2'
import { ObjectId } from 'mongodb'
import { DateTime } from 'luxon'
import { dbUsers } from '../../utils/database'
import { generateAccessToken, useRefreshToken } from '../../utils/tokens'
import { BadRequestError, DataConflictError } from '../../utils/errors'

export const register: RequestHandler = async (req, res) => {
  const { email, displayName, password } = req.body

  if (!email || !password || !displayName) {
    throw new BadRequestError('Malformed request')
  }

  if (await dbUsers.findOne({ email })) {
    throw new DataConflictError('Email associated with existing account')
  }

  // One-way hash ensures password can be verified but not decrypted
  const pwHash = await argon2.hash(password)
  const userId = new ObjectId()

  await dbUsers.insertOne({
    _id: userId,
    email,
    pwHash,
    displayName,
    createdAt: DateTime.now().toUnixInteger(),
    verified: false,
  })

  const accessToken = generateAccessToken(userId)
  await useRefreshToken(userId, res)

  res.status(201).json({ accessToken })
}
