#!/usr/bin/env bash

# "strict mode"
# see http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

CONFIGURATION="${CONFIGURATION:-rvi_client.config}"

/rvi/scripts/setup_rvi_node.sh -d -n client -c "$CONFIGURATION"
/rvi/scripts/rvi_node.sh -n client

