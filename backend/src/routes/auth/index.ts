import express from 'express'
import { login } from './login'
import { register } from './register'
import { useAsync } from '../../utils/async'
import { logout } from './logout'
import { refresh } from './refresh'
import { passkeyRouter } from './passkey'
import { linkRouter } from './link/linkRouter'

export const authRouter = express.Router()

authRouter.post('/login', useAsync(login))
authRouter.post('/logout', useAsync(logout))
authRouter.post('/register', useAsync(register))
authRouter.post('/refresh', useAsync(refresh))
authRouter.use('/passkey', passkeyRouter)
authRouter.use('/link', linkRouter)
