#! /bin/bash

cp /etc/rsnapshot/push/rsyncd.conf.template /etc/rsnapshot/push/rsyncd.conf
echo "path = /mnt/snapshots/$1/.sync" >> /etc/rsnapshot/push/rsyncd.conf
echo "post-xfer exec = /usr/local/sbin/start-rsnapshot.sh $1" >> /etc/rsnapshot/push/rsyncd.conf

mkdir -p "/mnt/snapshots/$1/.sync"

rsync --server --daemon --config=/etc/rsnapshot/push/rsyncd.conf "/mnt/snapshots/$1"
