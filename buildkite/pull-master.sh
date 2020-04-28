#!/bin/bash

fail () {
    echo "FAIL: $*"
    exit 1  
}

export HOME=/home/dw
source $HOME/.bashrc
cd $LJHOME

git diff-index --quiet HEAD || fail "Repository is unclean, unable to update."
git checkout master || fail "Failed to checkout master."
git pull --ff-only origin master || fail "Failed to pull."

echo "Successfully pulled master."
