FROM library/docker:stable

MAINTAINER Oleg Bukatchuk <oleg@bukatchuk.com>

ENV HOME_DIR=/opt/crontab

RUN apk add --no-cache --virtual .run-deps gettext bash jq \
    && mkdir -p ${HOME_DIR}/jobs ${HOME_DIR}/projects \
    && adduser -S docker -D

COPY config.json ${HOME_DIR}/config.json

COPY docker-entrypoint /

ENTRYPOINT ["/docker-entrypoint"]

HEALTHCHECK --interval=5s --timeout=3s \
    CMD ps aux | grep '[c]rond' || exit 1

CMD ["crond", "-f", "-d", "6", "-c", "/etc/crontabs"]
