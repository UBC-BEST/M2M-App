import { RequestHandler } from 'express'

export const logout: RequestHandler = async (req, res): Promise<any> => {
  // TODO: Need to first implement user sessions in database
  res.status(200).send('WIP')
}
