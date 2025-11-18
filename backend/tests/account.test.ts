import { HOST, PORT } from '../src/utils/env'
import supertest = require('supertest')
import { WithId } from 'mongodb'
import { UserDocument } from '../src/types/documents'
import { dbRefreshTokens, dbUsers, mongo } from '../src/utils/database'

describe('/account', () => {
  const testEmail = 'account@test.com'
  const testName = 'Account Test'
  const testPw = 'Test_456'
  const agent = supertest(`${HOST}:${PORT}`)

  // IMPORTANT: TEST ORDER AFFECTS THE ENTRIES BELOW AND THEIR CORRESPONDING DATABASE ENTRIES
  let user: WithId<UserDocument>
  let accessToken: string

  beforeAll(async () => {
    const registerResponse = await agent
      .post('/auth/register')
      .send({ email: testEmail, displayName: testName, password: testPw })

    user = (await dbUsers.findOne({ email: testEmail }))!
    accessToken = registerResponse.body.accessToken
  })

  describe('/get', () => {
    test('SUCCESS', async () => {
      const response = await agent
        .get('/account/get')
        .set('Authorization', `Bearer ${accessToken}`)
        .send()
      const account = response.body as UserDocument

      expect(response.status).toBe(200)
      expect(account.email).toBe(user.email)
      expect(account.displayName).toBe(user.displayName)
      expect(account.createdAt).toBe(user.createdAt)
      expect(account.verified).toBe(user.verified)
    })

    // NOTE: These tests cover access token handling for all routes requiring a user
    test('FAIL: No access token', async () => {
      const response = await agent.get('/account/get').send()
      expect(response.status).toBe(400)
    })

    test('FAIL: Invalid access token', async () => {
      const response = await agent
        .get('/account/get')
        .set('Authorization', `Bearer zxcvbnm`)
        .send()
      expect(response.status).toBe(403)
    })
  })

  describe('/modify', () => {
    test('SUCCESS', async () => {
      const newName = 'Test Account'
      const response = await agent
        .post('/account/modify')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ displayName: newName })

      user = (await dbUsers.findOne({ email: testEmail }))!

      expect(response.status).toBe(200)
      expect(user.displayName).toBe(newName)
    })
  })

  afterAll(async () => {
    // Remove test user and related data so database returns to same state as before testing
    await dbRefreshTokens.deleteMany({ userId: user._id })
    await dbUsers.deleteOne({ _id: user._id })

    await mongo.close()
  })
})
