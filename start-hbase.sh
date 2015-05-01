#!/bin/bash

# Starts the base platforms needed for Hbase
# This will give us another bash shell
# possibly with all the hoya bits loaded into it
/etc/bootstrap-hoya.sh -bash

# Launch a vanilla hbase cluster (1 master, 1 regionserver)
hoya create hbase --role master 1 --role worker 1
    --manager localhost:8032
    --filesystem hdfs://localhost:9000 --image hdfs://localhost:9000/hbase.tar.gz
    --appconf file:///usr/local/hbaseconf/
    --zkhosts localhost
