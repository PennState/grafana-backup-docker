FROM alpine:3.9

ENV URL https://github.com/ysde/grafana-backup-tool/archive/master.zip

RUN apk update && apk upgrade && \
    apk add ca-certificates py3-requests curl && \
    curl
