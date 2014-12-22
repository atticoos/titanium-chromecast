//
//  DeviceManagerDelegate.h
//  titanium-chromecast
//
//  Created by Atticus White on 12/22/14.
//
//

@class Device;

@protocol DeviceManagerDelegate

-(void)connect:(Device*)device;
-(void)launchApplication;
-(void)addChannel:(NSString*)nameSpace;
-(void)sendMessage:(NSString*)message;
-(void)onChannelMessage:(NSString*)message;

@end