## Dockerfile for CDH 5.3.3 on CentOS 6.x
FROM       centos:6
MAINTAINER Jacob Stanley <jacob@stanley.io>

# Install Oracle JDK 7
RUN yum install -y wget && \
    wget \
      --no-cookies \
      --progress=bar:force \
      --header "Cookie: oraclelicense=accept-securebackup-cookie" \
      "http://download.oracle.com/otn-pub/java/jdk/7u76-b13/jdk-7u76-linux-x64.rpm" \
      -O jdk7.rpm && \
    yum install -y jdk7.rpm && \
    rm jdk7.rpm

# Add the CDH 5.3.3 repository
COPY conf/cloudera.repo /etc/yum.repos.d/

# Install Hadoop
RUN yum install -y zookeeper-server && \
    yum install -y hadoop-conf-pseudo && \
    yum install -y hue hue-server

# Copy config files
COPY conf/core-site.xml   /etc/hadoop/conf/core-site.xml
COPY conf/hdfs-site.xml   /etc/hadoop/conf/hdfs-site.xml
COPY conf/mapred-site.xml /etc/hadoop/conf/mapred-site.xml
COPY conf/yarn-site.xml   /etc/hadoop/conf/yarn-site.xml
COPY conf/hadoop-env.sh   /etc/hadoop/conf/hadoop-env.sh

# Format HDFS
RUN su - hdfs -c "hdfs namenode -format"

# Copy run script
COPY conf/run-hadoop.sh /usr/bin/run-hadoop.sh
RUN chmod +x /usr/bin/run-hadoop.sh

# NameNode (HDFS)
EXPOSE 8020 50070

# DataNode (HDFS)
EXPOSE 50010 50020 50075

# ResourceManager (YARN)
EXPOSE 8030 8031 8032 8033 8088

# NodeManager (YARN)
EXPOSE 8040 8042

# JobHistoryServer
EXPOSE 10020 19888

# HUE
EXPOSE 8888

# Run Hadoop
CMD ["/usr/bin/run-hadoop.sh"]
