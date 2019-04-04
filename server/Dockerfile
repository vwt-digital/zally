FROM gradle:jdk10 as builder

COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle build

RUN cp /home/gradle/src/build/libs/zally.jar .

FROM registry.opensource.zalan.do/stups/openjdk:latest

MAINTAINER "http://zalando.github.io/"

COPY src/main/resources/api/zally-api.yaml /zalando-apis/zally-api.yaml

EXPOSE 8080

CMD java $(java-dynamic-memory-opts) $(appdynamics-agent) -jar /zally.jar
