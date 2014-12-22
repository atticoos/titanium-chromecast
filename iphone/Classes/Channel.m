//
//  Channel.m
//  titanium-chromecast
//
//  Created by Atticus White on 12/22/14.
//
//

#import "Channel.h"

@implementation Channel

-(instancetype)initWithDelegate:(id<DeviceManagerDelegate>)delegate initWithNamespace:(NSString*)nameSpace
{
    if (self = [super initWithNamespace:nameSpace]) {
        self.delegate = delegate;
    }
    return self;
}

-(void)didReceiveTextMessage:(NSString *)message
{
    [self.delegate onChannelMessage:message];
}

@end