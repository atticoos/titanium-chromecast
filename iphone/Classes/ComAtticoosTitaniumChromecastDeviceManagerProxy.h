//
//  ComAtticoosTitaniumChromecastDeviceManagerProxy.h
//  titanium-chromecast
//
//  Created by Atticus White on 12/20/14.
//
//

#import "TiProxy.h"
#import <GoogleCast/GoogleCast.h>

@interface ComAtticoosTitaniumChromecastDeviceManagerProxy : TiProxy<GCKDeviceScannerListener,
                                                                    GCKDeviceManagerDelegate,
                                                                    GCKMediaControlChannelDelegate>
@property(nonatomic, strong) GCKDeviceManager* deviceManager;
@property(nonatomic, strong) GCKDeviceScanner* deviceScanner;


-(void)startScanning:(id)args;
-(void)stopScanning:(id)args;
-(NSArray*)getDiscoveredDevices:(id)args;


@end