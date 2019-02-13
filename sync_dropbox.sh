#!/bin/bash

DIR="/home/devon/Dropbox/save_stuff"
REMOTE="remote:save_stuff"

find $ORG_DIR | entr -r rclone sync -v $ORG_DIR $REMOTE
