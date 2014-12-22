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

@end