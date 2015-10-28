//
//  NSMutableDictionary+Pairing.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 26..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "NSMutableDictionary+Pairing.h"

@implementation NSMutableDictionary (Pairing)

+ (NSURLSessionDataTask *)pairingAddUserWithAuthCode:(NSString *)authCode completion:(void (^)(NSArray *pairing, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] pairingAddUserWithAuthCode:authCode completion:block];
}

// 조회성 데이터 호출시 202(Invalid terminalKey) 에러면 다시 터미널 키를 요청한다.
+ (NSURLSessionDataTask *)pairingAuthenticateDeviceCompletion:(void (^)(NSArray *pairing, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] pairingAuthenticateDeviceCompletion:block];
}

+ (NSURLSessionDataTask *)pairingClientSetTopBoxRegistWithAuthKey:(NSString *)authKey completion:(void (^)(NSArray *pairing, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] pairingClientSetTopBoxRegistWithAuthKey:authKey completion:block];
}

@end
