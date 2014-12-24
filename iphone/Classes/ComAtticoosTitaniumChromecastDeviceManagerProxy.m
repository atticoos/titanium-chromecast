//
//  ComAtticoosTitaniumChromecastDeviceManagerProxy.m
//  titanium-chromecast
//
//  Created by Atticus White on 12/20/14.
//
//

#import "ComAtticoosTitaniumChromecastDeviceManagerProxy.h"
#import "Device.h"

@implementation ComAtticoosTitaniumChromecastDeviceManagerProxy

-(instancetype)init
{
    if (self = [super init]) {
        self.deviceScanner = [[GCKDeviceScanner alloc] init];
        self.deviceManager = [[DeviceManager alloc] init];
    }
    return self;
}

-(void)startScanning:(id)args
{
    ENSURE_UI_THREAD_0_ARGS
    self.deviceManager.APPID = [self valueForUndefinedKey:@"app"];
    [self.deviceScanner addListener: self];
    [self.deviceScanner startScan];
}

-(void)stopScanning:(id)args
{
    [self.deviceScanner removeListener: self];
    [self.deviceScanner stopScan];
}

-(BOOL)isScanning:(id)args
{
    return [self.deviceScanner scanning];
}

-(BOOL)isConnected:(id)args
{
    return [self.deviceManager.manager isConnected];
}

-(BOOL)isConnectedToApp:(id)args
{
    return [self.deviceManager.manager isConnectedToApp];
}

-(NSString*)getConnectedAppSessionID:(id)args
{
    return [self.deviceManager.manager applicationSessionID];
}

-(NSString*)getConnectedAppStatusText:(id)args
{
    return [self.deviceManager.manager applicationStatusText];
}

-(BOOL)hasConnectedDevice:(id)args
{
    return self.deviceManager.device != nil;
}

-(Device*)getConnectedDevice:(id)args
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