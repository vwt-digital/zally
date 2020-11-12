FROM scratch

CMD chmod +x cli/zally
COPY cli/zally /usr/local/bin

ENTRYPOINT ["./zally", "-l", "https://zally-server-ysstuopb4a-ew.a.run.app", "lint"]
