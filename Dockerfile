FROM ubuntu:bionic
MAINTAINER Antony Kurniawan <smankusors@icloud.com>

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Jakarta

# base image layer
RUN apt update \
	&& apt install -y wget curl build-essential software-properties-common openjdk-11-jdk mysql-server libmysql-java openssh-server dnsutils tzdata \
	&& ln -s /usr/lib/jvm/java-11-openjdk-amd64 /usr/lib/jvm/jdk-11 \
	&& ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -N "" \
	&& cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys \
	&& (echo "PermitRootLogin prohibit-password" >> /etc/ssh/sshd_config) \
	&& apt autoclean \
	&& rm -rf /var/lib/apt/lists/* \
	&& ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
	&& echo $TZ > /etc/timezone

# cloudera manager layer
RUN wget https://archive.cloudera.com/cm6/6.3.0/ubuntu1604/apt/archive.key \
	&& apt-key add archive.key \
	&& rm archive.key \
	&& apt-add-repository 'deb https://archive.cloudera.com/cm6/6.3.1/ubuntu1804/apt/ bionic-cm6.3.1 contrib' \
	&& apt install -y cloudera-manager-daemons cloudera-manager-agent cloudera-manager-server \
	&& apt autoclean \
        && rm -rf /var/lib/apt/lists/* \
	&& service mysql stop

COPY mysqld_cloudera.cnf /etc/mysql/mysql.conf.d/mysqld_cloudera.cnf
COPY sql.sql /sql.sql

#https://unix.stackexchange.com/questions/187042/starting-services-without-systemd
# hadoop & etc layer
RUN chmod 644 /etc/mysql/mysql.conf.d/mysqld_cloudera.cnf \
	&& service mysql start \
	&& mysql < /sql.sql \
	&& /opt/cloudera/cm/schema/scm_prepare_database.sh mysql scm scm scm \
	&& wget https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl.py -O /bin/systemctl \
	&& chmod +x /bin/systemctl \
	&& wget https://archive.cloudera.com/cdh6/6.3.2/ubuntu1804/apt/archive.key \
	&& apt-key add archive.key \
	&& rm archive.key \
	&& apt-add-repository 'deb https://archive.cloudera.com/cdh6/6.3.2/ubuntu1804/apt/ bionic-cdh6.3.2 contrib' \
	&& apt install -y zookeeper=3.4.5+cdh6.3.2-1605554 \
	&& apt install -y bigtop-utils bigtop-jsvc hadoop-kms hadoop-httpfs hadoop-hdfs-nfs3 hadoop-hdfs-fuse hbase hive hive-hbase oozie-client oozie hue impala impala-shell solr-doc search sentry-hdfs-plugin solr-mapreduce hbase-solr hbase-solr-doc solr-crunch spark-python avro-doc avro-tools kafka \
	&& apt autoclean \
        && rm -rf /var/lib/apt/lists/*

COPY bin/ /
CMD ["bash"]
