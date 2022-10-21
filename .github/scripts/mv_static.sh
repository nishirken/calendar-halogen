#! /usr/bin/env bash

scp -i ~/.ssh/gandi_key -r static $USERNAME@$HOST:/var/calendar-halogen/halogen
ssh -i ~/.ssh/gandi_key $USERNAME@$HOST "
  cd /var/calendar-halogen
  mkdir tmp
  mv halogen/static tmp
  mv tmp/static/* halogen
  rm -rf tmp
"
