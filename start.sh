#!/bin/sh
service mysql start
service ssh start
systemctl start supervisord
export CLOUDERA_ROOT=/opt/cloudera
export CMF_DEFAULTS=/etc/default/cloudera-scm-server
runuser -u cloudera-scm -g cloudera-scm /opt/cloudera/cm/bin/cm-server-pre
runuser -u cloudera-scm -g cloudera-scm /opt/cloudera/cm/bin/cm-server
