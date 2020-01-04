#!/bin/sh
/init.sh
touch /var/log/cloudera-scm-server/cloudera-scm-server.log
chmod 777 /var/log/cloudera-scm-server/cloudera-scm-server.log
systemctl start cloudera-scm-server
sleep 10
tail -f /var/log/cloudera-scm-server/cloudera-scm-server.log | grep -v "Establishing SSL"
