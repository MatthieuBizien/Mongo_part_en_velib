#!/bin/bash
set -e
set -x

sudo apt-get install mongodb-10gen
sudo service mongodb restart

# Add  index
#db.stations.ensureIndex({"contract_name": 1, "number": 1, "last_update": 1})
#db.stations.ensureIndex({"position":"2d"})
mongo velos

