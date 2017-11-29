#!/bin/sh
set -x
set -e

# Set temp environment vars
export GOPATH=/tmp/go
export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin
export GO15VENDOREXPERIMENT=1

# Install build deps
apk --no-cache --no-progress add --virtual build-deps build-base linux-pam-dev

# Install go-bindata
# Don't need this, provided in package
# go get github.com/jteeuwen/go-bindata
# cd ${GOPATH}/src/github.com/jteeuwen/go-bindata/go-bindata
# go install

# Build
mkdir -p ${GOPATH}/src/github.com/gogits/
ln -s /app/gogs/build ${GOPATH}/src/github.com/gogits/gogs
cd ${GOPATH}/src/github.com/gogits/gogs
# Needed since git 2.9.3 or 2.9.4
git config --global http.https://gopkg.in.followRedirects true
make build TAGS="sqlite cert pam"

# add custom configuration
cp /app/gogs/build/conf/helpme.ini /data/gogs/conf/app.ini

# Cleanup GOPATH
# rm -r $GOPATH

# Remove build deps
# apk --no-progress del build-deps

# Create git user for Gogs
addgroup -S git
adduser -G git -H -D -g 'Gogs Git User' git -h /data/git -s /bin/bash && usermod -p '*' git && passwd -u git
echo "export GOGS_CUSTOM=${GOGS_CUSTOM}" >> /etc/profile
