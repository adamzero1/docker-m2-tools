FROM ubuntu:xenial
ENV DEBIAN_FRONTEND noninteractive

# Postfix Config
RUN echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

RUN export TERM=xterm; apt-get update && apt-get install -y --force-yes \
        php7.0-xml \
	php7.0-mysql \
	php7.0-curl \
	php7.0-mcrypt \
	php7.0-gd \
	php7.0-cli \
	php7.0-soap \
	git-core \
	mysql-client \
	curl \
	nano \
	postfix \
	rsyslog \
	--fix-missing
	
RUN apt-get clean

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Disable local delivery
RUN sed -i 's/mydestination = .*/mydestination = localhost/' /etc/postfix/main.cf

#RUN usermod -m -d /usr/share/nginx www-data
COPY files/entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
