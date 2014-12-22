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

@interface Device : TiProxy

@property(nonatomic, strong) GCKDevice* device;
@property(nonatomic, strong) id<DeviceManagerDelegate> deviceManager;


-(instancetype)initWithDevice:(GCKDevice*)device
   initWithDeviceManager:(id<DeviceManagerDelegate>)deviceManager;
-(id)friendlyName;
-(id)ipAddress;
-(id)deviceID;

-(NSDictionary*)toJSON:(id)args;
-(void)connect:(id)args;
-(void)launchApplication:(id)args;
-(void)addChannel:(id)args;
-(void)sendMessage:(id)args;




// PROXY CALLBACKS

// callback pointers
@property(nonatomic, strong) KrollCallback* onDeviceSuccessfullyConnectedCallback;
@property(nonatomic, strong) KrollCallback* onDeviceFailedToConnectCallback;
@property(nonatomic, strong) KrollCallback* onApplicationSuccesfullyLaunchedCallback;
@property(nonatomic, strong) KrollCallback* onApplicationFailedToLaunchCallback;

// callback interface
-(void)onDeviceSuccessfullyConnected;
-(void)onDeviceFailedToConnect:(NSError*)error;
-(void)onApplicationSuccessfullyLaunched;
-(void)onApplicationFailedToLaunch:(NSError*)error;


// EVENT TRIGGERS

-(void)onMessageReceived:(NSString*)message;

@end