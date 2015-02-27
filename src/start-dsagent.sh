#!/usr/bin/env bash

sleep 30

CFG_DIR=/etc/datastax-agent

if [ ! -f $CFG_DIR/address.yaml ]; then
cat <<EOF >$CFG_DIR/address.yaml
stomp_interface: $OPSCENTER
EOF
fi

# Start process
/etc/init.d/datastax-agent start
