#!/bin/bash

# get width of screen and height of screen
SCREEN_WIDTH=$(xwininfo -root | awk '$1=="Width:" {print $2}')
SCREEN_HEIGHT=$(xwininfo -root | awk '$1=="Height:" {print $2}')

if [[ "$SCREEN_WIDTH" -gt "2000" ]]; then
  OFFSET=$(( $SCREEN_WIDTH / 12 ))
else
  OFFSET=$(( $SCREEN_WIDTH / 6 ))
fi

W=$(( $OFFSET * 5 ))
H=$(( $SCREEN_HEIGHT - 40 ))

case "$1$SCREEN_WIDTH" in
other3*)
  X=0
  W=$(( $SCREEN_WIDTH / 2))
  ;;
left3*)
  X=0
  X=$(( $OFFSET * 6 ))
  ;;
right3*)
  X=$(( $OFFSET * 7 ))
  ;;
right*)
  X=$(( $OFFSET ))
  ;;
*)
  X=0
  ;;
esac

if [[ -z "$2" ]]
then
  wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz
  sleep 0.1
  wmctrl -r :ACTIVE: -e 0,$X,0,$W,$H
  sleep 0.5
else
  wmctrl -i -r "$2" -b remove,maximized_vert,maximized_horz
  sleep 0.1
  wmctrl -i -r "$2" -e 0,$X,0,$W,$H
  sleep 0.5
fi
