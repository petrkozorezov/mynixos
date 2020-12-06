#!/bin/sh
BASE=`pwd`/`dirname $0`
echo $BASE
sudo ln -s $BASE/system /etc/nixos &&
     ln -s $BASE/nixpkgs ~/.config/nixpkgs
