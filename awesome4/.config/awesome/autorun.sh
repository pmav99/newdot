#!/usr/bin/env bash

function run {
  if ! pgrep -f $1 ;
  then
    "${@}" &
  fi

}

run parcellite
run kbdd
run redshift-gtk
#run systemctl --user start plasma-polkit-agent
