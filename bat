#!/bin/sh

bat=/org/freedesktop/UPower/devices/battery_BAT1
if [[ "$1" = -a ]]; then
  upower -i $bat
else
  upower -i $bat \
  | sed -En '/state|time to/{s/.*: +(.+)/\1/p}'
fi

