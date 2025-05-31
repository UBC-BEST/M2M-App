import supertest = require('supertest')
import { db, dbRefreshTokens, dbUsers, mongo } from '../src/utils/database'
import { HOST, PORT } from '../src/utils/env'
import { WithId } from 'mongodb'
import { UserDocument } from '../src/types/documents'

describe('/auth', () => {
  const testEmail = 'test@example.com'
  const testName = 'Test Account'
  const testPw = 'Test_123'
  const agent = supertest(`${HOST}:${PORT}`)

  // IMPORTANT: TEST ORDER AFFECTS THE ENTRIES BELOW AND THEIR CORRESPONDING DATABASE ENTRIES
  let user: WithId<UserDocument>
  let refreshToken: string

  test('Connect', async () => {
    const ping = async () => await db.command({ ping: 1 })
    expect(ping).not.toThrow()
  })

  describe('/register', () => {
    test('SUCCESS', async () => {
      const response = await agent.post('/auth/register').send({
        email: testEmail,
        displayName: testName,
        password: testPw,
      })

      expect(response.status).toBe(201)
      expect(response.body.accessToken).toBeTruthy()

      user = (await dbUsers.findOne({ email: testEmail }))!
      expect(user).toBeTruthy()

      refreshToken = (await dbRefreshTokens.findOne({ userId: user._id }))!
        .token
      expect(refreshToken).toBeTruthy()
    })

    test('FAIL: Malformed request', async () => {
      const response = await agent.post('/auth/register').send({
        displayName: testName,
        password: testPw,
      })

      expect(response.status).toBe(400)
    })

    test('FAIL: Duplicate email', async () => {
      const response = await agent.post('/auth/register').send({
        email: testEmail,
        displayName: testName,
        password: testPw,
      })

      expect(response.status).toBe(409)
    })
  })

  describe('/login', () => {
    test('SUCCESS', async () => {
      const response = await agent.post('/auth/login').send({
        email: testEmail,
        password: testPw,
      })

      expect(response.status).toBe(200)
      expect(response.body.accessToken).toBeTruthy()
    })

    test('FAIL: Malformed request', async () => {
      const response = await agent.post('/auth/login').send({
        email: testEmail,
      })

      expect(response.status).toBe(400)
    })

    test('FAIL: Invalid email', async () => {
      const response = await agent.post('/auth/login').send({
        email: testEmail + 'x',
        password: testPw,
      })

      expect(response.status).toBe(401)
    })

    test('FAIL: Invalid password', async () => {
      const response = await agent.post('/auth/login').send({
        email: testEmail,
        password: testPw + '4',
      })

      expect(response.status).toBe(401)
    })
  })

  describe('/refresh', () => {
    let expiredToken: string

    test('/refresh SUCCESS', async () => {
      const response = await agent
        .post('/auth/refresh')
        .set('Cookie', `refreshToken=${refreshToken}`)
        .send({})

      expiredToken = refreshToken
      refreshToken = (await dbRefreshTokens.findOne({ userId: user._id }))!
        .token

      expect(response.status).toBe(200)
    })

    test('/refresh FAIL: No refresh token', async () => {
      const response = await agent.post('/auth/refresh').send({})
      expect(response.status).toBe(401)
    })

    test('/refresh FAIL: Malformed refresh token', async () => {
      const response = await agent
        .post('/auth/refresh')
        .set('Cookie', `refreshToken=abc456`)
        .send({})

      expect(response.status).toBe(403)
    })

    test('/refresh FAIL: Invalid refresh token', async () => {
      const response = await agent
        .post('/auth/refresh')
        .set('Cookie', `refreshToken=${expiredToken}`) // NOTE: this is the old refresh token
        .send({})

      expect(response.status).toBe(403)
    })
  })

  describe('/logout', () => {
    test('/logout SUCCESS', async () => {
      const response = await agent
        .post('/auth/logout')
        .set('Cookie', `refreshToken=${refreshToken}`)
        .send({})
      expect(response.status).toBe(200)
    })

    test('/logout FAIL: No session', async () => {
      const response = await agent.post('/auth/logout').send({})
      expect(response.status).toBe(400)
    })

    test('/logout FAIL: Invalid refresh token', async () => {
      const response = await agent
        .post('/auth/logout')
        .set('Cookie', `refreshToken=123def`)
        .send({})
      expect(response.status).toBe(401)
    })
  })

  afterAll(async () => {
    // Remove test user and related data so database returns to same state as before testing
    await dbRefreshTokens.deleteMany({ userId: user._id })
    await dbUsers.deleteOne({ _id: user._id })

    await mongo.close()
  })
})
