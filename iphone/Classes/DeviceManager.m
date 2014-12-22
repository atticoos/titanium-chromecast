//
//  DeviceManager.m
//  titanium-chromecast
//
//  Created by Atticus White on 12/20/14.
//
//

#import "DeviceManager.h"
#import "Device.h"

@implementation DeviceManager

-(instancetype)init
{
    if (self = [super init]) {

    }
    return self;
}

-(void)connect:(Device*)device
{
    NSLog(@"Device manager delgate connecting!");
    
    if (self.manager != nil) {
        [self.manager disconnect];
        [self.manager release];
    }
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    self.manager = [[GCKDeviceManager alloc] initWithDevice:device.device clientPackageName:[info objectForKey:@"CFBundleIdentifier"]];
    self.manager.delegate = self;
    self.device = device;
    [self.manager connect];
}

-(void)launchApplication
{
    [self.manager launchApplication:@"794B7BBF"];
}

-(void)addChannel:(NSString*)nameSpace
{
    if ([self.manager isConnectedToApp]) {
        self.channel = [[Channel alloc] initWithDelegate:self initWithNamespace:[NSString stringWithFormat:@"urn:x-cast:%@", nameSpace]];
        [self.manager addChannel:self.channel];
    }
}

// channel - send message, forward message to channel
-(void)sendMessage:(NSString*)message
{
    if (self.channel != nil) {
        [self.channel sendTextMessage:message];
    }
}

// channel - message received, forward back to proxy
-(void)onChannelMessage:(NSString*)message
{
    [self.device onMessageReceived:message];
}

-(void)deviceDisconnected {
    if (self.manager != nil) {
        [self.manager disconnect];
        [self.manager release];
    }
    self.manager = nil;
    self.channel = nil;
    self.device = nil;
}

-(void)deviceManagerDidConnect:(GCKDeviceManager*) deviceManager
{
    NSLog(@"Device manager succesfully connected!!!");
    [self.device onDeviceSuccessfullyConnected];
}


-(void)deviceManager:(GCKDeviceManager *)deviceManager didConnectToCastApplication:(GCKApplicationMetadata *)applicationMetadata sessionID:(NSString *)sessionID launchedApplication:(BOOL)launchedApplication
{
    NSLog(@"Application launched!");
    [self.device onApplicationSuccessfullyLaunched];
}

-(void)deviceManager:(GCKDeviceManager *)deviceManager didFailToConnectToApplicationWithError:(NSError *)error
{
    NSLog(@"application failed to launch");
    [self.device onApplicationFailedToLaunch:error];
}


-(void)deviceManager:(GCKDeviceManager *)deviceManager didFailToConnectWithError:(NSError *)error
{
    NSLog(@"Failed to connect!");
    [self.device onDeviceFailedToConnect:error];
}

-(void)deviceManager:(GCKDeviceManager *)deviceManager didDisconnectWithError:(NSError *)error
{
    NSLog(@"Disconnected with error!");
}

@end