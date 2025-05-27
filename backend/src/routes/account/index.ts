import express from 'express'
import { modifyAccountInfo } from './modifyAccountInfo'

export const accountRouter = express.Router()

accountRouter.post('/modify', modifyAccountInfo)
