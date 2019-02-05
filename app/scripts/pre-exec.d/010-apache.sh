#!/bin/sh

mkdir /run/apache2

# Apache settings
sed -i 's#\#ServerName .*#ServerName '$ERAMBA_HOSTNAME'#' /etc/apache2/httpd.conf
sed -i 's#ServerTokens .*#ServerTokens Prod#' /etc/apache2/httpd.conf
sed -i 's#ServerSignature .*#ServerSignature Off#' /etc/apache2/httpd.conf

sed -i 's#/var/www/localhost/htdocs#/app/#' /etc/apache2/httpd.conf
sed -i 's#Options Indexes .*#Options +Indexes +FollowSymLinks -MultiViews#' /etc/apache2/httpd.conf 
sed -i 's#\#LoadModule rewrite_module modules/mod_rewrite.so#LoadModule rewrite_module modules/mod_rewrite.so#' /etc/apache2/httpd.conf 
sed -i 's#DirectoryIndex index.html#DirectoryIndex index.php index.html#' /etc/apache2/httpd.conf
sed -i 's#LogLevel warn#LogLevel debug#' /etc/apache2/httpd.conf
# TODO: AllowOverride must only be enabled for the /app directory and not for the root itself
sed -i 's# AllowOverride None# AllowOverride All#' /etc/apache2/httpd.conf 

# PHP settings
sed -i 's#max_execution_time .*#max_execution_time = 200#' /etc/php7/php.ini
sed -i 's#memory_limit .*#memory_limit = 2048M#' /etc/php7/php.ini
sed -i 's#allow_url_fopen .*#allow_url_fopen = On#' /etc/php7/php.ini
sed -i 's#; max_input_vars .*#max_input_vars = 3000#' /etc/php7/php.ini
sed -i 's#upload_max_filesize .*#upload_max_filesize = 8M#' /etc/php7/php.ini