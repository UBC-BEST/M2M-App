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

export class UnauthorizedError extends ResponseError {
  constructor(message: string) {
    super(message, 401)
    this.name = 'BadRequestError'
  }
}

export class ForbiddenError extends ResponseError {
  constructor(message: string) {
    super(message, 403)
    this.name = 'ForbiddenError'
  }
}

export class NotFoundError extends ResponseError {
  constructor(message: string) {
    super(message, 404)
    this.name = 'NotFoundError'
  }
}

export class DataConflictError extends ResponseError {
  constructor(message: string) {
    super(message, 409)
    this.name = 'DataConflictError'
  }
}

export class ServiceUnavailableError extends ResponseError {
  constructor(message: string) {
    super(message, 503)
    this.name = 'ServiceUnavailableError'
  }
}
