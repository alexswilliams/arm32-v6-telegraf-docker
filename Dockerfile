FROM arm32v6/alpine:3.12.0
# Updated here: https://hub.docker.com/r/arm32v6/alpine/tags
# Inspired by https://github.com/influxdata/influxdata-docker/blob/master/telegraf/1.14/alpine/Dockerfile


ARG VERSION
ENV TELEGRAF_VERSION $VERSION

RUN set -ex && \
    echo 'hosts: files dns' >> /etc/nsswitch.conf && \
    apk add --no-cache iputils ca-certificates net-snmp-tools procps lm_sensors tzdata && \
    update-ca-certificates && \
    apk add --no-cache --virtual .build-deps wget tar && \
    wget --no-verbose https://dl.influxdata.com/telegraf/releases/telegraf-${TELEGRAF_VERSION}_linux_armhf.tar.gz && \
    mkdir -p /usr/src /etc/telegraf && \
    tar -C /usr/src -xvzf telegraf-${TELEGRAF_VERSION}_linux_armhf.tar.gz && \
    mv /usr/src/telegraf*/etc/telegraf/telegraf.conf /etc/telegraf/ && \
    mkdir /etc/telegraf/telegraf.d && \
    chmod +x /usr/src/telegraf*/usr/bin/telegraf && \
    cp -a /usr/src/telegraf*/usr/bin/telegraf /usr/bin/ && \
    rm -rf *.tar.gz* /usr/src && \
    apk del .build-deps

EXPOSE 8125/udp 8092/udp 8094

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["telegraf"]


ARG VCS_REF
ARG BUILD_DATE
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Telegraf (arm32v6)" \
      org.label-schema.description="Telegraf - Repackaged for ARM32v6" \
      org.label-schema.url="https://www.influxdata.com/time-series-platform/telegraf/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/alexswilliams/arm32-v6-telegraf-docker" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"
