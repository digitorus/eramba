#!/bin/sh

# set -x

ERAMBADBCONF=/app/app/Config/database.php
MAXTRIES=20

if [ "$DB_ENV_MYSQL_PASSWORD" = "" ]; then
	DBPWOPT=
else
	DBPWOPT="-p$DB_ENV_MYSQL_PASSWORD"
fi

wait4mysql () {
echo "[i] Waiting for database to setup..."

for i in $(seq 1 1 $MAXTRIES)
do
	echo "[i] Trying to connect to database: try $i..."
	mysql -B --connect-timeout=1 -h db -u $DB_ENV_MYSQL_USER $DBPWOPT -e "SELECT VERSION();" $DB_ENV_MYSQL_DATABASE 

	if [ "$?" = "0" ]; then
		echo "[i] Successfully connected to database!"
		break
	else
		if [ "$i" = "$MAXTRIES" ]; then
			echo "[!] You need to have container for database. Take a look at docker-compose.yml file!"
			exit 0
		else
			sleep 5
		fi
	fi
done
}

DBEMPTY=0
check4mysql () {
	echo "[i] Checking if database is empty..."
	LISTTABLES=`(mysql -B -h db -u $DB_ENV_MYSQL_USER $DBPWOPT -e "SHOW TABLES;" $DB_ENV_MYSQL_DATABASE )`
	if [ "$?" = "0" ]; then
		NUMTABLES=`( echo "$LISTTABLES" | wc -l )`
		# echo "[i] Tables: $NUMTABLES"
		if [ "$NUMTABLES" = "1" ]; then
			echo "[i] Looks like database is empty!"			
			DBEMPTY=1
		fi
	else
		echo "[i] Error connecting to database. Exiting"
		exit 1	
	fi
}
		
wait4mysql
check4mysql

#if [ -f "/app/app/Config/eramba.configured" ]; then
#	exit 0
#fi

for PERMVOLUMES in /app/app/tmp/logs /app/app/webroot/files /app/app/tmp/cache /app/app/tmp/cache/persistent /app/app/tmp/cache/models /app/app/tmp/cache/acl
do
	if ! [ -d "$PERMVOLUMES" ]; then
		echo "[i] Creating dir for $PERMVOLUMES"
		mkdir $PERMVOLUMES
	fi
	echo "[i] Setting permissions for $PERMVOLUMES"
	chown apache:apache $PERMVOLUMES
done

if [ -f "$ERAMBADBCONF" ]; then
	echo "[i] Found database configuration. Not touching it!"
else
	echo "[i] Database configuration missing. Creating..."
	
	cat << EOF > $ERAMBADBCONF
<?php

class DATABASE_CONFIG {

        public \$default = array(
                'datasource' => 'Database/Mysql',
                'persistent' => false,
                'host' => 'db',
                'login' => '$DB_ENV_MYSQL_USER',
                'password' => '$DB_ENV_MYSQL_PASSWORD',
                'database' => '$DB_ENV_MYSQL_DATABASE',
                'prefix' => '',
                'encoding' => 'utf8',
        );

}
EOF

	if [ "$DBEMPTY" = "1" ]; then	
		echo "[i] Creating initial schema..."
		for f in /app/app/Config/db_schema/*.sql
		do
			echo "[i] Running SQL file $f"
			mysql -h db -u root -p$DB_ENV_MYSQL_ROOT_PASSWORD $DB_ENV_MYSQL_DATABASE < $f
		done
	else
		echo "[i] Database not empty. Not touching it!"
	fi	
fi

