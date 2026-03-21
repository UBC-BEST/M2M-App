import express from 'express'
import { useAsync } from '../../../utils/async'
import { authRouter } from '../index'
import { beginPasskeyRegister } from './beginPasskeyRegister'

export const passkeyRouter = express.Router()

authRouter.post('/register', useAsync(beginPasskeyRegister))
authRouter.post('/register/confirm', useAsync(beginPasskeyRegister))
authRouter.post('/login', useAsync(beginPasskeyRegister))
authRouter.post('/login/confirm', useAsync(beginPasskeyRegister))
