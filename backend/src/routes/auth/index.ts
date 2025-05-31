import express from 'express'
import { login } from './login'
import { register } from './register'
import { useAsync } from '../../utils/async'
import { logout } from './logout'
import { refresh } from './refresh'

export const authRouter = express.Router()

authRouter.post('/login', useAsync(login))
authRouter.post('/logout', useAsync(logout))
authRouter.post('/register', useAsync(register))
authRouter.post('/refresh', useAsync(refresh))
