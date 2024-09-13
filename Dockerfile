FROM cytopia/phpcs:latest-php7.4

COPY entrypoint.sh \
     problem-matcher.json \
     /action/

RUN chmod +x /action/entrypoint.sh

RUN apk update && \
    apk upgrade && \
    apk add git && \
    apk add composer

RUN apk add php7-tokenizer

ENTRYPOINT ["/action/entrypoint.sh"]
