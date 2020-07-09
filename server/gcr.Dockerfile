FROM openjdk:8-jdk-slim as builder
COPY . /src
WORKDIR /src
RUN ./gradlew build -x test

FROM openjdk:8-jdk-slim as run

COPY src/main/resources/api/zally-api.yaml /usr/local/bin/zalando-apis/zally-api.yaml
COPY --from=builder /src/build/libs/zally.jar /usr/local/bin/zallyserver.jar

CMD chmod +x cli/zally
COPY cli/zally /usr/local/bin

RUN apt-get update && apt-get install lsof

COPY zally-lint.sh /
EXPOSE 8080
EXPOSE 8000

ENTRYPOINT ["bash", "/zally-lint.sh"]
