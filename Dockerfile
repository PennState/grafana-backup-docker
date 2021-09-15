FROM alpine:3.14

ENV REF 1.1.8
ENV URL https://github.com/ysde/grafana-backup-tool/archive/${REF}.zip

RUN apk update && apk upgrade \
 && apk add ca-certificates py3-requests curl bash py3-pip \
 && curl -sL $URL -o /tmp/grafana-backup-tool.zip \
 && unzip -d /tmp /tmp/grafana-backup-tool.zip 
RUN cd /tmp/grafana-backup-tool-master \
 && pip install .

RUN ls /opt

ADD entrypoint.sh /entrypoint.sh
RUN chmod 555 /entrypoint.sh

ENTRYPOINT /entrypoint.sh
