import { RequestHandler } from 'express'
import { db } from '../../app'
import argon2 from 'argon2'
import { generateBase58Id } from '../../utils/helpers'
import { ObjectId } from 'mongodb'
import { DateTime } from 'luxon'

export const register: RequestHandler = async (req, res): Promise<any> => {
  const { email, displayName, password } = req.body

  if (!email || !password || !displayName) {
    return res.status(400).send('Malformed request.')
  }

  const users = db.collection('users')

  // Check if there exists an account associated with this email
  if (await users.findOne({ email })) {
    return res.status(409).send('Duplicate email.')
  }

  const pwHash = await argon2.hash(password)
  const uuid = generateBase58Id(16)

  // Add the new user to the database
  await users.insertOne({
    _id: new ObjectId(uuid),
    email,
    pwHash,
    displayName,
    createdAt: DateTime.now().toUnixInteger(),
    verified: false,
  })

  return res.status(201).send(`Created new user with id='${uuid}'`)
}
