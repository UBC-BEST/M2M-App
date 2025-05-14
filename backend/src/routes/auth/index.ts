import express from 'express'
import { login } from './login'
import { register } from './register'
import { useAsync } from '../../utils/async'
import { logout } from './logout'

export const authRouter = express.Router()

authRouter.post('/login', useAsync(login))
authRouter.post('/logout', useAsync(logout))
authRouter.post('/register', useAsync(register))
