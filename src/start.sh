#!/usr/bin/env bash

DC=${DC:-DC1}
RACK=${RACK:-RACK1}

IP=`hostname --ip-address`
BROADCAST=${PUBLICIP:-$IP}

if [ $# == 1 ]; then SEEDS="$1,$BROADCAST"; 
else SEEDS="$BROADCAST"; fi

echo Configuring Cassandra to listen at $IP with seeds $SEEDS

# Setup Cassandra
DEFAULT=/etc/cassandra/default.conf
CONFIG=/etc/cassandra/conf

#rm -rf $CONFIG && cp -r $DEFAULT $CONFIG
sed -i -e "s/^listen_address.*/listen_address: $IP/"            $CONFIG/cassandra.yaml
sed -i -e "s/^endpoint_snitch.*/endpoint_snitch: GossipingPropertyFileSnitch/"            $CONFIG/cassandra.yaml
sed -i -e "s/^[# ]*broadcast_address.*/broadcast_address: $BROADCAST/"            $CONFIG/cassandra.yaml
sed -i -e "s/^[# ]*broadcast_rpc_address.*/broadcast_rpc_address: $BROADCAST/"            $CONFIG/cassandra.yaml
sed -i -e "s/^rpc_address.*/rpc_address: 0.0.0.0/"              $CONFIG/cassandra.yaml
sed -i -e "s/- seeds: \"127.0.0.1\"/- seeds: \"$SEEDS\"/"       $CONFIG/cassandra.yaml
sed -i -e "s/.*-Djava.rmi.server.hostname=<public name>\"/JVM_OPTS=\"$JVM_OPTS -Djava.rmi.server.hostname=$BROADCAST\"/" $CONFIG/cassandra-env.sh

cat <<EOF >$CONFIG/cassandra-rackdc.properties
dc=$DC
rack=$RACK
EOF

# Start process
echo Starting Cassandra on $IP...
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
