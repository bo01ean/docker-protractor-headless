#!/bin/bash
chmod 777 /protractor

su testerguy -c "
  npm run start &
  echo "I AM: ${whoami} .. sleeping for 50"
  sleep 50
  npm install
  gulp
"
