#!/bin/bash

source common_settings.txt

echo "Configuring auto start of CamillaDSP after device $CAMILLA_OUT_DEVICE is connected"

CAMILLA_OUT_DEVICE_VENDOR_ID=$(ioreg -n "$CAMILLA_OUT_DEVICE" -p IOUSB | grep idVendor | grep -E -o "[0-9]+")
CAMILLA_OUT_DEVICE_PRODUCT_ID=$(ioreg -n "$CAMILLA_OUT_DEVICE" -p IOUSB | grep idProduct | grep -E -o "[0-9]+")

if [ "" = "$CAMILLA_OUT_DEVICE_VENDOR_ID" ]; then
	echo "Unable to determine idVendor for $CAMILLA_OUT_DEVICE device"
	exit 0
fi

if [ "" = "$CAMILLA_OUT_DEVICE_PRODUCT_ID" ]; then
	echo "Unable to determine idProduct for $CAMILLA_OUT_DEVICE device"
	exit 0
fi

echo "Generaing launchd plist file"

cat launchd.plist.template | \
	sed "s~DEVICE_VENDOR_ID~$CAMILLA_OUT_DEVICE_VENDOR_ID~g" | \
	sed "s~DEVICE_PRODUCT_ID~$CAMILLA_OUT_DEVICE_PRODUCT_ID~g" | \
	sed "s~CAMILLA_DAEMON_NAME~$CAMILLA_DAEMON_NAME~g" | \
	sed "s~CAMILLA_HOME~$CAMILLA_HOME~g" | \
	sed "s~CAMILLA_USER~$CAMILLA_USER~g" \
	> "generated.plist"

echo "Unloading previous plist file"

launchctl unload /Library/LaunchDaemons/$CAMILLA_DAEMON_NAME.plist

echo "Setting up new launchd daemon at $CAMILLA_DAEMON_NAME.plist ..."

sudo cp generated.plist /Library/LaunchDaemons/$CAMILLA_DAEMON_NAME.plist 
sudo chown root:wheel /Library/LaunchDaemons/$CAMILLA_DAEMON_NAME.plist 
launchctl load /Library/LaunchDaemons/$CAMILLA_DAEMON_NAME.plist

rm generated.plist

echo "Done"

