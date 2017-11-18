#!/bin/bash
echo "Run Tests:"
## npm run e2e

SLEEP=120
set -e
chmod 777 /protractor
cp '/home/testerguy/.meteor/packages/meteor-tool/1.5.2_2/mt-os.linux.x86_64/scripts/admin/launch-meteor' /usr/bin/meteor
su testerguy -c "
  TMPDIR=/tmp
  sudo echo 'whoami'
  ## dbus-launch --exit-with-session
  ## echo \"$@:\"
  xvfb-run -a --server-args=\"-screen 0 ${SCREEN_RES}\" gulp
"

#
# su testerguy -c "
#   echo 'Installing meteor:'; curl -k https://install.meteor.com/?release=1.5.2.2 | sh
#   npm run start &
#   echo 'sleeping for 50'
#   sleep 50
#   gulp
# "
