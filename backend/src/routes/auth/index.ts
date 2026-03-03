import express from 'express'
import { login } from './login'
import { register } from './register'
import { useAsync } from '../../utils/async'
import { logout } from './logout'
import { refresh } from './refresh'
import { verifyUserEmail } from './verifyUserEmail'
import { passkeyRouter } from './passkey'

export const authRouter = express.Router()

authRouter.post('/login', useAsync(login))
authRouter.post('/logout', useAsync(logout))
authRouter.post('/register', useAsync(register))
authRouter.post('/refresh', useAsync(refresh))
authRouter.post('/verify', useAsync(verifyUserEmail))
authRouter.use('/passkey', passkeyRouter)
