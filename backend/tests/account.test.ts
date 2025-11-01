import { HOST, PORT } from '../src/utils/env'
import supertest = require('supertest')
import { WithId } from 'mongodb'
import { UserDocument } from '../src/types/documents'

describe('/account', () => {
  const testEmail = 'test@example.com'
  const testName = 'Test Account'
  const testPw = 'Test_123'
  const agent = supertest(`${HOST}:${PORT}`)

  // IMPORTANT: TEST ORDER AFFECTS THE ENTRIES BELOW AND THEIR CORRESPONDING DATABASE ENTRIES
  let user: WithId<UserDocument>
  let refreshToken: string
})
