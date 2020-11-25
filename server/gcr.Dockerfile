FROM ubuntu

RUN apt-get update && apt-get install curl -y && apt-get -y install openssl && apt-get -y install libssl-dev
COPY cli/zally /usr/local/bin
COPY zally-lint.sh /usr/local/bin

ENTRYPOINT ["bash", "/usr/local/bin/zally-lint.sh"]
