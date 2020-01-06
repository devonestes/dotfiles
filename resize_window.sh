#!/bin/bash

#define the height in px of the top system-bar:
TOPMARGIN=40

# get width of screen and height of screen
SCREEN_WIDTH=$(xwininfo -root | awk '$1=="Width:" {print $2}')
SCREEN_HEIGHT=$(xwininfo -root | awk '$1=="Height:" {print $2}')
OFFSET=$(( $SCREEN_WIDTH / 6 ))
W=$(( $SCREEN_WIDTH - $OFFSET ))

# new width and height
H=$(( $SCREEN_HEIGHT - $TOPMARGIN ))
Y=$TOPMARGIN

if [[ "$1" = "left" ]]; then
  X=0
else
  X=$OFFSET
fi

wmctrl -r :ACTIVE: -e 0,$X,$Y,$W,$H
