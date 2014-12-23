# titanium-chromecast

This project introduces support for GoogeCast to allow your applications to connect and interact with Chromecast enabled devices.

**This project is in active development** and currently targets iOS. Android is on the roadmap.

# Example Usage

```js
// reference the module
var Chromecast = require('com.atticoos.titanium.chromecast');

// create an instance of the device manager
var deviceManager = Chromecast.createDeviceManager({
	app: "APP_ID" // required
});

// listen for new devices
deviceManager.addEventListener('deviceOnline', function (e) {
	var device = e.device;

	//connect to device
	if (!deviceManager.isConnected()) {
		device.connect(function () {
			device.startApplication(function () {
				device.sendJsonMessage({foo: 'bar'});
			});
		});
	}
});
```


# Components
This module provides a few primary components that provide an API to the GoogleCast SDK. This API is not a 1-1 mapping to all the SDK endpoints, it's more of an abstraction to provide easier integrations. While all the capabilities of the SDK are available, they are exposed in different ways.

## Device Manager
The device manager oversees all the devices and manages your connectivity to the Chromecast. It provides an interface to the Chromecast for the devices to use. For interacting with the Chromecast directly, you will use the [device](#device), but you can still go back to the DeviceManager if necessary.


### Methods

#### DeviceManager.startScanning()
Returns: `void`

This begins the scanning service to look for nearby devices

#### DeviceManager.stopScanning()
Returns: `void`

Stops the scanning service

#### DeviceManager.getDiscoveredDevices()
Returns: `Array`

Returns a collection of discovered [Devices](#device).


#### DeviceManager.isScanning()
Returns: `Boolean` Default: `false`

Returns true/false depending on if the scanner is running

#### DeviceManager.isConnected()
Returns: `Boolean` Default: `false`

Returns true/false depending on if there is a connected device


#### DeviceManager.isConnectedToApp()
Returns: `Boolean` Default: `false`

Returns true/false depending on if the application is connected

#### DeviceManager.getConnectedAppSessionID()
Returns: `String` Default: `null`

Returns the sessionID of the connected application

#### DeviceManager.getConnectedAppStatusText()
Returns: `String` Default: `null`

Returns the status text of the connected application



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
Returns: `void`

Connects to a device and executes the callback once connected or encounters an error

#### Device.launchApplication(successCallback, errorCallback)
Returns: `void`

Starts the application on a device and executes the callback once connected or encounters an error

#### Device.addChannel(namespace)
Returns: `void`

Creates a channel over the provided namespace on the device

#### Device.removeChannel()
Returns: `void`

Removes a channel that was previously added, otherwise does nothing

#### Device.sendMessage(string)
Returns: `void`

Sends a message over the channel to the chromecast app

#### Device.sendJsonMessage(object)
Returns: `void`

Sends a JSON object as a message

#### Device.isConnected()
Returns: `Boolean` Default: `false`

Returns true/false if this device is connected

#### Device.isConnectedToApp()
Returns: `Boolean` Default: `false`

returns true/false if this device is connected to the application on the chromecast



### Events
#### messageReceived
Called when receiving a message over the device's channel
