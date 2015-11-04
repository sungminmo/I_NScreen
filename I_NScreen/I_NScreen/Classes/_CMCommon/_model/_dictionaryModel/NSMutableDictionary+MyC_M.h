//
//  NSMutableDictionary+MyC_M.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 4..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (MyC_M)

//http://192.168.40.5:8080/HApplicationServer/getWishList.xml?version=1&terminalKey=C5E6DBF75F13A2C1D5B2EFDB2BC940&userId=68590725-3b42-4cea-ab80-84c91c01bad2
// 찜목록
+ (NSURLSessionDataTask *)myCmGetWishListCompletion:(void (^)(NSArray *myCm, NSError *error))block;


//http://192.168.40.5:8080/HApplicationServer/getValidPurchaseLogList.xml?version=1&terminalKey=C5E6DBF75F13A2C1D5B2EFDB2BC940&purchaseLogProfile=1
// 구매목록
+ (NSURLSessionDataTask *)myCmGetValidPurchaseLogListCompletion:(void (^)(NSArray *myCm, NSError *error))block;


@end
