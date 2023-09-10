#!/bin/bash

for script in $(ls scripts/install-*.sh); do
    echo "Running $script"
    chmod +x $script
    ./$script
done