FROM alpine:3.20

RUN apk add --no-cache bash smartmontools coreutils dos2unix

COPY smartmon.sh /usr/local/bin/smartmon.sh
COPY entrypoint.sh /entrypoint.sh

# Fix Windows line endings (CRLF → LF)
RUN dos2unix /usr/local/bin/smartmon.sh /entrypoint.sh && \
    chmod +x /usr/local/bin/smartmon.sh /entrypoint.sh

ENV SMARTMON_INTERVAL=300
ENV SMARTMON_OUTPUT=/var/lib/node_exporter/textfile_collector/smart_metrics.prom

RUN mkdir -p /var/lib/node_exporter/textfile_collector

ENTRYPOINT ["/entrypoint.sh"]