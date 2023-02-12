#!/bin/bash

source common_settings.txt

#If script is called from launchd there could be a minor delay before device becomes active - here we wait for device activation

echo "Wait for device to activate"
DEVICE="$CAMILLA_OUT_DEVICE"
MAX_ATTEMPTS=30
ATTEMPT=1 
while [ "$(system_profiler SPAudioDataType | grep -o $DEVICE)" != $DEVICE ]; do
  if [ $ATTEMPT -gt $MAX_ATTEMPTS ]; then
	  echo "Exceeded maximum number of attempts still no luck. Exiting"
	  exit 0
  fi
  echo "Still waiting, attempt $ATTEMPT ..."
  ATTEMPT=$((ATTEMPT+1))
  sleep 0.1
done
sleep 1

echo "Stop running instances if any"
pkill -9 -f "camilladsp"
pkill -9 -f "camillagui"
echo "Starting DSP"
$CAMILLA_HOME/camilladsp -p $CAMILLA_PORT -o $CAMILLA_HOME/camilladsp.log $CAMILLA_HOME/active_config.yml > /dev/null 2>&1 &
CAMILLA_PID=$!
MAX_ATTEMPTS=30
ATTEMPT=1 
echo "CamillaDSP started with PID = $CAMILLA_PID, waiting for port opening"

#Wait for DSP activation before attempting to start GUI

while ! nc -z localhost $CAMILLA_PORT; do
  if [ $ATTEMPT -gt $MAX_ATTEMPTS ]; then
    echo "Exceeded maximum number of attempts still no luck. Exiting"
    pkill -9 -f "camilladsp"
    exit 0
  fi
  echo "Still waiting, attempt $ATTEMPT ..."
  ATTEMPT=$((ATTEMPT+1))
  sleep 0.1
done

echo "CamillaDSP port is now open. Starting GUI"
/usr/local/bin/python3 $CAMILLA_HOME/camillagui/main.py > /dev/null 2>&1 &
echo "Everything is up & running"
if [ "$1" = "-nowait" ]; then
	echo "CamillaDSP is running in background"
else
	echo "Waiting for CamillaDSP process to stop"
	wait $CAMILLA_PID
	echo "CamillaDSP process stopped"
fi
