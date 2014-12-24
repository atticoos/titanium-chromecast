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
-(BOOL)isScanning:(id)args;
-(BOOL)isConnected:(id)args;
-(BOOL)isConnectedToApp:(id)args;
-(NSString*)getConnectedAppSessionID:(id)args;
-(NSString*)getConnectedAppStatusText:(id)args;
-(NSArray*)getDiscoveredDevices:(id)args;
-(BOOL)hasConnectedDevice:(id)args;
-(Device*)getConnectedDevice:(id)args;


@end