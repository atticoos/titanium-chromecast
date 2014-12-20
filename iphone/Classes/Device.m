//
//  Device.m
//  titanium-chromecast
//
//  Created by Atticus White on 12/20/14.
//
//

#import "Device.h"
@implementation Device

-(instancetype)initWithDevice:(GCKDevice*)device
{
    self.device = device;
}

-(id)friendlyName
{
    return self.device.friendlyName;
}

-(id)ipAddress
{
    return self.device.ipAddress;
}

-(id)deviceID
{
    return self.device.deviceID;
}

@end