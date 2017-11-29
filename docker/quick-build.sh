#!/bin/sh
set -x
set -e

# Set temp environment vars
export GOPATH=/tmp/go
export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin
export GO15VENDOREXPERIMENT=1

cd ${GOPATH}/src/github.com/gogits/gogs
make build TAGS="sqlite cert pam"
mv /app/gogs/build/gogs /app/gogs/
