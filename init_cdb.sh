#!/bin/bash

my_public_ip=$(curl -s https://api.ipify.org)
echo "My public IP address is: $my_public_ip"

x=$(curl -s "https://picolo-b4999.firebaseio.com/cluster_ip.json")
cluster_manager_ip=`echo $x | sed "s/\"//g"`

if [ ! -f "cockroach-v2.0.0.linux-amd64/cockroach" ]; then

echo Downloading cockroachdb
wget -qO- https://binaries.cockroachdb.com/cockroach-v2.0.0.linux-amd64.tgz | tar  xvz
if [ $? -ne 0 ]; then
  echo Unable to download cockroachdb
  exit 1
fi
else 
    echo "Using existing cockroach db binary"
fi
rm -f nohup.out

if `curl metadata.google.internal -i`; then
    echo "Creating a new cluster on GCE"
    nohup cockroach-v2.0.0.linux-amd64/cockroach start --insecure --advertise-host=$my_public_ip &
else
    echo "Attempting to join a GCE cluster at "$cluster_manager_ip
    echo cockroach-v2.0.0.linux-amd64/cockroach start --join $cluster_manager_ip:26257 --insecure --advertise-host=$my_public_ip 
    cockroach-v2.0.0.linux-amd64/cockroach start --join=$cluster_manager_ip:26257 --insecure --advertise-host=$my_public_ip &
fi

sleep 2
tail -f nohup.out
