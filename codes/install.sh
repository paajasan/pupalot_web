#!/usr/bin/bash

set -e

# Make sure this is the correct folder, so this can be run from anywhere
cd /home/pipalot/webapp
# Pull any changes
git pull

# sync to web root and make sure owner is www-data
rsync -ravP --del web_root/ /var/www/pipalot_web/
chown www-data:www-data -R /var/www/pipalot_web/

# "boolean" to check if we need to restart apache
restart_apache=false
# check both conf files
for f in pipalot_web.conf pipalot_web-le-ssl.conf; do
    # Check for change
    if ! diff /etc/apache2/sites-enabled/$f codes/$f  &>/dev/null; then
        echo Copying codes/$f to /etc/apache2/sites-available/ 
        # If changed, copy to sites-available
        cp codes/$f /etc/apache2/sites-available/
        # Remake link to sites-enabled if nonexistent
        if ! [[ -f /etc/apache2/sites-enabled/$f ]]; then
            echo Making a link of /etc/apache2/sites-available/$f to /etc/apache2/sites-enabled/ 
            ln -sf /etc/apache2/sites-available/$f /etc/apache2/sites-enabled/
        fi
        restart_apache=false
    fi
done

# If either conf file was copied, restart the server
if $restart_apache; then
    echo Restarting apache
    systemctl restart apache2.service
fi