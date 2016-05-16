//
//  Device.h
//  titanium-chromecast
//
//  Created by Atticus White on 12/20/14.
//
//

#import "TiProxy.h"
#import "DeviceManagerDelegate.h"
#import <GoogleCast/GoogleCast.h>

@interface Device : TiProxy<GCKMediaControlChannelDelegate>

@property(nonatomic, strong) GCKDevice* device;
@property(nonatomic, strong) id<DeviceManagerDelegate> deviceManager;
@property(nonatomic) NSTimer *updateTimer;
@property(nonatomic) NSTimeInterval lastPosition;
@property(nonatomic, strong) GCKMediaControlChannel *mediaChannel;
@property(nonatomic, strong) NSNumber* playerState;

-(instancetype)initWithDevice:(GCKDevice*)device
   initWithDeviceManager:(id<DeviceManagerDelegate>)deviceManager;
-(id)friendlyName;
-(id)ipAddress;
-(id)deviceID;
-(id)statusText;

-(NSDictionary*)toJSON:(id)args;
-(void)connect:(id)args;
-(void)launchApplication:(id)args;
-(void)addChannel:(id)args;
-(void)removeChannel:(id)args;
-(void)sendMessage:(id)message;
-(void)sendJsonMessage:(id)message;
-(void)castVideo:(id)args;

-(BOOL)isConnected:(id)args;



// PROXY CALLBACKS

// callback pointers
@property(nonatomic, strong) KrollCallback* onDeviceSuccessfullyConnectedCallback;
@property(nonatomic, strong) KrollCallback* onDeviceFailedToConnectCallback;
@property(nonatomic, strong) KrollCallback* onApplicationSuccesfullyLaunchedCallback;
@property(nonatomic, strong) KrollCallback* onApplicationFailedToLaunchCallback;

// callback interface
-(void)onDeviceSuccessfullyConnected;
-(void)onDeviceFailedToConnect:(NSError*)error;
-(void)onApplicationSuccessfullyLaunched:(NSString*)sessionID launchedApplication:(BOOL)launchedApplication;
-(void)onApplicationFailedToLaunch:(NSError*)error;


// EVENT TRIGGERS

-(void)onMessageReceived:(NSString*)message;
-(void)onChannelDisconnect;

@end