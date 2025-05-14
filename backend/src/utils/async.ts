import { RequestHandler } from 'express'

/**
 * Wraps and automatically handles errors for an asynchronous middleware function.
 * IMPORTANT: USE ON ALL ASYNC MIDDLEWARES OR THE SERVER WILL CRASH ON EXCEPTION
 */
export function useAsync(middleware: RequestHandler): RequestHandler {
  return async (req, res, next) => {
    try {
      await middleware(req, res, next)
    } catch (err) {
      next(err)
    }
  }
}
