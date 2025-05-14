import { ObjectId } from 'mongodb'

export type AccessTokenPayload = {
  userId: ObjectId
}

export type RefreshTokenPayload = {
  userId: ObjectId
  value: string
}
