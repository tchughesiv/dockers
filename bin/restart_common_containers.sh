#!/bin/bash
cd $(readlink -f $0 | xargs dirname)
mkdir -p ../logs
./restart_dmitry_container.sh >> ../logs/dmitry_restart.log &
./restart_gregory_container.sh >> ../logs/gregory_restart.log &
./restart_travis_container.sh >> ../logs/travis_restart.log &
./restart_rustam_container.sh >> ../logs/rustam_restart.log &

