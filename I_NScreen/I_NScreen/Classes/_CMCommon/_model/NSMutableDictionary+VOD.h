//
//  NSMutableDictionary+VOD.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 14..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (VOD)

//http://192.168.40.5:8080/HApplicationServer/getPopularityChart.xml?version=1&terminalKey=9CED3A20FB6A4D7FF35D1AC965F988D2&categoryId=713230&requestItems=all

/*!<
 param :
 version
 terminalKey
 categoryId
 requestItems
 */
// 인기순위 top20
+ (NSURLSessionDataTask *)vodGetPopularityChartWithCategoryId:(NSString *)categoryId
                               WithRequestItems:(NSString *)requestItems
                                     completion:(void (^)(NSArray *vod, NSError *error))block;



+ (NSURLSessionDataTask *)vodGetContentGroupListWithContentGroupProfile:(NSString *)contentGroupProfile WithPageIndex:(NSString *)pageIndex WithCategoryId:(NSString *)categoryId WithSortType:(NSString *)sortType WithPageSize:(NSString *)pageSize WithTransactionId:(NSString *)transactionId WithIndexRotaion:(NSString *)indexRotaion completion:(void (^)(NSArray *vod, NSError *error))block;


@end
