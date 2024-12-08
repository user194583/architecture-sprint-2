#!/bin/bash

echo "--- Waiting 1s"
sleep 1

echo "*** Check for count docs in shard1"
echo "-- shard1_1"
docker compose exec -T shard1_1 mongosh --port 27018 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
echo "-- repl1_1"
docker compose exec -T repl1_1 mongosh --port 27021 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
echo "-- repl1_2"
docker compose exec -T repl1_2 mongosh --port 27022 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
echo "-- repl1_3"
docker compose exec -T repl1_3 mongosh --port 27023 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF


echo
echo "*** Check for count docs in shard2"
echo "-- shard1_2"
docker compose exec -T shard1_2 mongosh --port 27019 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
echo "-- repl2_1"
docker compose exec -T repl2_1 mongosh --port 27024 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
echo "-- repl2_2"
docker compose exec -T repl2_2 mongosh --port 27025 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
echo "-- repl2_3"
docker compose exec -T repl2_3 mongosh --port 27026 --quiet <<EOF
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
