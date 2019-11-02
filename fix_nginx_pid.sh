#!/bin/bash +x

## To fix Nginx bugs complaining cannot read nginx.pid
## Last modified: November 3, 2019 +oms

red=$'\e[38;5;196m'
green=$'\e[38;5;82m'
blue=$'\e[38;5;21m'
white=$'\e[0m'

if ! [ $(id -u) = 0 ]; then
   echo "You're not root. Please execute this using root user"
   exit 1
fi

echo "$blue >>> Creating nginx.service.d dir in systemd path $white"
mkdir /etc/systemd/system/nginx.service.d

if [ $? -eq 0 ] ; then
    echo "$green Directory nginx.service.d successfully created $white"
    echo ""
else
    echo "$red ERROR - $white Cannot create nginx.service.d"
fi

echo "$blue >>> Creating systemd override for nginx.service $white"
printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" > /etc/systemd/system/nginx.service.d/override.conf
ls -lah /etc/systemd/system/nginx.service.d/override.conf

if [ $? -eq 0 ] ; then
    echo "$green Override for nginx.service.d successfully created $white"
    echo ""
else
    echo "$red ERROR - $white File missing. Probably failed to crete the override file!"
fi

sleep 2
echo "$blue >>> Reload Deamon and restarting Nginx $white"
systemctl daemon-reload
sleep 2
systemctl restart nginx

echo ""
systemctl status nginx
