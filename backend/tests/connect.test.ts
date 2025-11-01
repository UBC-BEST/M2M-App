import { db } from '../src/utils/database'

test('Connect', async () => {
  const ping = async () => await db.command({ ping: 1 })
  expect(ping).not.toThrow()
})
