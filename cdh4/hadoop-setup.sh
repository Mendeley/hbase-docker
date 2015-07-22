#!/bin/bash
sed -i "s/@ipaddr@/$(hostname -i)/g" /etc/hadoop/conf/core-site.xml
sed -i "s/@hostname@/$(hostname)/g" /etc/hadoop/conf/mapred-site.xml
sed -i "s/@hostname@/$(hostname)/g" /etc/hbase/conf/hbase-site.xml
