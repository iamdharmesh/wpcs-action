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
	&& git clone https://github.com/PHPCSStandards/PHP_CodeSniffer

# Install PHP CodeSniffer
RUN set -eux \
	&& cd PHP_CodeSniffer \
	&& VERSION="$( git describe --abbrev=0 --tags )" \
	&& curl -sS -L https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/download/${VERSION}/phpcs.phar -o /phpcs.phar \
	&& chmod +x /phpcs.phar \
	&& mv /phpcs.phar /usr/bin/phpcs \
	&& phpcs --version

# Install PHP Composer
RUN set -eux \
	&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
	&& composer --version

# Install PHPCS standards
RUN composer global config allow-plugins.dealerdirect/phpcodesniffer-composer-installer true
RUN composer global require --dev wp-coding-standards/wpcs:"^3.1.0" --update-with-dependencies
RUN composer global require --dev 10up/phpcs-composer:"^3.0"

COPY entrypoint.sh \
     problem-matcher.json \
     /action/

RUN chmod +x /action/entrypoint.sh

ENTRYPOINT ["/action/entrypoint.sh"]
