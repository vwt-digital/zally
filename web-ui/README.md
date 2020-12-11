[![dependencies Status](https://david-dm.org/zalando/zally-web-ui/status.svg)](https://david-dm.org/zalando/zally-web-ui)
[![codecov](https://codecov.io/gh/zalando/zally-web-ui/branch/master/graph/badge.svg)](https://codecov.io/gh/zalando/zally-web-ui)

Zally WEB-UI
============

The project provides a simple web user interface client for [Zally Server](../server),
a tool to lint your OpenAPI specs.

It's implemented as an [express](https://expressjs.com/) app/middleware and a Single Page Application based on [React](https://facebook.github.io/react/).

## Main features

* lint api spec by url or using the built-in yaml/json editor
* show active/inactive supported lint rules
* optional authentication hooks

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Contents

- [Requirements](#requirements)
- [Install](#install)
- [Usage](#usage)
  - [Basic](#basic)
  - [Mount to an existing application](#mount-to-an-existing-application)
  - [Configuration options](#configuration-options)
    - [Options](#options)
  - [Add Authentication](#add-authentication)
      - [POST /auth/me](#post-authme)
      - [GET /auth/login](#get-authlogin)
      - [GET /auth/logout](#get-authlogout)
      - [POST /auth/refresh-token *(optional)*](#post-authrefresh-token-optional)
- [Development](#development)
  - [Install, build and run in development mode](#install-build-and-run-in-development-mode)
  - [Run in production mode](#run-in-production-mode)
  - [Build optimized client javascript bundle](#build-optimized-client-javascript-bundle)
- [Contributing](#contributing)
  - [Contact](#contact)
  - [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Requirements

* NodeJS >= 7.6

## Install

```bash
npm install zally-web-ui --save
```
or 
```bash
yarn add zally-web-ui
```

## Usage

### Basic

```js
const app = require('zally-web-ui')();

app.listen(3000, () => {
  console.log('zally-web-ui running at http://localhost:3000');
});
```

### Mount to an existing application

```js
const app = require('express')()
const zally = require('zally-web-ui')(/*options*/);

app.use('/api-linter', zally);
app.listen(3000, () => {
  console.log('server running at http://localhost:3000');
});
```

### Configuration options

When instantiating the app you can pass an `options` object to customize the behavior. 

```js
const options = { /* ..my options.. */}
const zally = require('zally-web-ui')(options);
```

#### Options

* **windowEnv**: the windowEnv `object` contains all the values exposed to the client on `window.env` 
* **windowEnv.OAUTH_ENABLED** (default: `false`): enable OAuth or just Auth support on the client side (an http call will be fired on `/auth/me` endpoint to get the current logged in user, if any)  
* **windowEnv.ZALLY_API_URL** (default: `http://localhost:8080`): URL pointing to Zally REST API
* **windowEnv.DEBUG** (default: `true`): logs debugging message on the client side
* **logger** (default: `console`): custom logger
* **handlers**: the handlers `object` contains all route handlers used by zally-web-ui
* **handlers.assets**: handler that serve static assets
* **handlers.windowEnv**: handler that serve `/env.js` javascript file used to expose `windowEnv` values to the client on `window.env`
* **handlers.index**: handler that serve the single page application entrypoint on the wild card `*` to allow HTML5 History API working as expected


### Add Authentication

To add authentication the express server serving zally-web-ui **MUST** implement some REST API JSON endpoints and set `windowEnv.OAUTH_ENABLED` to `true`.

##### POST /auth/me
  
Should respond back with `200` http status code and a json response containing the current connected user in this format:

```json
{
  "username": "John Doe",
  "authenticated": true
}
```
  
Or with `401` http status code if the user is not connected
  
##### GET /auth/login
   
To show a login or redirect to an external login (if for example you are using some OAuth Provider)
   
##### GET /auth/logout
   
To logout the user (for example clearing the session, etc.)
   
##### POST /auth/refresh-token *(optional)*
  
Optionally implement this endpoint to refresh an expired token (if for example you are using some OAuth Provider that support this feature)

## Development

> A Zally Rest Api server **MUST** be running on your local machine or somewhere over the network. <br>
 Use `windowEnv.ZALLY_API_URL` configuration option to set the desired value.

### Install, build and run in development mode

```
yarn
yarn dev
```

> The `yarn dev` task starts the application server in development mode with **nodemon** and **webpack-dev-server** watching for changes.<br>
  The application server acts as a proxy to webpack-dev-server as the target.

### Run in production mode

```
yarn build
yarn start
```

### Build optimized client javascript bundle

Build webpack bundle minified and source-map file(s).

```
yarn build
```

## Release it

1. Create a pull request for the new version (e.g. branch`web-ui-release-1.1`)
    1. Bump the package version in `package.json`
    1. Add changelog information and adjust documentation
1. Publish the new version after the pull request is merged (`npm login && npm publish --access=public`)

## Contributing

People interested contributing to the web-ui project can open issues and related pull requests. 

Before opening PRs, be sure the test are running by executing `yarn test`.

### Contact

Feel free to contact one the [maintainers](MAINTAINERS)

### License

MIT license with an exception. See [license file](LICENSE).
