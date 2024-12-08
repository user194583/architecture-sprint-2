#!/bin/bash

###
# Настраиваем шардирование
###

echo "Waiting 5s"
sleep 5

echo "Start setup config node"
docker compose exec -T configSrv1_3 mongosh --port 27017 --quiet <<EOF
rs.initiate(
  {
    _id : "config_server",
    configsvr: true,
    members: [
      { _id : 0, host : "configSrv1_1:27015" },
      { _id : 1, host : "configSrv1_2:27016" },
      { _id : 2, host : "configSrv1_3:27017" }
    ]
  }
);
exit();
EOF

echo "Waiting 2s"
sleep 2
echo "Start setup shard1 node"
docker compose exec -T shard1_1 mongosh --port 27018 --quiet <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1_1:27018" },
        { _id : 1, host : "repl1_1:27021" },
        { _id : 2, host : "repl1_2:27022" },
        { _id : 3, host : "repl1_3:27023" }
      ]
    }
);
exit();
EOF

echo "Waiting 2s"
sleep 2
echo "Start setup shard2 node"
docker compose exec -T shard1_2 mongosh --port 27019 --quiet <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 0, host : "shard1_2:27019" },
        { _id : 1, host : "repl2_1:27024" },
        { _id : 2, host : "repl2_2:27025" },
        { _id : 3, host : "repl2_3:27026" }
      ]
    }
);
exit();
EOF

echo "Waiting 15s"
sleep 15
echo "Start setup router node"
docker compose exec -T router1 mongosh --port 27020 --quiet <<EOF
sh.addShard("shard1/shard1_1:27018");
sh.addShard("shard2/shard1_2:27019");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );
exit();
EOF

echo "Waiting 5s"
sleep 5
echo "Fill data 1000 documents"
docker compose exec -T router1 mongosh --port 27020 --quiet <<EOF
use somedb;
for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i});
sh.getShardedDataDistribution();
exit();
EOF


