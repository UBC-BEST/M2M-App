import express from 'express'
import { modifyAccountInfo } from './modifyAccountInfo'
import { getAccountInfo } from './getAccountInfo'

export const accountRouter = express.Router()

accountRouter.post('/modify', modifyAccountInfo)
accountRouter.post('/get', getAccountInfo)
