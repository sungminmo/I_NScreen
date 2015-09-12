//
//  NSMutableDictionary+PROGRAM_SEARCH.h
//  I_NScreen
//
//  Created by 조백근 on 2015. 8. 31..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (PROGRAM_SEARCH)


/*
 1. 아래와 같이 호출하고 데이타가 콜백되면 결과를 처리한다.
 
 2. 데이타는 필요하면 
 
 NSURLSessionTask *task = [Post programListWithKeyword:@"" completion:^(NSArray *list, NSError *error) {
     if (!error) {
     self.results = list;
     [self.tableView reloadData];
     }
 }];
// [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
// [self.refreshControl setRefreshingWithStateOfTask:task];
 */
+ (NSURLSessionDataTask *)programListWithKeyword:(NSString*)keyword completion:(void (^)(NSArray *programs, NSError *error))block;

@end
