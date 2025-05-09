FROM cytopia/phpcs:latest-php7.4

COPY entrypoint.sh \
     problem-matcher.json \
     /action/

RUN chmod +x /action/entrypoint.sh

RUN apk update && \
    apk upgrade && \
    apk add git php8-simplexml php8-tokenizer php8-xmlreader php8-xmlwriter php-xml

ENTRYPOINT ["/action/entrypoint.sh"]
