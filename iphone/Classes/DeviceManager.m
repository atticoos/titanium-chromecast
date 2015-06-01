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
    [self.manager launchApplication:self.APPID];
}

-(void)addChannel:(NSString*)nameSpace
{
    if ([self.manager isConnectedToApp]) {
        self.channel = [[Channel alloc] initWithDelegate:self initWithNamespace:[NSString stringWithFormat:@"urn:x-cast:%@", nameSpace]];
        [self.manager addChannel:self.channel];
    }
}

-(void)removeChannel
{
    if (self.channel != nil) {
        [self.manager removeChannel:self.channel];
        self.channel = nil;
    }
}

// MEDIA CHANNELS
-(void)addMediaChannel
{
    self.mediaChannel = [[GCKMediaControlChannel alloc] init];
    self.mediaChannel.delegate = self;
    [self.manager addChannel: self.mediaChannel];
//    [self.mediaChannel requestStatus];
}
-(void)removeMediaChannel
{
    if (self.mediaChannel != nil) {
        [self.manager removeChannel: self.mediaChannel];
        self.mediaChannel = nil;
    }
}
-(void)loadMedia:(GCKMediaInformation*)mediaInformation
{
    if (self.mediaChannel == nil) {
        [self addMediaChannel];
    }
    [self.mediaChannel loadMedia:mediaInformation autoplay:TRUE playPosition:0];
    NSLog(@"Initiated requst to media channel");
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

-(BOOL)isDeviceEqualToConnectedDevice:(Device *)device
{
    return self.device == device;
}

-(BOOL)isConnectedToApp
{
    return [self.manager isConnectedToApp];
}

-(void)deviceDisconnected {
    if (self.manager != nil) {
        [self.manager disconnect];
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
    [self.device onApplicationSuccessfullyLaunched:sessionID launchedApplication:launchedApplication];
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

// GCKMediaControlChannelDelegate public members
-(void)mediaControlChannel:(GCKMediaControlChannel*)mediaControlChannel didCompleteLoadWithSessionID:(NSInteger)sessionID
{
    NSLog(@"Media control channel did complete load ith session id");
}

-(void)mediaControlChannel:(GCKMediaControlChannel *)mediaControlChannel didFailToLoadMediaWithError:(NSError *)error
{
    NSLog(@"Media control channel FAILED to load with error");
    NSLog(@"Error: %@ %@", error, [error userInfo]);
}

-(void)mediaControlChannel:(GCKMediaControlChannel *)mediaControlChannel requestDidFailWithID:(NSInteger)requestID error:(NSError *)error
{
    NSLog(@"Media control channel FAILED to load with ID");
    NSLog(@"Error: %@ %@", error, [error userInfo]);
}



@end