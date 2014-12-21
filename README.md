# titanium-chromecast

This project introduces support for GoogeCast to allow your applications to connect and interact with Chromecast enabled devices.

**This project is in active development** and currently targets iOS. Android is on the roadmap.

## Example Usage

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
		device.connect().then(function () {
			device.startApplication();
		});
	}
});

```
