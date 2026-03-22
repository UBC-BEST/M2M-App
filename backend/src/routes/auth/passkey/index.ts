import express from 'express'
import { useAsync } from '../../../utils/async'
import { authRouter } from '../index'
import { beginPasskeyRegister } from './beginPasskeyRegister'
import { confirmPasskeyRegister } from './confirmPasskeyRegister'
import { beginPasskeyLogin } from './beginPasskeyLogin'
import { confirmPasskeyLogin } from './confirmPasskeyLogin'

export const passkeyRouter = express.Router()

authRouter.post('/register', useAsync(beginPasskeyRegister))
authRouter.post('/register/confirm', useAsync(confirmPasskeyRegister))
authRouter.post('/login', useAsync(beginPasskeyLogin))
authRouter.post('/login/confirm', useAsync(confirmPasskeyLogin))
