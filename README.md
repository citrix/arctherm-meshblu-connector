# meshblu-connector-arc-thermometer

## _**Note: This is a demo connector only and not intended for use commercial use. This connector is incompatable with production versions of the ARC Thermometers.**_
---

# ARC Temp Connector on Raspberry Pi

## Install Raspbian on your RPi 3

Browse over to the Noobs download section, and download it:
https://www.raspberrypi.org/downloads/noobs/

- Unarchive the Zip file.
- Format your SD card.
- Copy the files onto your SD card

Power on the Raspberry Pi with the SD card inserted and follow the on-screen instructions to install Raspbian.

## Update libraries

Some libraries need to be removed prior to installing the newer version.
Login to your RPi and run the following command in terminal:

```bash
sudo apt-get -y remove nodejs*
```

Other libraries need to be updated to the latest version:

```bash
sudo apt-get update
sudo apt-get -y dist-upgrade
```

Next, we need to install the latest version of Node.js:

```bash
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
sudo apt-get install -y nodejs
```
And we need a couple g++:

```bash
sudo apt-get install g++
```

We also need a couple of Bluetooth helper libraries:

```bash
sudo apt-get install bluetooth bluez libbluetooth-dev libudev-dev
```

## Install connector

Let's install the connector! Get the source code from GitHub and install it:

```bash
git clone https://github.com/citrix/arctherm-meshblu-connector
cd arctherm-meshblu-connector
npm install
```

## Initial configuration

Create a meshblu.json config file in the arctherm-meshblu-connector directory and add the following code. Account UUID and TOKEN you get by visiting http://octoblu.com, logging in and clicking on profile icon in the upper right of the screen.

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

We need to modify the meshblu.json config file to match the registered THING in the Octoblu platform:

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
## Auto-start the connector

If you want to autostart the connector create this file and have the envirnment run it on start up:

```bash
cd ~/arctherm-meshblu-connector
sudo npm start
```

## Debug

If you need to debug:

```bash
sudo env DEBUG='meshblu-connector-arc-thermometer*' npm start
```
