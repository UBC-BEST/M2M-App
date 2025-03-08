import cors from 'cors'
import express, { ErrorRequestHandler } from 'express'
import { userRouter } from './routes/user'
import { db } from './utils/database'
import { DB_NAME, HOST, PORT } from './utils/env'
import cookieParser from 'cookie-parser'

// ----- SERVER SETUP -----

export const app = express()
  .use(cors()) // Enable cross-origin requests for all clients
  .use(express.json())
  .use(express.urlencoded({ extended: false }))
  .use(cookieParser())

// ----- MIDDLEWARE FUNCTIONS -----

app.use('/user', userRouter)
app.get('/', (req, res) => {
  res.send('Network connection successful. Server running...')
})

// ----- LIFECYCLE HANDLERS -----

// Start server
export const server = app.listen(PORT, () => {
  console.debug(`Server running at ${HOST}:${PORT}`)
  // Send a ping to check database status
  db.command({ ping: 1 }).then(
    () => console.debug(`Successfully connected to database '${DB_NAME}'`),
    err => {
      console.error('MONGODB CONNECTION ERROR', err)
      process.exitCode = 1 // Terminate on database connect fail
    }
  )
})

// Errors (error handlers always have 4 arguments, it's an express thing)
// eslint-disable-next-line no-unused-vars
app.use(function (err, req, res, next) {
  console.error(err.message)
  res.status(err.status || 500).send(err.message || 'Internal Server Error')
} as ErrorRequestHandler)

// Termination
process.on('exit', server.close)
