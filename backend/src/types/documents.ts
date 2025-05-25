import { ObjectId } from 'mongodb'

export type RefreshTokenDocument = {
  userId: ObjectId
  token: string
  createdAt: number
}

export type UserDocument = {
  email: string
  pwHash: string
  displayName: string
  createdAt: number
  verified: boolean
}
