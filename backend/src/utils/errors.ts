export class ResponseError extends Error {
  status: number

  constructor(message: string, errorCode: number) {
    super(message)
    this.name = 'ResponseError'
    this.status = errorCode
  }
}

export class BadRequestError extends ResponseError {
  constructor(message: string) {
    super(message, 400)
    this.name = 'BadRequestError'
  }
}

export class ForbiddenError extends ResponseError {
  constructor(message: string) {
    super(message, 403)
    this.name = 'ForbiddenError'
  }
}
