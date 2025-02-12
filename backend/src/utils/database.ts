import { MongoClient, ServerApiVersion } from 'mongodb'
import { DB_NAME, MONGODB_CONNECTION_URI } from './env'

export const mongo = new MongoClient(MONGODB_CONNECTION_URI, {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  },
})

export const db = mongo.db(DB_NAME)
