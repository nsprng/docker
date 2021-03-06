#!/bin/bash

set -e

#Replace configuration parameters with custom values
sed -i "s|MRG_PSWD|$MRG_PSWD|" /var/www/morgue/schemas/create_db.sql
sed -i "s|SRV_NAME|$HOSTNAME|" /etc/apache2/sites-available/000-default.conf
sed -i "s|localhost|$DB_HOST|" /var/www/morgue/config/development.json
sed -i "s|morgue_password|$MRG_PSWD|" /var/www/morgue/config/development.json
sed -i "s|Europe/Zurich|$TZ|" /var/www/morgue/config/development.json

#Check whether DB is created
DB_CHECK=$(mysql -u root -h $DB_HOST --password=$DB_PSWD -s -N -e "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='morgue'")

#If DB isn't exist - create the new one
if [ -z "$DB_CHECK" ]; then
    mysql -u root -p -h $DB_HOST --password=$DB_PSWD < /var/www/morgue/schemas/create_db.sql
    mysql -u morgue -p -h $DB_HOST --password=$MRG_PSWD morgue < /var/www/morgue/schemas/postmortems.sql
    mysql -u morgue -p -h $DB_HOST --password=$MRG_PSWD morgue < /var/www/morgue/schemas/images.sql
    mysql -u morgue -p -h $DB_HOST --password=$MRG_PSWD morgue < /var/www/morgue/schemas/jira.sql
    mysql -u morgue -p -h $DB_HOST --password=$MRG_PSWD morgue < /var/www/morgue/schemas/links.sql
    mysql -u morgue -p -h $DB_HOST --password=$MRG_PSWD morgue < /var/www/morgue/schemas/irc.sql
    mysql -u morgue -p -h $DB_HOST --password=$MRG_PSWD morgue < /var/www/morgue/schemas/anniversary.sql
    mysql -u morgue -p -h $DB_HOST --password=$MRG_PSWD morgue < /var/www/morgue/schemas/slack.sql
fi

#Delete Apache PID lock to be able to restart a container
rm -f /run/apache2/apache2.pid

#Start Apache
exec "$@"
