import express from 'express'
import { useAsync } from '../../utils/async'
import { sendVerifyLink } from './sendVerifyLink'

export const emailRouter = express.Router()

emailRouter.post('/verify-link', useAsync(sendVerifyLink))
