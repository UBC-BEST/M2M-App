import express from 'express'
import { useAsync } from '../../../utils/async'
import { applyEmailVerifyLink } from './applyEmailVerifyLink'
import { applyLoginLink } from './applyLoginLink'

export const linkRouter = express.Router()

linkRouter.post('/verify', useAsync(applyEmailVerifyLink))
linkRouter.post('/login', useAsync(applyLoginLink))
