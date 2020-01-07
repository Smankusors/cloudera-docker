#!/bin/sh
service mysql start
/init.sh
touch /var/log/cloudera-scm-server/cloudera-scm-server.log
chmod 777 /var/log/cloudera-scm-server/cloudera-scm-server.log
systemctl start cloudera-scm-server
tail -f /var/log/cloudera-scm-server/cloudera-scm-server.log | grep -v "Establishing SSL"
