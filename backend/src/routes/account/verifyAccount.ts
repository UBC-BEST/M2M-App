import { RequestHandler } from 'express'

export const verifyAccount: RequestHandler = async (req, res) => {
  const verifyToken = req.body.token
}
