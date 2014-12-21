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
    if (self = [super init]) {
        self.device = device;
    }
    return self;
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

-(NSDictionary*)toJSON:(id)args
{
    NSDictionary *json = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.device.friendlyName, @"friendlyName",
                          self.device.ipAddress, @"ipAddress",
                          self.device.deviceID, @"deviceID",
                          self.device.manufacturer, @"manufacturer",
                          self.device.modelName, @"modelName",
                          self.device.statusText, @"statusText",
                          nil];
    return json;
}

@end