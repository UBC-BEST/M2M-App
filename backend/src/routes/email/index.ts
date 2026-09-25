import express from 'express'
import { useAsync } from '../../utils/async'
import { sendEmailVerifyLink } from './sendEmailVerifyLink'
import { sendLoginLink } from './sendLoginLink'

export const emailRouter = express.Router()

emailRouter.post('/send-verify-link', useAsync(sendEmailVerifyLink))
emailRouter.post('/send-login-link', useAsync(sendLoginLink))
