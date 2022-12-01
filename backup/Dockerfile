FROM alpine:latest

COPY ./scripts/daily/* /etc/periodic/daily

RUN apk update && \
    apk upgrade && \
    apk add --no-cache mysql-client && \
    apk add --no-cache curl && \
    chmod a+x /etc/periodic/daily/*