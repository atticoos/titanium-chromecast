
//
//  DeviceManager.m
//  titanium-chromecast
//
//  Created by Atticus White on 12/20/14.
//
//

#import "DeviceManager.h"
#import "Device.h"
#import "TiUtils.h"

@implementation DeviceManager



-(instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

-(void)connect:(Device*)device
{
    NSLog(@"Device manager delegate connecting!");
    
    if (self.manager != nil) {
        [self.manager disconnect];
        [self.manager release];
    }
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    self.manager = [[GCKDeviceManager alloc] initWithDevice:device.device clientPackageName:[info objectForKey:@"CFBundleIdentifier"]];
    self.manager.delegate = self;
    [[GCKLogger sharedInstance] setDelegate:self];
    self.device = device;
    [self.manager connect];
}

-(void)logFromFunction:(const char *)function message:(NSString *)message {
    NSLog(@"[GCKLogger] %s %@", function, message);
}

-(void)launchApplication
{
    ENSURE_UI_THREAD_0_ARGS
    [self.manager launchApplication:self.APPID];
}

-(void)stopCasting
{
    ENSURE_UI_THREAD_0_ARGS
    [self.manager disconnect];
    [self.device.updateTimer invalidate];
    self.device = nil;
    [self removeMediaChannel];
    [self.manager release];
}

-(void)addChannel:(NSString*)nameSpace
{
    
    if ([self.manager isConnectedToApp]) {
        NSLog(@"ADDING CHANNEL");
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

-(NSNumber*)playerState
{
    if(self.manager.connectionState == GCKConnectionStateConnected &&
       self.manager.applicationConnectionState == GCKConnectionStateConnected &&
       self.mediaChannel && self.device)
    {
        return self.device.playerState;
    }
    else
    {
        return [NSNumber numberWithInt:0];
    }
}

// MEDIA CHANNELS
-(void)addMediaChannel
{
    NSLog(@"AddMediaChannel");
    self.mediaChannel = [[GCKMediaControlChannel alloc] init];
    self.mediaChannel.delegate = self.device;
    ENSURE_UI_THREAD_0_ARGS;
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
-(void)loadMedia:(GCKMediaInformation*)mediaInformation atPosition:(NSTimeInterval)position
{
//    ENSURE_UI_THREAD_0_ARGS
//    [self.manager joinApplication:self.APPID sessionID:self.sessID];
    NSLog(@"Load Media");
    if (self.mediaChannel == nil) {
        [self addMediaChannel];
    }
    
    [self.mediaChannel loadMedia:mediaInformation autoplay:TRUE playPosition:position];
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

-(void)onChannelDisconnect
{
    [self.device onChannelDisconnect];
}

-(BOOL)isDeviceEqualToConnectedDevice:(Device *)device
{
    return self.device == device;
}

-(NSNumber*)isConnectedToApp
{
    return self.manager.applicationConnectionState == GCKConnectionStateConnected;
}

-(void)pauseChannel
{
    ENSURE_UI_THREAD_0_ARGS
    if (self.mediaChannel.mediaStatus.playerState == GCKMediaPlayerStatePaused) {
        NSLog(@"Playing");
        [self.mediaChannel play];
    } else {
        NSLog(@"Pausing");
        [self.mediaChannel pause];
    }
    
}

-(void)changePlaybackPercent:(id)args
{
    ENSURE_UI_THREAD(changePlaybackPercent, args);
    CGFloat newPercentage = [TiUtils floatValue:[args objectAtIndex: 0]];
    newPercentage = MAX(MIN(1.0, newPercentage), 0.0);
    NSTimeInterval newTime = newPercentage * self.mediaChannel.mediaStatus.mediaInformation.streamDuration;
    if (newTime > 0 && [self.manager isConnectedToApp]) {
        NSNumber *value = [self.mediaChannel seekToTimeInterval:newTime];
    }
}

-(void)incrementPlaybackBy:(id)args
{
    CGFloat delta = [TiUtils floatValue:[args objectAtIndex: 0]];
    NSTimeInterval currentPosition = [self.mediaChannel approximateStreamPosition];

    NSTimeInterval newPosition = currentPosition + delta;
    
    if(newPosition > self.mediaChannel.mediaStatus.mediaInformation.streamDuration){
        newPosition = self.mediaChannel.mediaStatus.mediaInformation.streamDuration;
    }
    else if(newPosition < 0){
        newPosition = .01; //Don't actually set it to 0 because I think that can cause issues
    }
        
    [self.mediaChannel seekToTimeInterval:newPosition];
    
}

-(void)changeVolume:(id)args
{
    ENSURE_UI_THREAD(changeVolume, args);
    CGFloat volume = [TiUtils floatValue:[args objectAtIndex: 0]];
    NSLog(@"setting volume to %f", volume );
    [self.manager setVolume:volume];
}

-(NSTimeInterval)calcStreamPosition
{
    return [self.mediaChannel approximateStreamPosition];
}

-(NSTimeInterval)getStreamDuration
{
    return self.mediaChannel.mediaStatus.mediaInformation.streamDuration;
}

-(void)deviceManagerDidConnect:(GCKDeviceManager*) deviceManager
{
    NSLog(@"Device manager succesfully connected!!!");
    [self.device onDeviceSuccessfullyConnected];
}


-(void)deviceManager:(GCKDeviceManager *)deviceManager didConnectToCastApplication:(GCKApplicationMetadata *)applicationMetadata sessionID:(NSString *)sessionID launchedApplication:(BOOL)launchedApplication
{
    NSLog(@"Application launched with session ID %@!", sessionID);
    self.sessID = sessionID;
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

-(void)deviceManager:(GCKDeviceManager *)deviceManager didSuspendConnectionWithReason:(GCKConnectionSuspendReason)error
{
    NSLog(@"Suspended with reason");
}

-(void)deviceManager:(GCKDeviceManager *)deviceManager didDisconnectFromApplicationWithError:(NSError *)error
{
    NSLog(@"Disconnected from Application!");
}



@end