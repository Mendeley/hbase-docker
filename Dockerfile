FROM debian:squeeze
MAINTAINER Gianni O'Neill "gianni@mendeley.com"
ADD hbase-sources.list /etc/apt/sources.list.d/hbase-sources.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN apt-get update && apt-get install -y curl
RUN curl -s http://archive.cloudera.com/cdh4/debian/squeeze/amd64/cdh/archive.key | apt-key add -
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get update && apt-get install -y oracle-java7-installer
RUN apt-get update && apt-get install -y hbase hbase-master hbase-regionserver hadoop-0.20-mapreduce-tasktracker hadoop-0.20-mapreduce-jobtracker hadoop-hdfs-datanode hadoop-hdfs-namenode hadoop-hdfs-secondarynamenode supervisor
ADD hbase-site.xml /etc/hbase/conf.dist/hbase-site.xml
ADD core-site.xml /etc/hadoop/conf/core-site.xml
ADD mapred-site.xml /etc/hadoop/conf/mapred-site.xml
RUN mkdir -p /var/log/supervisor/hadoop
ADD supervisor.conf /etc/supervisor/conf.d/hbase.conf
ADD hadoop-setup.sh /usr/bin/hadoop-setup.sh
RUN chmod +x /usr/bin/hadoop-setup.sh
RUN hadoop namenode -format
RUN hadoop-setup.sh && supervisord && until nc -z 127.0.0.1 50070; do echo "Waiting for HDFS..."; sleep 1s; done \
    && hdfs dfs -mkdir /tmp && hdfs dfs -chmod 777 /tmp \
    && hdfs dfs -mkdir -p /tmp/hadoop-mapred/mapred && hdfs dfs -chmod 777 /tmp/hadoop-mapred/mapred \
    && hdfs dfs -mkdir /user && hdfs dfs -chmod 777 /user
ADD hbase-site.xml /etc/hbase/conf.dist/hbase-site.xml
ADD core-site.xml /etc/hadoop/conf/core-site.xml
ADD mapred-site.xml /etc/hadoop/conf/mapred-site.xml
RUN rm -R /tmp/hbase-root/zookeeper

CMD bash -c 'hadoop-setup.sh && supervisord -n'
