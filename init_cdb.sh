#!/bin/bash


echo Downloading cockroachdb
wget -qO- https://binaries.cockroachdb.com/cockroach-v2.0.0.linux-amd64.tgz | tar  xvz
if [ $? -ne 0 ]; then
  echo Unable to download cockroachdb
  exit 1
fi

echo Creating a cluster.


nohup cockroach-v2.0.0.linux-amd64/cockroach start --insecure --advertise-host=35.229.18.254 &
sleep 2
tail -f nohup.out
