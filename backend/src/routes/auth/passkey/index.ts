import express from 'express'
import { useAsync } from '../../../utils/async'
import { beginPasskeyRegister } from './beginPasskeyRegister'
import { confirmPasskeyRegister } from './confirmPasskeyRegister'
import { beginPasskeyLogin } from './beginPasskeyLogin'
import { confirmPasskeyLogin } from './confirmPasskeyLogin'
import { getPasskeys } from './getPasskeys'
import { removePasskey } from './removePasskey'
import { NotFoundError } from '../../../utils/errors'

export const passkeyRouter = express.Router()

passkeyRouter.post('/register', useAsync(beginPasskeyRegister))
passkeyRouter.post('/register/confirm', useAsync(confirmPasskeyRegister))
passkeyRouter.post('/login', useAsync(beginPasskeyLogin))
passkeyRouter.post('/login/confirm', useAsync(confirmPasskeyLogin))
passkeyRouter.get('/get', useAsync(getPasskeys))
passkeyRouter.post('/remove/:id', useAsync(removePasskey))
passkeyRouter.post('/remove', () => {
  throw new NotFoundError('No passkey id specified')
})
