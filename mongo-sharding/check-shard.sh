#!/bin/bash

echo "--- Waiting 1s"
sleep 1

echo "*** Check for count docs in shard1"
docker compose exec -T shard1_1 mongosh --port 27018 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF

echo
echo "*** Check for count docs in shard2"
docker compose exec -T shard1_2 mongosh --port 27019 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF

echo
echo "*** Check for total docs in shard1 + shard2"
docker compose exec -T router1 mongosh --port 27020 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
