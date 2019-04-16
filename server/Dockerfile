FROM gradle:jdk10 as builder

COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN ./gradlew clean build 

FROM registry.opensource.zalan.do/stups/openjdk:latest as run

COPY src/main/resources/api/zally-api.yaml /zalando-apis/zally-api.yaml
COPY --from=builder /home/gradle/src/build/libs/zally.jar /

EXPOSE $PORT

CMD java $(java-dynamic-memory-opts) $(appdynamics-agent) -jar /zally.jar
