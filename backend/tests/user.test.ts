import supertest = require('supertest')
import { server, mongo, db, exit } from '../src/app'

describe('/user', () => {
  const testEmail = 'test@example.com'
  const agent = supertest(server)

  test('Connect', async () => {
    const ping = async () => await db.command({ ping: 1 })
    expect(ping).not.toThrow()
  })

  test('/register SUCCESS', async () => {
    const response = await agent.post('/user/register').send({
      email: testEmail,
      displayName: 'Test Account',
      password: 'Test_123',
    })

    expect(response.status).toBe(201)
  })

  test('/register FAIL: malformed request', async () => {
    const response = await agent.post('/user/register').send({
      displayName: 'Test Account',
      password: 'Test_123',
    })

    expect(response.status).toBe(400)
  })

  test('/register FAIL: duplicate email', async () => {
    const response = await agent.post('/user/register').send({
      email: testEmail,
      displayName: 'Test Account',
      password: 'Test_123',
    })

    expect(response.status).toBe(409)
  })

  afterAll(async () => {
    // Remove test user so database returns to same state as before testing
    await db.collection('users').deleteOne({ email: 'test@example.com' })
    await exit()
  })
})
