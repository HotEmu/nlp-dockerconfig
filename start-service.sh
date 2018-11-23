#!/usr/bin/env bash

echo "Starting CoreNLP script"
sudo systemctl is-system-running

while [[  `systemctl is-system-running` != "running" ]]; do
    echo "DONE"
    sudo systemctl start corenlp
done