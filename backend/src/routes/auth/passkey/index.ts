import express from 'express'
import { useAsync } from '../../../utils/async'
import { authRouter } from '../index'
import { registerPasskey } from './registerPasskey'

export const passkeyRouter = express.Router()

authRouter.post('/register', useAsync(registerPasskey))
