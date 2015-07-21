#!/usr/bin/env bash

# "strict mode"
# see http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

CONFIGURATION="${CONFIGURATION:-dev.config}"

/rvi/scripts/setup_rvi_node.sh -d -n dev -c "$CONFIGURATION"
/rvi/scripts/rvi_node.sh -n dev

