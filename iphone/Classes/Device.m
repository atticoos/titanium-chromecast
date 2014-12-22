//
//  Device.m
//  titanium-chromecast
//
//  Created by Atticus White on 12/20/14.
//
//

#import "Device.h"
@implementation Device

-(instancetype)initWithDevice:(GCKDevice*)device initWithDeviceManager:(id<DeviceManagerDelegate>)deviceManager
{
    if (self = [super init]) {
        self.device = device;
        self.deviceManager = deviceManager;
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
    NSLog(@"Going to json");
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

-(void)connect:(id)args
{
    ENSURE_UI_THREAD(connect, args);
    self.onDeviceSuccessfullyConnectedCallback = [args objectAtIndex: 0];
    [self.deviceManager connect:self];
}

-(void)launchApplication:(id)args
{
    self.onApplicationSuccesfullyLaunchedCallback = [args objectAtIndex: 0];
    [self.deviceManager launchApplication];
}



#pragma mark Callbacks
-(void)onDeviceSuccessfullyConnected
{
    NSLog(@"Device has been pinged of the succesful connection!");
    if (self.onDeviceSuccessfullyConnectedCallback != nil) {
        [self.onDeviceSuccessfullyConnectedCallback call:@[@"Hello World"] thisObject: self];
    }
}

-(void)onDeviceFailedToConnect:(NSError*)error
{
    if (self.onDeviceFailedToConnectCallback != nil) {
        [self.onDeviceFailedToConnectCallback call:@[] thisObject:self];
    }
}

-(void)onApplicationSuccessfullyLaunched
{
    if (self.onApplicationSuccesfullyLaunchedCallback != nil) {
        [self.onApplicationSuccesfullyLaunchedCallback call:@[@"Hello World"] thisObject:self];
    }
}

-(void)onApplicationFailedToLaunch:(NSError*)error
{
    if (self.onApplicationFailedToLaunchCallback != nil) {
        [self.onApplicationFailedToLaunchCallback call:@[] thisObject:self];
    }
}


@end