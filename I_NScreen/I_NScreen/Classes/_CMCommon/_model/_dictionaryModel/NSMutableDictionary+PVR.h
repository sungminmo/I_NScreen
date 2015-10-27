//
//  NSMutableDictionary+PVR.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 27..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (PVR)

// 녹화
// 녹화 목록 리스트
// ext) 192.168.44.10/SMApplicationserver/dev.getrecordlist.asp?Version=1&terminalKey=9CED3A20FB6A4D7FF35D1AC965F988D2&deviceId=739d8470f604cfceb13784ab94fc368256253477
+ (NSURLSessionDataTask *)pvrGetrecordlistCompletion:(void (^)(NSArray *pvr, NSError *error))block;

// 예약 녹화 목록 리스트
// ex)192.168.44.10/SMApplicationserver/dev.getrecordReservelist.asp?Version=1&terminalKey=9CED3A20FB6A4D7FF35D1AC965F988D2&deviceId=739d8470f604cfceb13784ab94fc368256253477
+ (NSURLSessionDataTask *)pvrGetrecordReservelistCompletion:(void (^)(NSArray *pvr, NSError *error))block;

@end
