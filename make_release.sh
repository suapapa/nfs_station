#!/bin/bash

set -e

git tag -a $1 -m "Release $1"
git push origin $1

flutter build macos --release

mkdir -p release
PROJECT_ROOT=$(pwd)
cd "build/macos/Build/Products/Release"
zip -r "$PROJECT_ROOT/release/nfs_station-$1.zip" "NFS Station.app"
cd "$PROJECT_ROOT"