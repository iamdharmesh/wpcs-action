FROM cytopia/phpcs:3-php7.4

COPY entrypoint.sh \
     problem-matcher.json \
     /action/

RUN chmod +x /action/entrypoint.sh

RUN apk update && \
    apk upgrade && \
    apk add git && \
    apk add composer && \
    apk add php7-tokenizer && \
    apk add php7-simplexml

ENTRYPOINT ["/action/entrypoint.sh"]
