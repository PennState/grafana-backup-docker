FROM alpine:3.9

ENV REF master
ENV URL https://github.com/ysde/grafana-backup-tool/archive/${REF}.zip

RUN apk update && apk upgrade \
 && apk add ca-certificates py3-requests curl bash \
 && curl -sL $URL -o /opt/grafana-backup-tool.zip \
 && unzip -d /opt /opt/grafana-backup-tool.zip \
 && rm -f /opt/grafana-backup-tool.zip \
 && mv /opt/grafana-backup-tool-* /opt/grafana-backup-tool \
 && ln -sf /usr/bin/python3 /usr/bin/python \
 && sed -i 's/verifySSL = False/verifySSL = True/' /opt/grafana-backup-tool/grafanaSettings.py

RUN ls /opt

ADD entrypoint.sh /entrypoint.sh
RUN chmod 555 /entrypoint.sh

ENTRYPOINT /entrypoint.sh
