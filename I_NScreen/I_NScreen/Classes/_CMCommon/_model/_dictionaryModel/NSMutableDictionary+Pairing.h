//
//  NSMutableDictionary+Pairing.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 26..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Pairing)

// 192.168.40.5:8080/HApplicationServer/addUser.json?version=1?terminalKey=9CED3A20FB6A4D7FF35D1AC965F988D2&userId=128738912649127482194&authCode=102030

// 페어링
// authCod = 셋탑 인증 코드
+ (NSURLSessionDataTask *)pairingAddUserWithAuthCode:(NSString *)authCode completion:(void (^)(NSArray *pairing, NSError *error))block;

// privte 터미널 키 획득
// 192.168.40.5:8080/HApplicationServer/authenticateDevice.json?version=1&secondDeviceId=6192378192479184
+ (NSURLSessionDataTask *)pairingAuthenticateDeviceCompletion:(void (^)(NSArray *pairing, NSError *error))block;

//http://192.168.44.10/SMApplicationServer/ClientSetTopBoxRegist.xml?version=1&deviceId=1234&authKey=1111

+ (NSURLSessionDataTask *)pairingClientSetTopBoxRegistWithAuthKey:(NSString *)authKey completion:(void (^)(NSArray *pairing, NSError *error))block;

@end
