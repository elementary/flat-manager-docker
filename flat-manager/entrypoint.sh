#!/bin/bash

set -euo pipefail
set -o errexit
set -o errtrace

if [ -f $STARTUP_SCRIPT ]; then
    echo "Running startup file.";
    sh $STARTUP_SCRIPT;
fi

if [ ! -f $REPO_CONFIG ]; then
    echo "No config found, copying example config.";
    cp /etc/flat-manager/example-config.json "$REPO_CONFIG";
fi

exec $*;
