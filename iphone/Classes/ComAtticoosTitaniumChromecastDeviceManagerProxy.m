//
//  ComAtticoosTitaniumChromecastDeviceManagerProxy.m
//  titanium-chromecast
//
//  Created by Atticus White on 12/20/14.
//
//

#import "ComAtticoosTitaniumChromecastDeviceManagerProxy.h"
#import "Device.h"
#import "TiUtils.h"

@implementation ComAtticoosTitaniumChromecastDeviceManagerProxy

-(instancetype)init
{
    if (self = [super init]) {
        self.deviceManager = [[DeviceManager alloc] init];
        
//        GCKFilterCriteria * filterCriteria =
//        [GCKFilterCriteria criteriaForAvailableApplicationWithID:self.deviceManager.APPID];
        
        //init is DEPRECATED, but initWithFilterCriteria throws unrecognized selector error, weird
        self.deviceScanner = [[GCKDeviceScanner alloc] init];
    }
    
    return self;
}

-(void)startScanning:(id)args
{
    ENSURE_UI_THREAD(startScanning, args);
    NSString *key = [self valueForUndefinedKey:@"app"];
    self.deviceManager.APPID = key;
    [self.deviceScanner addListener: self];
    [self.deviceScanner startScan];
}

-(void)stopScanning:(id)args
{
    ENSURE_UI_THREAD_0_ARGS
    [self.deviceScanner removeListener: self];
    [self.deviceScanner stopScan];
}

-(BOOL)isScanning:(id)args
{
    ENSURE_UI_THREAD_0_ARGS
    return [self.deviceScanner scanning];
}

-(NSNumber*)isConnected:(id)args
{
    ENSURE_UI_THREAD_0_ARGS
    return NUMBOOL(self.deviceManager.manager.connectionState == GCKConnectionStateConnected);
}

-(NSNumber*)isConnectedToApp:(id)args
{
     ENSURE_UI_THREAD_0_ARGS
    return NUMBOOL([self.deviceManager.manager isConnectedToApp]);
}

-(NSString*)getConnectedAppSessionID:(id)args
{
    ENSURE_UI_THREAD_0_ARGS
    return [self.deviceManager.manager applicationSessionID];
}

-(NSString*)connectedAppStatusText:(id)args
{
     ENSURE_UI_THREAD_0_ARGS
    NSString *statusText = [self.deviceManager.manager applicationStatusText];
    return statusText;
}

-(NSNumber*)hasConnectedDevice:(id)args
{
    return NUMBOOL(self.deviceManager.device != nil);
}

-(NSNumber*)playerState:(id)args
{
    return [self.deviceManager playerState];
}

-(void)pauseChannel:(id)args
{
    [self.deviceManager pauseChannel];
}

-(void)changePlaybackPercent:(id)args
{
    [self.deviceManager changePlaybackPercent:args];
}

-(void)incrementPlaybackBy:(id)args
{
    [self.deviceManager incrementPlaybackBy:args];
}

-(void)changeVolume:(id)args
{
    [self.deviceManager changeVolume:args];
}

-(void)disconnect:(id)args
{
    [self.deviceManager stopCasting];
}

-(Device*)connectedDevice:(id)args
{
    return self.deviceManager.device;
}

-(NSArray*)getDiscoveredDevices:(id)args
{
    NSArray *devices = self.deviceScanner.devices;
    NSMutableArray *seralizedDevices = [[NSMutableArray alloc] initWithCapacity: [devices count]];
    
    for (int i = 0; i < [devices count]; i++) {
        GCKDevice* currentDevice = [devices objectAtIndex: i];
        [seralizedDevices addObject: [[Device alloc] initWithDevice:currentDevice initWithDeviceManager: self.deviceManager]];
    }
    
    NSArray *finalArray = [NSArray arrayWithArray:seralizedDevices];
    return finalArray;
}


#pragma mark Events
-(void)deviceDidComeOnline:(GCKDevice *)device
{
    NSLog(@"Device came online %@", device.friendlyName);
    Device *deviceProxy = [[Device alloc] initWithDevice:device initWithDeviceManager: self.deviceManager];
    NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:deviceProxy, @"device", nil];
    
    [self fireEvent:@"deviceOnline" withObject: event];
}

-(void)deviceDidGoOffline:(GCKDevice *)device
{
    NSLog(@"Device went offline %@", device.friendlyName);
    Device *deviceProxy = [[Device alloc] initWithDevice:device initWithDeviceManager: self.deviceManager];
    NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:deviceProxy, @"device", nil];
    [self fireEvent:@"deviceOffline" withObject: event];
}


@end