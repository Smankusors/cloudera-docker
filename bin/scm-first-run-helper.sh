#!/bin/sh
export JAVA_HOME=/usr/lib/jvm/java-8-oracle-cloudera
export PATH=$PATH:/$JAVA_HOME/bin
echo "Creating Hive Metastore Tables..."
mysql -e "DROP DATABASE metastore; CREATE DATABASE metastore;"
cd /usr/lib/hive/scripts/metastore/upgrade/mysql
cat hive-schema-2.1.1.mysql.sql | mysql -D metastore
echo "Set dfs.datanode.max.locked.memory=16777216"
mysql -e "UPDATE scm.CONFIGS SET VALUE=16777216 WHERE ATTR='dfs_datanode_max_locked_memory';"

