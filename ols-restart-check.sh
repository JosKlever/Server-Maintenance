#!/bin/sh
#========================
# Description: this script checks if .htaccess files have been changed in order to restart the Open LiteSpeed webserver
# Environment: Almalinux, DirectAdmin (might need adjustments for other setups)
# Save the script in /root/scripts/ols-restart-check.sh and make sure you enter your own email address in the mail command.
# Usage: call this script in /etc/cron.d/openlitespeed_htaccess_scan with the following line:
# */3 * * * root /root/scripts/ols-restart-check.sh
#========================
changed_files=$(find /home/*/domains/*/public_html/ -maxdepth 2 -type f -newer /usr/local/lsws/cgid -name '.htaccess' 2>/dev/null)
if [ -n "$changed_files" ]; then
  echo "OpenLiteSpeed restarted due to the following changed .htaccess files:" > /tmp/ols_restart_info.txt
  echo "$changed_files" >> /tmp/ols_restart_info.txt
  /usr/local/lsws/bin/lswsctrl restart >> /tmp/ols_restart_info.txt 2>&1
  mail -s "OpenLiteSpeed Restart Notification" your-email@example.com < /tmp/ols_restart_info.txt
  rm /tmp/ols_restart_info.txt
fi
