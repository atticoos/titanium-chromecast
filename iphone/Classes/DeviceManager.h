//
//  DeviceManager.h
//  titanium-chromecast
//
//  Created by Atticus White on 12/20/14.
//
//

#import <GoogleCast/GoogleCast.h>
#import "Device.h"
#import "DeviceManagerDelegate.h"

@interface DeviceManager : NSObject<GCKDeviceManagerDelegate, DeviceManagerDelegate>

@property(nonatomic, strong) Device* device;
@property(nonatomic, strong) NSString* APPID;
@property(nonatomic, strong) GCKDeviceManager* manager;

@end