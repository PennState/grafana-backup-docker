FROM alpine:3.14

ENV REF 1.1.8
ENV URL https://github.com/ysde/grafana-backup-tool/archive/${REF}.zip

RUN apk update && apk upgrade \
 && apk add ca-certificates py3-requests curl bash py3-pip py3-wheel py3-docopt py3-boto3 py3-cryptography py3-botocore py3-cffi py3-protobuf \
 && apk add --virtual .build-deps gcc musl-dev \
 && curl -sL $URL -o /tmp/grafana-backup-tool.zip \
 && unzip -d /tmp /tmp/grafana-backup-tool.zip \
 && cd /tmp/grafana-backup-tool-${REF} \
 && pip install . \
 && apk del .build-deps \
 && rm -rf /tmp/grafana-backup-tool*

RUN ls /opt

ADD entrypoint.sh /entrypoint.sh
RUN chmod 555 /entrypoint.sh

ENTRYPOINT /entrypoint.sh
