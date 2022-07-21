#!/usr/bin/bash

set -e

# Make sure this is the correct folder, so this can be run from anywhere
cd /home/pipalot/webapp
# Pull any changes
git pull

# sync to web root and make sure owner is www-data
sudo rsync -ravP --del web_root/ /var/www/pipalot_web/
sudo chown www-data:www-data -R /var/www/pipalot_web/

# "boolean" to check if we need to restart apache
restart_apache=false
# check both conf files
for f in pipalot_web.conf pipalot_web-le-ssl.conf; do
    # Check for change
    if diff /etc/apache/sites-enabled/$f codes/$f  &>/den/null; then
        # If changed, copy to sites-available
        sudo cp codes/$f /etc/apache/sites-available/
        # Remake link to sites-enabled if nonexistent
        if ! [[ -f /etc/apache/sites-enabled/$f ]]; then
           sudo ln -sf /etc/apache/sites-available/$f /etc/apache/sites-enabled/
        fi
        restart_apache=false
    fi
done

# If either conf file was copied, restart the server
if $restart_apache; then
    sudo systemctl --restart apache2.service
fi