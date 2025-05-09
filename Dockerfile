FROM php:8.0-cli-alpine

# Install build dependencies
RUN set -eux \
	&& apk add --no-cache \
		ca-certificates \
		coreutils \
		curl \
		git \
		php8-simplexml \
		php8-tokenizer \
		php8-xmlreader \
		php8-xmlwriter \
		php-xml \
	&& git clone https://github.com/squizlabs/PHP_CodeSniffer

RUN set -eux \
	&& cd PHP_CodeSniffer \
	&& VERSION="$( git describe --abbrev=0 --tags )" \
	&& echo "Version: ${VERSION}" \
	&& curl -sS -L https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${VERSION}/phpcs.phar -o /phpcs.phar \
	&& chmod +x /phpcs.phar \
	&& mv /phpcs.phar /usr/bin/phpcs \
	&& phpcs --version

COPY entrypoint.sh \
     problem-matcher.json \
     /action/

RUN chmod +x /action/entrypoint.sh

ENTRYPOINT ["/action/entrypoint.sh"]
