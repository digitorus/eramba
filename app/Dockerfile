FROM alpine:3.7

# common tools 
RUN apk --no-cache add \
    ca-certificates bash curl openssl vim xz

# apache php mysql
RUN apk --no-cache add \
    mysql-client apache2 apache2-http2 \
    php7 php7-apache2 php7-common php7-ctype php7-mysqli php7-mysqlnd php7-pdo_mysql php7-zip php7-xml php7-json \
    php7-exif php7-gd php7-intl php7-mbstring php7-ldap php7-curl php7-simplexml php7-session php7-fileinfo php7-phar \
    php7-mcrypt

# php7-mcrypt is depricated and removed from PHP 7.2 which comes with alpine > 3.7
# php7-pecl-mcrypt can be used as replacement
#
# The with Eramba bundeld version of CakePHP is old and having issues with PHP 7.2
# wkhtmltopdf comes only with alpine > 3.8 (edge) but that comes also with PHP 7.2

#RUN apk add -U --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community wkhtmltopdf \
#    musl libgcc libstdc++ qt5-qtbase qt5-qtbase-x11 qt5-qtsvg qt5-qtwebkit

RUN apk add --update --no-cache \
    libgcc libstdc++ libx11 glib libxrender libxext libintl \
    libcrypto1.0 libssl1.0 \
    ttf-dejavu ttf-droid ttf-freefont ttf-liberation ttf-ubuntu-font-family

# ADD https://github.com/madnight/docker-alpine-wkhtmltopdf/blob/master/wkhtmltopdf?raw=true /usr/local/bin/wkhtmltopdf

# cleanup
RUN rm -f /var/cache/apk/* 

# Enterprise edition
#ENV DOWNLOAD_URL https://s3-eu-west-1.amazonaws.com/downloadseramba/.... (complete URL)

# Community edition
ENV DOWNLOAD_URL https://s3-eu-west-1.amazonaws.com/downloadseramba/CommunityTGZ/eramba_community_2018.tgz

RUN curl $DOWNLOAD_URL -o /tmp/eramba.tgz
RUN tar -xvz -C /tmp -f /tmp/eramba.tgz && mv /tmp/eramba_* /app && chown -R apache:apache /app && rm -f /tmp/eramba.tgz

VOLUME ["/app/app/tmp/logs","/app/app/webroot/files","/app/app/webroot/backups","/var/www/logs","/var/log"]
ADD scripts/ /scripts

RUN chmod -R 755 /scripts
WORKDIR /app

EXPOSE 80

ENTRYPOINT ["/scripts/run.sh"]
