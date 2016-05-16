//
//  DeviceManagerDelegate.h
//  titanium-chromecast
//
//  Created by Atticus White on 12/22/14.
//
//
#import <GoogleCast/GoogleCast.h>

@class Device;

@protocol DeviceManagerDelegate

-(void)connect:(Device*)device;
-(void)launchApplication;
-(void)removeChannel;
-(void)addChannel:(NSString*)nameSpace;
-(void)sendMessage:(NSString*)message;
-(void)onChannelMessage:(NSString*)message;
-(void)onChannelDisconnect;

-(BOOL)isDeviceEqualToConnectedDevice:(Device*)device;
-(NSNumber*)isConnectedToApp;
-(void)loadMedia:(GCKMediaInformation*)mediaInformation atPosition:(NSTimeInterval)position;

@end