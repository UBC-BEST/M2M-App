import supertest = require('supertest')
import { db, dbUsers, mongo } from '../src/utils/database'
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
    return expect(dbUsers.findOne({ email: testEmail })).resolves.toBeTruthy()
  })

  test('/register FAIL: malformed request', async () => {
    const response = await agent.post('/user/register').send({
      displayName: testName,
      password: testPw,
    })

    expect(response.status).toBe(400)
  })

  test('/register FAIL: duplicate email', async () => {
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
    expect(response.body.message).toBeTruthy()
    expect(response.body.token).toBeTruthy()
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

  afterAll(async () => {
    // Remove test user so database returns to same state as before testing
    await dbUsers.deleteOne({ email: 'test@example.com' })
    await mongo.close()
  })
})
