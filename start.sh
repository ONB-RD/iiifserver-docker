#!/bin/bash

[ -f /etc/sysconfig/iipimage ] && . /etc/sysconfig/iipimage

spawnfcgi="/usr/bin/spawn-fcgi"
iipimage_cgi="/usr/bin/fcgi/iipsrv.fcgi"
server_ip=127.0.0.1
server_port=9000
server_user=imageserver
server_group=imageserver
server_childs=5
pidfile="/var/run/iipimage.pid"

echo -n $spawnfcgi -a ${server_ip} -p ${server_port} -u ${server_user} -g ${server_group} -P ${pidfile} -F ${server_childs} -f ${iipimage_cgi}

$spawnfcgi -a ${server_ip} -p ${server_port} -u ${server_user} -g ${server_group} -P ${pidfile} -F ${server_childs} -f ${iipimage_cgi}
nginx -g "daemon off;"
