#!/bin/sh
service ssh start
service ntp start
systemctl start supervisord
export CLOUDERA_ROOT=/opt/cloudera
export CMF_DEFAULTS=/etc/default/cloudera-scm-server
