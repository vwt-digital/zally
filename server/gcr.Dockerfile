WORKDIR /src

CMD chmod +x cli/zally
COPY cli/zally /usr/local/bin

ENTRYPOINT ["bash", "/zally-lint.sh"]
