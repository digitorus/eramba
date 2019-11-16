#!/bin/sh

ERAMBACONF=/app/app/Config/eramba.configured

if [ -f "$ERAMBACONF" ]; then
	echo "[i] Eramba already configured"
else
	echo "[i] Configuring Eramba"
	touch "$ERAMBACONF"

	if [ "$DEBUG" = "" ]; then
		sed -i "s#Configure::write('debug',.*)#Configure::write('debug',0)#g" /app/app/Config/core.php
	fi

	# delete cache
	cd /app/app/tmp/cache; find . -type f -exec rm -f {} \;

	# generate a random security key for cron
	CRON_KEY=$(openssl rand -hex 20)
	sed -i "s#//define('CRON_SECURITY_KEY'.*#define('CRON_SECURITY_KEY', '"$CRON_KEY"');#" /app/app/Config/settings.php

	# install crontabs
	echo "curl -o /dev/null https://$ERAMBA_HOSTNAME/cron/hourly/$CRON_KEY" >  /etc/periodic/hourly/eramba.sh
	echo "curl -o /dev/null https://$ERAMBA_HOSTNAME/cron/daily/$CRON_KEY" >  /etc/periodic/daily/eramba.sh

	(crontab -l 2>/dev/null; echo "1 1 1 1 * curl -o /dev/null https://$ERAMBA_HOSTNAME/cron/yearly/$CRON_KEY") | crontab -
fi
