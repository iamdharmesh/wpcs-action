FROM cytopia/phpcs:latest-php7.4

COPY entrypoint.sh \
     problem-matcher.json \
     /action/

RUN chmod +x /action/entrypoint.sh

RUN apk update && \
    apk upgrade && \
    apk add git && \
    apk add composer

RUN apk --no-cache update && \
    apk upgrade && \
    apk add --no-cache php8-tokenizer php8-xmlreader php8-simplexml php-xml

ENTRYPOINT ["/action/entrypoint.sh"]
