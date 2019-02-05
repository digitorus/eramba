#!/bin/sh

# set apache as owner/group
if [ "$FIX_OWNERSHIP" != "" ]; then
	chown -R apache:apache /app
fi

# display logs
tail -F /var/log/apache2/*log &

# execute any pre-exec scripts, useful for images
# based on this image
for i in /scripts/pre-exec.d/*sh
do
	if [ -e "${i}" ]; then
		echo "[i] pre-exec.d - processing $i"
		. "${i}"
	fi
done

# run cron deamon and log to stderr
echo "[i] Starting crond..."
crond -b -c /etc/crontabs -d 8

# run apache httpd daemon
echo "[i] Starting apache..."
httpd -D FOREGROUND