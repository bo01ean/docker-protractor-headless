#!/bin/bash
npm install
chmod 777 /protractor
su testerguy -c "

  dbus-launch --exit-with-session
  echo \"$@:\"
  xvfb-run -f /tmp/ -a --server-args=\"-screen 0 ${SCREEN_RES}\" protractor $@

"
