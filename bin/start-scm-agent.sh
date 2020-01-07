#!/bin/sh
/init.sh
touch /var/log/cloudera-scm-agent/cloudera-scm-agent.log
chmod 777 /var/log/cloudera-scm-agent/cloudera-scm-agent.log
systemctl start cloudera-scm-agent
tail -f /var/log/cloudera-scm-agent/cloudera-scm-agent.log
