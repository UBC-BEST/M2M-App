import * as env from './utils/env'
import cors from 'cors'
import express, { ErrorRequestHandler } from 'express'
import { MongoClient, ServerApiVersion } from 'mongodb'
import { userRouter } from './routes/user'

// ----- SERVER AND DATABASE SETUP -----

export const mongoClient = new MongoClient(env.MONGODB_CONNECTION_URI, {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  },
})

export const app = express()
  .use(cors()) // Enable cross-origin requests for all clients
  .use(express.json())
  .use(express.urlencoded({ extended: false }))

// ----- MIDDLEWARE FUNCTIONS -----

app.use('/user', userRouter)
app.get('/', (req, res) => {
  res.send('Network connection successful. Server running...')
})

// ----- LIFECYCLE HANDLERS -----

// Startup
app.listen(env.PORT, () => {
  console.log(`Server running at ${env.HOST}:${env.PORT}`)
  // Send a ping to confirm a successful connection
  mongoClient
    .db('admin')
    .command({ ping: 1 })
    .then(() => console.log('Successfully connected to MongoDB!'))
})

// Errors (error handlers always have 4 arguments, it's an express thing)
// eslint-disable-next-line no-unused-vars
app.use(function (err, req, res, next) {
  console.error(err.message)
  res.status(err.status || 500).json({
    error: err.message || 'Internal Server Error',
  })
} as ErrorRequestHandler)

// Termination
process.on('exit', () => {
  void mongoClient.close()
})
