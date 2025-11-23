import express from 'express'
import { modifyAccountInfo } from './modifyAccountInfo'
import { getAccountInfo } from './getAccountInfo'
import { useAsync } from '../../utils/async'

export const accountRouter = express.Router()

accountRouter.post('/modify', useAsync(modifyAccountInfo))
accountRouter.get('/get', useAsync(getAccountInfo))
