//
//  ComAtticoosTitaniumChromecastDeviceManagerProxy.h
//  titanium-chromecast
//
//  Created by Atticus White on 12/20/14.
//
//

#import "TiProxy.h"
#import "DeviceManager.h"
#import <GoogleCast/GoogleCast.h>

@interface ComAtticoosTitaniumChromecastDeviceManagerProxy : TiProxy<GCKDeviceScannerListener,
                                                                    GCKMediaControlChannelDelegate>
@property(nonatomic, strong) DeviceManager* deviceManager;
@property(nonatomic, strong) GCKDeviceScanner* deviceScanner;


-(void)startScanning:(id)args;
-(void)stopScanning:(id)args;
-(NSArray*)getDiscoveredDevices:(id)args;


@end