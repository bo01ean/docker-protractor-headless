#!/bin/bash
npm install

su robocop -c "

  dbus-launch --exit-with-session
  echo \"$@:\"
  xvfb-run -a --server-args=\"-screen 0 ${SCREEN_RES}\" protractor $@

"
