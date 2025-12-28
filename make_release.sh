#!/bin/bash

set -e

git tag -a $1 -m "Release $1"
git push origin $1

flutter build macos --release

zip -r release/nfs_mounter-$1.zip build/macos/Build/Products/Release/nfs_mounter.app