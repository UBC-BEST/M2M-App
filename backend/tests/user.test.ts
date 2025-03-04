import supertest = require('supertest')
import { db, dbRefreshTokens, dbUsers } from '../src/utils/database'
import { HOST, PORT } from '../src/utils/env'

describe('/user', () => {
  const testEmail = 'test@example.com'
  const testName = 'Test Account'
  const testPw = 'Test_123'
  const agent = supertest(`${HOST}:${PORT}`)

  test('Connect', async () => {
    const ping = async () => await db.command({ ping: 1 })
    expect(ping).not.toThrow()
  })

  test('/register SUCCESS', async () => {
    const response = await agent.post('/user/register').send({
      email: testEmail,
      displayName: testName,
      password: testPw,
    })

    expect(response.status).toBe(201)
    expect(response.body.accessToken).toBeTruthy()

    const user = await dbUsers.findOne({ email: testEmail })
    expect(user).toBeTruthy()

    const refreshToken = await dbRefreshTokens.findOne({ userId: user?._id })
    expect(refreshToken).toBeTruthy()
  })

  test('/register FAIL: Malformed request', async () => {
    const response = await agent.post('/user/register').send({
      displayName: testName,
      password: testPw,
    })

    expect(response.status).toBe(400)
  })

  test('/register FAIL: Duplicate email', async () => {
    const response = await agent.post('/user/register').send({
      email: testEmail,
      displayName: testName,
      password: testPw,
    })

    expect(response.status).toBe(409)
  })

  test('/login SUCCESS', async () => {
    const response = await agent.post('/user/login').send({
      email: testEmail,
      password: testPw,
    })

    expect(response.status).toBe(200)
    expect(response.body.accessToken).toBeTruthy()
  })

  test('/login FAIL: Malformed request', async () => {
    const response = await agent.post('/user/login').send({
      email: testEmail,
    })

    expect(response.status).toBe(400)
  })

  test('/login FAIL: Invalid email', async () => {
    const response = await agent.post('/user/login').send({
      email: testEmail + 'x',
      password: testPw,
    })

    expect(response.status).toBe(401)
  })

  test('/login FAIL: Invalid password', async () => {
    const response = await agent.post('/user/login').send({
      email: testEmail,
      password: testPw + '4',
    })

    expect(response.status).toBe(401)
  })

  test('/logout SUCCESS', async () => {
    const user = await dbUsers.findOne({ email: testEmail })
    const refreshToken = await dbRefreshTokens.findOne({ userId: user?._id })

    const response = await agent
      .post('/user/logout')
      .set('Cookie', `refreshToken=${refreshToken?.value}`)
      .send({})
    expect(response.status).toBe(200)
  })

  test('/logout FAIL: No session', async () => {
    const response = await agent.post('/user/logout').send({})
    expect(response.status).toBe(400)
  })

  test('/logout FAIL: Invalid refresh token', async () => {
    const response = await agent
      .post('/user/logout')
      .set('Cookie', `refreshToken=123def`)
      .send({})
    expect(response.status).toBe(401)
  })

  afterAll(async () => {
    // Remove test user and related data so database returns to same state as before testing
    const user = await dbUsers.findOne({ email: testEmail })
    await dbRefreshTokens.deleteMany({ userId: user?._id })
    await dbUsers.deleteOne({ _id: user?._id })
  })
})
