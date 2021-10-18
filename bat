#!/bin/bash

_usage() {
  local func=${FUNCNAME[1]}
  [[ $func = main ]] && func= || func=" $func"
  printf "Usage: ${0##*/}$func"
}

BAT_UP=/org/freedesktop/UPower/devices/battery_BAT1
BAT_CL=/sys/class/power_supply/BAT0

full() {
  upower -i $BAT_UP
}

summary() {
  upower -i $BAT_UP \
  | sed -En '/state|time to|percentage/{s/.*: +(.+)/\1/p}'
}

fix() {
  if (( ! $# )); then
    cat <<EOF
Fix charge thresholds.
$(_usage) <start> <end>
$(_usage) 100
EOF
    return 1
  fi

  START=$BAT_CL/charge_control_start_threshold
  END=$BAT_CL/charge_control_end_threshold

  if [ ! -f $START ]; then
    echo "Not found: $START"
    return 1
  fi

  if (( $# )); then
    if (( $1 == 100 )); then
      echo 0 > $START || exit 1
      echo 100 > $END || exit 1
    elif (( $1 >= 0 && $2 >= 1 && $1 < $2 )); then
      echo $1 > $START || exit 1
      echo $2 > $END   || exit 1
    else
      echo "Wrong parameters!"
      return 1
    fi
  fi

  for i in $BAT_CL/*_threshold; do
    echo "`basename $i` = `cat $i`"
  done
}

case "$1" in
  -h|--help)
    cat <<EOF
Battery utils.
$(_usage) [-h|--help] [s|summary] [f|fix]
EOF
    ;;
  s|summary)
    summary ;;
  f|fix)
    shift
    fix "$@" ;;
  *)
    full ;;
esac
