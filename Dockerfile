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

# Define mountable directories.
VOLUME [ "/var/www/html" ]

# Add user
RUN useradd -U -m -u "${DEFAULT_USER_UID}" -G sudo,www-data -d /home/magento "${DEFAULT_USER}"
# User specifics
RUN echo "" >> /home/magento/.bashrc
RUN echo "#Zero1 - Additions" >> /home/magento/.bashrc
RUN echo "export TERM=xterm" >> /home/magento/.bashrc
RUN echo "[client]" >> /home/magento/.my.cnf
RUN echo "host=${MYSQL_HOST_ALIAS}" >> /home/magento/.my.cnf
RUN echo "user=${MYSQL_USER}" >> /home/magento/.my.cnf
RUN echo "password=${MYSQL_PASSWORD}" >> /home/magento/.my.cnf
RUN echo "database=${MYSQL_DATABASE}" >> /home/magento/.my.cnf

# Define working directory.
WORKDIR /var/www/html

ENTRYPOINT ["/entrypoint.sh"]
