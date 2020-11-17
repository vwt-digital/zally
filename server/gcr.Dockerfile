FROM ubuntu

COPY cli/zally /usr/local/bin
COPY zally-lint.sh /usr/local/bin

ENTRYPOINT ["bash", "/usr/local/bin/zally-lint.sh"]
