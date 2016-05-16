
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
-(NSNumber*)isConnected;
-(NSNumber*)isConnectedToApp;
-(NSNumber*)playerState:(id)args;
-(void)pauseChannel:(id)args;
-(void)changeVolume:(id)args;
-(void)changePlaybackPercent:(id)args;
-(void)incrementPlaybackBy:(id)args;
-(void)disconnect:(id)args;
-(NSString*)getConnectedAppSessionID:(id)args;
-(NSString*)connectedAppStatusText;
-(NSArray*)getDiscoveredDevices:(id)args;
-(NSNumber*)hasConnectedDevice:(id)args;
-(Device*)connectedDevice;


@end