//
//  NSMutableDictionary+REMOCON.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 4..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "NSMutableDictionary+REMOCON.h"

@implementation NSMutableDictionary (REMOCON)

// http://192.168.44.10/SMApplicationserver/SetRemotePowerControl.asp?Version=1&terminalKey=9CED3A20FB6A4D7FF35D1AC965F988D2&deviceId=739d8470f604cfceb13784ab94fc368256253477&power=ON
+ (NSURLSessionDataTask *)remoconSetRemotoePowerControlPower:(NSString *)power completion:(void (^)(NSArray *pvr, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] remoconSetRemotoePowerControlPower:power completion:block];
}

// http://192.168.44.10/SMApplicationserver/SetRemoteVolumeControl.asp?Version=1&terminalKey=9CED3A20FB6A4D7FF35D1AC965F988D2&deviceId=739d8470f604cfceb13784ab94fc368256253477&volume=UP
+ (NSURLSessionDataTask *)remoconSetRemoteVolumeControlVolume:(NSString *)volume completion:(void (^)(NSArray *pvr, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] remoconSetRemoteVolumeControlVolume:volume completion:block];
}

+ (NSURLSessionDataTask *)remoconGetSetTopStatusCompletion:(void (^)(NSArray *pairing, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] remoconGetSetTopStatusCompletion:block];
}

@end
