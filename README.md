# docker-stratio-cassandra-ds-agent
Docker Image providing Stratio Cassandra along with DataStax Opscenter Agent

This image contains Stratio Cassandra 2.1.2.2, Datastax Agent 5.1.0 and is based on inovatrend/java8

It is designed to run a cluster on multiple physical hosts, one of them also hosting Opscenter.

Run this using:

```
export PUBLIC=$(hostname -i)
export DC=mydatacenter
export SEEDS="physicalhost1-ip,physicalhost2-ip,physicalhostn-ip"
export PHYSICAL_VOL=/path/to/volume

docker pull fixme:latest
docker run -d -t -i --name cassandra -p $PUBLIC:9042:9042 -p $PUBLIC:7000:7000 -p $PUBLIC:7001:7001 -p $PUBLIC:9160:9160 -p $PUBLIC:7199:7199 -e DC=$DC -e RACK=r1 -e PUBLICIP=$PUBLIC -e OPSCENTER=$PUBLIC -v $PHYSICAL_VOL:/cassandra/data fixme/latest
