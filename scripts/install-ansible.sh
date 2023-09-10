#!/bin/bash

## Check if Pip is installed

if ! [ -x "$(python3 -m pip -V)" ]; then
  echo 'Error: pip is not installed.' >&2
  sudo apt-get update
  sudo apt-get install python3-pip
else
  echo 'pip is installed.'
fi

## Run --version if the program is installed skip the installation

if ! [ -x "$(ansible --version)" ]; then
  echo 'Error: ansible is not installed.' >&2
  python3 -m pip install --user ansible
else
  echo 'ansible is installed! :)'
  echo "running upgrade..."
  python3 -m pip install --upgrade --user ansible
fi