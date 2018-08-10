#!/bin/sh

# MAINTAINER Stanislaw Mnizhek <me@stanislawmnizhek.ru>
#
# Github: https://github.com/xdefrag/fn
#
# License: MIT

# Adjust control directories for your needs. Works fine for Macbook Air 2017.
CONTROL_BACKLIGHT=/sys/class/backlight/intel_backlight
CONTROL_KBD_BACKLIGHT=/sys/class/leds/smc::kbd_backlight

NOTIFY_MIN="Already minimum value"
NOTIFY_MAX="Already maximum value"

usage() {
  echo Usage: ./fn.sh [TYPE] [VALUE]
  echo Set or adjust type to value.
  echo Examples:
  echo ./fn.sh backlight +100
  echo ./fn.sh kbd -100
  echo ./fn.sh sound 64
  echo
  echo Acceptable types: backlight, kbd, sound.
  echo Value format: sign + digit of just digit.
}

# Grepping input.
# + or - with digit for adjustment and digit fot setting.
# $1 is string.
parseArgument() {
  echo "$1" | egrep '[+-]?[0-9]+' --only-matching
}

# Parse number from string.
# $1 is string.
parseNumber() {
  echo "$1" | egrep '[0-9]+' --only-matching
}

# Parse sign (+ or -) from string.
# $1 is string.
parseSign() {
  echo "$1" | grep '[+-]' --only-matching
}

# Adjusting brightness. Works fine for backlight and kbd.
# $1 is class like /sys/class/backlight/intel_backlight
# $2 is adjustment like +2000
adjustBrightness() {
  local CONTROL=$1/brightness

  local CURRENT=$(cat $CONTROL)

  local MAX=$(cat $1/max_brightness)

  local SIGN=$(parseSign $2)
  local STEP=$(parseNumber $2)

  if [ $SIGN ]; then
    local AMOUNT=$(($CURRENT $SIGN $STEP))
  else
    local AMOUNT=$STEP
  fi

  if [ $CURRENT == 0 ] && [ "$SIGN" == "-" ]; then
    echo $NOTIFY_MIN
    exit
  fi

  if [ $CURRENT == $MAX ] && [ "$SIGN" == "+" ]; then
    echo $NOTIFY_MAX
    exit
  fi

  if [ $AMOUNT -lt 0 ]; then
    AMOUNT=0
  fi

  if [ $AMOUNT -gt $MAX ]; then
    AMOUNT=$MAX
  fi

  echo $AMOUNT | tee $CONTROL
}

# Adjusting volume. Assuming your soundcard is 1.
# $1 is adjustment like +5
adjustVolume() {
  local SIGN=$(parseSign $1)
  local STEP=$(parseNumber $1)

  amixer -c 1 -- set Master Playback $STEP$SIGN
}

# First argument must be type of adjustment: backlight, kbd, sound.
TYPE=$1
# Second argument must be adjustment: +2000.
ADJUST=$(parseArgument $2)

case $TYPE in
  "help") usage ;;
  "backlight") adjustBrightness $CONTROL_BACKLIGHT $ADJUST ;;
  "kbd") adjustBrightness $CONTROL_KBD_BACKLIGHT $ADJUST ;;
  "sound") adjustVolume $ADJUST ;;
  *) echo "Type not recognised. Please use backlight, kbd or sound." ;;
esac
