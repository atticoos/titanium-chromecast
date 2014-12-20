//
//  Device.h
//  titanium-chromecast
//
//  Created by Atticus White on 12/20/14.
//
//

#import "TiProxy.h"
#import <GoogleCast/GoogleCast.h>

@interface Device : TiProxy
@property(nonatomic, strong) GCKDevice* device;

-(instancetype)initWithDevice:(GCKDevice*)device;

-(id)friendlyName;
-(id)ipAddress;
-(id)deviceID;

@end