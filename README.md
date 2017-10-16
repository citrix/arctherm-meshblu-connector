# meshblu-connector-arc-instatemp

#[![Dependency status](http://img.shields.io/david/octoblu/meshblu-connector-ble-heartrate.svg?style=flat)](https://david-dm.org/octoblu/meshblu-connector-ble-heartrate)
#[![devDependency Status](http://img.shields.io/david/dev/octoblu/meshblu-connector-ble-heartrate.svg?style=flat)](https://david-dm.org/octoblu/meshblu-connector-ble-heartrate#info=devDependencies)
#[![Build Status](http://img.shields.io/travis/octoblu/meshblu-connector-ble-heartrate.svg?style=flat&branch=master)](https://travis-ci.org/octoblu/meshblu-connector-ble-heartrate)
[![Slack Status](http://community-slack.octoblu.com/badge.svg)](http://community-slack.octoblu.com)

#ARC Temp Connector on Raspberry Pi

## Install Raspbian on your RPi 3

Browse over to the Noobs download section, and download it.
https://www.raspberrypi.org/downloads/noobs/

- Unarchive the Zip file.
- Format your SD card.
- Copy the files onto your SD card

Power on the Raspberry Pi with the SD card inserted and follow the on-screen insctructions to install Raspbian.

## Update libraries

Some libraries need to be removed prior to installing the newer version.
Login to your RPi and run the following commands in terminal:

```bash
sudo apt-get -y remove nodejs*
sudo apt-get update
sudo apt-get -y dist-upgrade
```

Next, we install the latest version of NodeJS:

```bash
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs
```

We also need a couple of Bluetooth helper libraries:

```bash
sudo apt-get install bluetooth bluez libbluetooth-dev libudev-dev
```

## Install connector

Let's install the connector! Get ARC Temp from GitHub and install it:

```bash
git clone https://github.com/IoTdo/meshblu-connector-arc-instatemp
cd meshblu-connector-arc-instatemp
npm install
```

Create a meshblu.json config file and add the following code. Account UUID and TOKEN you get by visiting http://octoblu.com, logging in and clicking on profile icon in the upper right of the screen.

```bash
{
  "uuid": "YOUR_ACCOUNT_UUID",
  "token": "YOUR_ACCOUNT_TOKEN",
  "protocol": "https",
  "hostname": "meshblu.octoblu.com",
  "port": 443
}
```

Run the connector so that it registers as a THING in Octoblu: 

```bash
sudo npm start
```

Now you should be able to see the connector available in the Octoblu platform under My Things - Other.

## Final configuration

On your Raspberry Pi, stop the connector (press CTRL + C).

We need to modify the meshblu.config config file to match the registered THING in the Octoblu platform:

```bash
{
  "uuid": "locate the THING, click it, and get YOUR_DEVICE_UUID",
  "token": "within your thing, generate a new YOUR_DEVICE_TOKEN",
  "protocol": "https",
  "hostname": "meshblu.octoblu.com",
  "port": 443
}
```

Restart the connector: 

```bash
sudo npm start
```

## Debug

If you need to debug:

```bash
sudo env DEBUG='meshblu-connector-arc-instatemp*' npm start
```
