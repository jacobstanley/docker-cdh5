#!/bin/bash

service hadoop-hdfs-namenode start
service hadoop-hdfs-datanode start

su hdfs -- hadoop fs -mkdir -p /tmp/hadoop-yarn/staging/history/done_intermediate
su hdfs -- hadoop fs -chown -R mapred:mapred /tmp/hadoop-yarn/staging
su hdfs -- hadoop fs -chmod -R 1777 /tmp
su hdfs -- hadoop fs -mkdir -p /var/log/hadoop-yarn
su hdfs -- hadoop fs -chown yarn:mapred /var/log/hadoop-yarn

service hadoop-yarn-resourcemanager start
service hadoop-yarn-nodemanager start
service hadoop-mapreduce-historyserver start

su hdfs -- hadoop fs -mkdir -p /user/hdfs
su hdfs -- hadoop fs -chown hdfs /user/hdfs

service hue start

sleep 1

# tail log directory
tail -n 1000 -f /var/log/hadoop-*/*.out
