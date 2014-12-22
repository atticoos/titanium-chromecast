//
//  Channel.h
//  titanium-chromecast
//
//  Created by Atticus White on 12/22/14.
//
//

#import "DeviceManagerDelegate.h"
#import <GoogleCast/GoogleCast.h>

@interface Channel : GCKCastChannel
@property(nonatomic, strong) id<DeviceManagerDelegate> delegate;
-(instancetype) initWithDelegate:(id<DeviceManagerDelegate>)delegate initWithNamespace:(NSString*)nameSpace;
@end