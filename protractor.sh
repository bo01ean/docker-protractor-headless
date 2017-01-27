#!/bin/bash
npm install
chmod 777 /protractor
su robocop -c "

  dbus-launch --exit-with-session
  echo \"$@:\"
  xvfb-run -a --server-args=\"-screen 0 ${SCREEN_RES}\" protractor $@

"
