#!/bin/bash

export PORT=5101

cd ~/www/memory
./bin/memory stop || true
./bin/memory start

