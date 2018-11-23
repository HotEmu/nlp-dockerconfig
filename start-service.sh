#!/usr/bin/env bash

echo "Starting CoreNLP script"

sudo /usr/sbin/init

sudo systemctl is-system-running

while [[  `sudo systemctl is-system-running` != "running" ]]; do
    echo "Waiting..."
done

sudo systemctl start corenlp
