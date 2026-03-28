import express from 'express'
import { useAsync } from '../../utils/async'
import { sendEmailVerifyLink } from './sendEmailVerifyLink'

export const emailRouter = express.Router()

emailRouter.post('/verify-link', useAsync(sendEmailVerifyLink))
