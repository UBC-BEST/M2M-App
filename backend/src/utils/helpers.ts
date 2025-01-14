import { randomInt } from 'node:crypto'

/** Generate a random string ID of specified length using Base58 (alphanumeric without lookalikes) */
export function generateBase58Id(length: number): string {
  const chars = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'

  let result = ''
  for (let i = 0; i < length; i++) {
    // Not using Math.random due to lack of cryptographic security
    result += chars[randomInt(chars.length)]
  }

  return result
}
