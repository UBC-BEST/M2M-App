import { MongoClient, ServerApiVersion } from 'mongodb'
import { DB_NAME, MONGODB_CONNECTION_URI } from './env'
import {
  PasskeyChallengeDocument,
  PasskeyDocument,
  RefreshTokenDocument,
  UserDocument,
  LinkTokenDocument,
} from '../types/documents'

export const mongo = new MongoClient(MONGODB_CONNECTION_URI, {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  },
})

export const db = mongo.db(DB_NAME)
export const dbUsers = db.collection<UserDocument>('users')
export const dbRefreshTokens =
  db.collection<RefreshTokenDocument>('refresh_tokens')
export const dbLinkTokens = db.collection<LinkTokenDocument>('link_tokens')
export const dbPasskeys = db.collection<PasskeyDocument>('passkeys')
export const dbPasskeyChallenges =
  db.collection<PasskeyChallengeDocument>('passkey_challenges')

process.on('exit', mongo.close)
