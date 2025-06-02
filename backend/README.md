# M2M-App Backend
This README contains the developer startup guide and other core information on the Muscle to Movement project's application server.

## Getting Started
This guide assumes that you are already in the [UBC-BEST](https://github.com/UBC-BEST) organization, have cloned the parent repository onto your local system, and can open the project in an IDE.

1. [Install Node.js](https://nodejs.org/en/download) with Yarn. Alternatively, to enable Yarn with Node already installed, run `corepack enable` on an administrator command prompt.
2. Navigate to the `../M2M-App/backend` folder in a local terminal. If you are already in the root folder, run `cd backend`.
3. Run `yarn` to install all node dependencies. This may take a while.
4. Configure IDE integrations for [ESLint](https://eslint.org/docs/latest/use/integrations) and [Prettier](https://prettier.io/docs/editors) (see links). Enabling auto-format on save (or equivalent) is mandatory.
5. Set up a personal instance of MongoDB.
   1. [Create an account](https://account.mongodb.com/account/register) or [log in](https://account.mongodb.com/account/login).
   2. Create a new project and inside make a cluster called `m2m`.
   3. Navigate to Security > Database Access and create an admin user (use password for authentication).
   4. Navigate to Database > Clusters and click the connect button. Then go to Drivers > Node and save the connection string, which we will need for the next step.
6. Initialize environment variables.
   1. Create a file called `.env` in `../M2M-App/backend` and copy in the following template:
      ```
      HOST=http://localhost
      PORT=6969
      MONGODB_CONNECTION_URI=
      NODE_ENV=development
      DB_NAME=m2m
      ACCESS_TOKEN_SECRET=
      REFRESH_TOKEN_SECRET=
      ```
   2. For `MONGODB_CONNECTION_URI` use the connection string from above. Remember to replace the `<db_password>` part appropriately.
   3. For `ACCESS_TOKEN_SECRET` and `REFRESH_TOKEN_SECRET` respectively, run\
      `node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"`\
      then copy the result into the env variable. Note that the two secrets should NOT be the same.
7. Boot up the server by running `yarn start`. If everything was done correctly, the console output should be something like:
   
   ```
   Server running at http://localhost:6969
   Successfully connected to database 'm2m'
   ```
8. To verify server and database behavior against the test suite, open a new terminal and run `yarn test` while the server is active. If everything was set up correctly, the tests should all pass.

For additional assistance, contact James (@intonomist) on Discord.

## Recommended Readings
Developers working on the backend are expected to familizarize themselves with the following technologies:
* JavaScript ([docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Introduction))
* TypeScript ([docs](https://www.typescriptlang.org/docs/))
* MongoDB ([docs](https://www.mongodb.com/docs/manual/crud/))
* Express ([docs](https://expressjs.com/en/4x/api.html))
* Jest ([docs](https://jestjs.io/docs/using-matchers))

Note that while they are the most authoritative sources available, official documentation and [MDN Web Docs](https://developer.mozilla.org/en-US/) tend to be dense and contain more information than is required to work on the project.
Beginner-friendly alternatives exist, including [W3Schools](https://www.w3schools.com/), [web.dev](https://web.dev/), and [freeCodeCamp](https://www.freecodecamp.org/).

In addition, the following non-code resources are worth going through:
* [HTTP docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Overview) by MDN, specifically [request methods](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Methods) and [response codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status)
* [Security](https://developer.mozilla.org/en-US/docs/Web/Security) and [privacy](https://developer.mozilla.org/en-US/docs/Web/Privacy) on the web by MDN
* [Salted password hashing](https://crackstation.net/hashing-security.htm) by CrackStation

Finally, some other tools and libraries used are listed below (learn these on a need-to-know basis):
* ESBuild ([docs](https://esbuild.github.io/api/))
* Supertest ([docs](https://github.com/ladjs/supertest/blob/master/README.md))
* Luxon ([docs](https://moment.github.io/luxon/api-docs/index.html))
* Package.json ([docs](https://docs.npmjs.com/cli/configuring-npm/package-json))

## Style Guide
Code style for the backend is predominantly governed by and must always be compliant with ESLint and Prettier. Auto-format on save should be enabled at all times.

Apart from that, there are still some common conventions and patterns to watch for. This list is not exhaustive, and it is inevitable that some issues will not be caught until review.
* Use named exports (e.g. `export Component`) instead of default exports (e.g. `export default Component`).
* Use `let` or `const` instead of `var` or automatically declared (no keyword) variables.
* Use type-sensitive equality (`===` and `!==`) over type-insensitive equality (`==` and `!=`).
* Use literals `[]` and `{}` instead of the `Array()` and `Object()` constructors.

For more examples, see [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html) (we do not enforce all these rules, but it's a good starting point).

Some other things to keep in mind:
* [Best practices for writing code comments](https://stackoverflow.blog/2021/12/23/best-practices-for-writing-code-comments/) by Ellen Spertus
* Code in pull requests should pass all automated tests. Tests that are fail because they are outdated should be rewritten or deleted.
* Large subtasks and those used near-identically in multiple places should be moved into their own functions.

## File Structure
* Configuration files are located at root level
* `.env` System-specific environment variables
* `dist/` Automatically generated code
* `scripts/` Code not run within the application itself
* `src/` Application source code files
  * `app.ts` Entry point for server, is run on startup
  * `routes/` All endpoints for the REST API
    * `[routerName]/` Designated namespace
      * `index.ts` Set up a router and attach endpoints
      * `[endpointName].ts` RequestHandler middleware function for specified endpoint
  * `utils/` Helper files that do not specify endpoints
* `tests/` Automated test suites for the backend
