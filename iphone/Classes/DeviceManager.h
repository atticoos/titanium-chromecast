//
//  DeviceManager.h
//  titanium-chromecast
//
//  Created by Atticus White on 12/20/14.
//
//

#import <GoogleCast/GoogleCast.h>
#import "Channel.h"
#import "Device.h"
#import "DeviceManagerDelegate.h"

@interface DeviceManager : NSObject<GCKDeviceManagerDelegate, DeviceManagerDelegate, GCKMediaControlChannelDelegate, GCKLoggerDelegate>

@property(nonatomic, strong) Device* device;
@property(nonatomic, strong) NSString* APPID;
@property(nonatomic, strong) GCKDeviceManager* manager;
@property(nonatomic, strong) Channel *channel;
@property(nonatomic, strong) GCKMediaControlChannel *mediaChannel;
@property(nonatomic, strong) NSString *sessID;

-(void)pauseChannel;
-(void)changeVolume:(id)args;
-(void)changePlaybackPercent:(id)args;
-(void)stopCasting;
-(NSNumber*)playerState;
-(NSTimeInterval)calcStreamPosition;
-(NSTimeInterval)getStreamDuration;
@end