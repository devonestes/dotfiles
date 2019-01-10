#!/bin/bash

find /home/devon/Dropbox | entr -r rclone sync -v /home/devon/Dropbox remote
