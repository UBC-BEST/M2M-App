import express from 'express'
import { modifyAccountInfo } from './modifyAccountInfo'
import { getAccountInfo } from './getAccountInfo'
import { useAsync } from '../../utils/async'
import { verifyAccount } from './verifyAccount'

export const accountRouter = express.Router()

accountRouter.post('/modify', useAsync(modifyAccountInfo))
accountRouter.get('/get', useAsync(getAccountInfo))
accountRouter.post('/verify', useAsync(verifyAccount))
