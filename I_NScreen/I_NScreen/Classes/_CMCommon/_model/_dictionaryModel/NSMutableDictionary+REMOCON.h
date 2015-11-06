//
//  NSMutableDictionary+REMOCON.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 4..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (REMOCON)

// http://192.168.44.10/SMApplicationserver/SetRemotePowerControl.asp?Version=1&terminalKey=9CED3A20FB6A4D7FF35D1AC965F988D2&deviceId=739d8470f604cfceb13784ab94fc368256253477&power=ON
+ (NSURLSessionDataTask *)remoconSetRemotoePowerControlPower:(NSString *)power completion:(void (^)(NSArray *pvr, NSError *error))block;

// http://192.168.44.10/SMApplicationserver/SetRemoteVolumeControl.asp?Version=1&terminalKey=9CED3A20FB6A4D7FF35D1AC965F988D2&deviceId=739d8470f604cfceb13784ab94fc368256253477&volume=UP
+ (NSURLSessionDataTask *)remoconSetRemoteVolumeControlVolume:(NSString *)volume completion:(void (^)(NSArray *pvr, NSError *error))block;

+ (NSURLSessionDataTask *)remoconGetSetTopStatusCompletion:(void (^)(NSArray *pairing, NSError *error))block;

+ (NSURLSessionDataTask *)remoconSetRemoteChannelControlWithChannelId:(NSString *)channelId completion:(void (^)(NSArray *pairing, NSError *error))block;

@end
