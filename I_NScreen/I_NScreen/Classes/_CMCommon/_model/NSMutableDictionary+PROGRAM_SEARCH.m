//
//  NSMutableDictionary+PROGRAM_SEARCH.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 8. 31..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "NSMutableDictionary+PROGRAM_SEARCH.h"
#import "CMNetworkManager.h"

@implementation NSMutableDictionary (PROGRAM_SEARCH)

/*
 채널넘버   @"Channel_number"
 채널 번호. @"Channel_logo_img"
 채널 로고. @"Channel_Program_Title"
 프로그램명. @"Channel_Program_Time"
 시간.
*/
- (NSString*)channelNumber {
    return self[@"Channel_number"];
}

+ (NSURLSessionDataTask *)programListWithKeyword:(NSString*)keyword completion:(void (^)(NSArray *programs, NSError *error))block {
    return [[CMNetworkManager sharedInstance] searchProgram:keyword block:block];
}

@end
