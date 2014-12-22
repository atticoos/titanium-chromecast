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
    NSUInteger argC = [args count];
    
    if (argC > 0) {
        ENSURE_TYPE([args objectAtIndex:0], KrollCallback);
        self.onDeviceSuccessfullyConnectedCallback = [args objectAtIndex: 0];
    }
    if (argC > 1) {
        ENSURE_TYPE([args objectAtIndex: 1], KrollCallback);
        self.onDeviceFailedToConnectCallback = [args objectAtIndex: 1];
    }
    [self.deviceManager connect:self];
}

-(void)launchApplication:(id)args
{
    NSUInteger argC = [args count];
    if (argC > 0) {
        ENSURE_TYPE([args objectAtIndex:0], KrollCallback);
        self.onApplicationSuccesfullyLaunchedCallback = [args objectAtIndex: 0];
    }
    if (argC > 1) {
        ENSURE_TYPE([args objectAtIndex:1], KrollCallback);
        self.onApplicationFailedToLaunchCallback = [args objectAtIndex: 1];
    }
    [self.deviceManager launchApplication];
}

-(void)addChannel:(id)channelNamespace
{
    ENSURE_SINGLE_ARG(channelNamespace, NSString);
    NSLog(@"Attemping to connect to %@", channelNamespace);
    [self.deviceManager addChannel:channelNamespace];
}

-(void)sendMessage:(id)args
{
    NSLog(@"Attemping to send message from device");
    [self.deviceManager sendMessage:@"Hello World!!!"];
}

-(void)onMessageReceived:(NSString*)message
{
    NSDictionary *messageDictionary = [NSDictionary dictionaryWithObjectsAndKeys: message, @"message", nil];
    [self fireEvent:@"messageReceived" withObject:messageDictionary];
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
        [self.onApplicationFailedToLaunchCallback call:@[[error localizedDescription]] thisObject:self];
    }
}


@end