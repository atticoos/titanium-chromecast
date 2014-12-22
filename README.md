# titanium-chromecast

This project introduces support for GoogeCast to allow your applications to connect and interact with Chromecast enabled devices.

**This project is in active development** and currently targets iOS. Android is on the roadmap.

# Example Usage

```js
// reference the module
var Chromecast = require('com.atticoos.titanium.chromecast');

// create an instance of the device manager
var deviceManager = Chromecast.createDeviceManager(APP_ID);

// listen for new devices
deviceManager.addEventListener('deviceOnline', function (e) {
	var device = e.device;

	//connect to device
	if (!deviceManager.isConnected()) {
		device.connect(function () {
			device.startApplication(function () {
				device.sendMessage('Hello world!');
			});
		});
	}
});
```


# Components
This module provides a few primary components that provide an API to the GoogleCast SDK. This API is not a 1-1 mapping to all the SDK endpoints, it's more of an abstraction to provide easier integrations. While all the capabilities of the SDK are available, they are exposed in different ways.

## Device Manager
This is the first component to get started with a Chromecast device. This component provides the scanning services and an interface to all events that can take place with your Chromecast.


### Methods

#### DeviceManager.startScanning()
Returns: `void`

This begins the scanning service to look for nearby devices

#### DeviceManager.stopScanning()
Returns: `void`

Stops the scanning service

#### DeviceManager.getDiscoveredDevices()
Returns: `Array`

Returns a collection of discovered [Devices](#devices).

#### DeviceManager.isConnected()
Returns: `Boolean`

Returns true/false depending on if there is a connected device



### Events
#### deviceOnline
Called when a device is discovered

#### deviceOffline
Called when a device that was discovered appears offline

----

## <a href="#devices"></a>Device
This is the device component that returns the information about the current device and an API to interact with the device

----
### Methods

#### Device.connect(successCallback, errorCallback)
Connects to a device and executes the callback once connected or encounters an error

#### Device.launchApplication(successCallback, errorCallback)
Starts the application on a device and executes the callback once connected or encounters an error

#### Device.addChannel(namespace)
Creates a channel over the provided namespace on the device

#### Device.sendMessage(string)
Sends a message over the channel to the chromecast app

### Events
#### messageReceived
Called when receiving a message over the device's channel
