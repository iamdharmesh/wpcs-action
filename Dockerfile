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
    apk add --no-cache php-tokenizer php-xmlreader php-simplexml php-xml php-xmlwriter

ENTRYPOINT ["/action/entrypoint.sh"]
