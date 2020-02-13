FROM gradle:jdk8 as builder

COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN ./gradlew clean build -x test --stacktrace --scan --debug

FROM registry.opensource.zalan.do/stups/openjdk:latest as run

COPY src/main/resources/api/zally-api.yaml /usr/local/bin/zalando-apis/zally-api.yaml
COPY --from=builder /home/gradle/src/build/libs/zally.jar /usr/local/bin/zallyserver.jar

CMD chmod +x cli/zally
COPY cli/zally /usr/local/bin

COPY zally-lint.sh /
EXPOSE 8080
EXPOSE 8000

ENTRYPOINT ["bash", "/zally-lint.sh"]
