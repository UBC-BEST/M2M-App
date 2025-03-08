import express from 'express'
import { login } from './login'
import { register } from './register'
import { useAsync } from '../../utils/async'
import { logout } from './logout'

export const userRouter = express.Router()

userRouter.post('/login', useAsync(login))
userRouter.post('/logout', useAsync(logout))
userRouter.post('/register', useAsync(register))
