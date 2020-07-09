# Zally Server
Frontend port: `8000`
Tomcat server port: `8080` & `7979`

This is Zally's heart - Zally Server. It implements all rule checks and offers an
API to request an API linting. It also provides permalinks and statistics functionalities.

## Build and Run

1. Clone Zally repository

```bash
git clone git@github.com:zalando/zally.git zally
```

1. Switch to `server` folder:

```bash
cd zally/server
```

1. Build the server:

```bash
./gradlew clean build
```

1. Run Zally server using:

```bash
./gradlew bootRun
```

The bootRun task is configured to run with 'dev' profile by default.

# Build with Docker (for Google Cloud Run)

## Build

```bash
docker build . --tag eu.gcr.io/[PROJECT_ID]/cloudbuilder-zally
```

## Push

```bash
docker push eu.gcr.io/[PROJECT_ID]/cloudbuilder-zally
```

## local testing of image
```bash
PORT=8080 && docker run -p 8080:${PORT} -e PORT=${PORT} -e MANAGEMENT_PORT=7979 gcr.io/[PROJECT_ID]/cloudbuilder-zally
```

# Usage

#### Argument
Only one argument is necessary to run: the api spec file. 

#### Deployment
Run the container before the deploy and after preparing the directory.
```bash
# Test Api spec using Zally
- name: 'eu.gcr.io/[PROJECT_ID]/cloudbuilder-zally'
  args: ['file.yamlorjson']
  dir: 'dir/to/file.yamlorjson'
```

#### Local
Run locally:
```bash
docker run -it -v $(pwd)/dir/to/file.yamlorjson:/openapi.yamlorjson eu.gcr.io/[PROJECT_ID]/cloudbuilder-zally openapi.yamlorjson
```




