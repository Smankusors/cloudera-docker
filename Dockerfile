FROM ubuntu:bionic
MAINTAINER Antony Kurniawan <smankusors@icloud.com>

RUN apt update \
	&& apt install -y wget curl software-properties-common openjdk-11-jdk mysql-server libmysql-java openssh-server dnsutils \
	&& ln -s /usr/lib/jvm/java-11-openjdk-amd64 /usr/lib/jvm/jdk-11 \
	&& ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -N "" \
	&& cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys \
	&& (echo "PermitRootLogin prohibit-password" >> /etc/ssh/sshd_config) \
	&& wget https://archive.cloudera.com/cm6/6.3.0/ubuntu1604/apt/archive.key \
	&& apt-key add archive.key \
	&& rm archive.key \
	&& apt-add-repository 'deb https://archive.cloudera.com/cm6/6.3.1/ubuntu1804/apt/ bionic-cm6.3.1 contrib' \
	&& apt install -y cloudera-manager-daemons cloudera-manager-agent cloudera-manager-server \
	&& service mysql stop

COPY mysqld_cloudera.cnf /etc/mysql/mysql.conf.d/mysqld_cloudera.cnf
COPY sql.sql /sql.sql

#https://unix.stackexchange.com/questions/187042/starting-services-without-systemd
RUN chmod 644 /etc/mysql/mysql.conf.d/mysqld_cloudera.cnf \
	&& service mysql start \
	&& mysql < /sql.sql \
	&& /opt/cloudera/cm/schema/scm_prepare_database.sh mysql scm scm scm \
	&& wget https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl.py -O /bin/systemctl \
	&& chmod +x /bin/systemctl

COPY start.sh /start.sh
CMD ["/start.sh"]
