import { ObjectId } from 'mongodb'

export type AccessTokenPayload = {
  userId: ObjectId
}

export type RefreshTokenPayload = {
  userId: ObjectId
  /** Randomly generated filler string used to ensure token uniqueness */
  value: string
}
