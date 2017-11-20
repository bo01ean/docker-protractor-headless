#!/bin/bash
echo "Run Tests:"
set -e
chmod 777 /protractor
su testerguy -c "
  TMPDIR=/tmp
  whoami
  sudo whoami
  xvfb-run -a --server-args=\"-screen 0 ${SCREEN_RES}\" meteor
"
