import express from 'express'
import { login } from './login.js'

export const userRouter = express.Router()

userRouter.post('/login', login)
