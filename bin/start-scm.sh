#!/bin/sh
/init.sh
runuser -u cloudera-scm -g cloudera-scm /opt/cloudera/cm/bin/cm-server-pre
runuser -u cloudera-scm -g cloudera-scm /opt/cloudera/cm/bin/cm-server | grep -v "useSSL=false"
