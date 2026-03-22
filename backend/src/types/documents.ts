import { ObjectId } from 'mongodb'
import { AuthenticatorTransportFuture } from '@simplewebauthn/server'

export type RefreshTokenDocument = {
  userId: ObjectId
  token: string
  createdAt: number
}

export type VerifyTokenDocument = {
  userId: ObjectId
  email: string
  token: string
  createdAt: number
  expiresAt: number
}

export type UserDocument = {
  email: string
  pwHash: string
  displayName: string
  createdAt: number
  verified: boolean
}

export type PasskeyDocument = {
  userId: ObjectId
  credentialId: string
  publicKey: string
  counter: number
  deviceType: string
  backedUp: boolean
  createdAt: number
  lastUsedAt?: number
  transports?: AuthenticatorTransportFuture[]
  label: string
}

export type PasskeyChallengeDocument = {
  userId: ObjectId
  type: 'registration' | 'authentication'
  challenge: string
  createdAt: number
  expiresAt: number
}
