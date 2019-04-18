# Zally Server

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
docker build . --tag gcr.io/[PROJECT_ID]/zallylinter
```

## Push

```bash
docker push gcr.io/[PROJECT_ID]/zallylinter
```

## local testing of image
```bash
PORT=8080 && docker run -p 8080:${PORT} -e PORT=${PORT} -e MANAGEMENT_PORT=7979 gcr.io/[PROJECT_ID]/zallylinter
```



