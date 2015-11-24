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


/*!<
 금주의 신작 영화
 ex) 
 192.168.40.5:8080/HApplicationServer/getContentGroupList.xml?version=1&terminalKey=9CED3A20FB6A4D7FF35D1AC965F988D2&contentGroupProfile=2&categoryId=723049
 
 또는
 이달의 추천 영화
 ex) 
 192.168.40.5:8080/HApplicationServer/getContentGroupList.xml?version=1&terminalKey=9CED3A20FB6A4D7FF35D1AC965F988D2&contentGroupProfile=2&categoryId=713229
 */
+ (NSURLSessionDataTask *)vodGetContentGroupListWithContentGroupProfile:(NSString *)contentGroupProfile WithCategoryId:(NSString *)categoryId completion:(void (^)(NSArray *vod, NSError *error))block;


/*!<
 상세 페이지 ( 인기순위 top 20 은 이미지를 상세에서 받는다 )
 ex )
 192.168.40.5:8080/HApplicationServer/getAssetInfo.xml?version=1&terminalKey=9CED3A20FB6A4D7FF35D1AC965F988D2&assetId=www.hchoice.co.kr|M4151006LSG348552901&assetProfile=9
 */
+ (NSURLSessionDataTask *)vodGetAssetInfoWithAssetId:(NSString *)assetId WithAssetProfile:(NSString *)assetProfile completion:(void (^)(NSArray *vod, NSError *error))block;

/*!<
 연관 컨텐츠
 ex) 
 192.168.40.5:8080/HApplicationServer/recommendContentGroupByAssetId.xml?version=1&terminalKey=9CED3A20FB6A4D7FF35D1AC965F988D2&assetId=www.hchoice.co.kr|M4154270LSG347422301&contentGroupProfile=2
 */
+ (NSURLSessionDataTask *)vodRecommendContentGroupByAssetId:(NSString *)assetId WithContentGroupProfile:(NSString *)contentGroupProfile completion:(void (^)(NSArray *vod, NSError *error))block;

/*!<
 묶음상품
 ex)
 192.168.40.5:8080/HApplicationServer/getBundleProductList.xml?version=1&terminalKey=9CED3A20FB6A4D7FF35D1AC965F988D2&productProfile=1
 */
+ (NSURLSessionDataTask *)vodGetBundleProductListWithProductProfile:(NSString *)productProfile completion:(void (^)(NSArray *vod, NSError *error))block;


+ (NSURLSessionDataTask *)vodGetServicebannerlistCompletion:(void (^)(NSArray *banner, NSError *error))block;

+ (NSURLSessionDataTask *)vodGetCategoryTreeBlock:(void (^)(NSArray *vod, NSError *error))block;

/*!<
 ex) 
 192.168.40.5:8080/HApplicationServer/getCategoryTree.xml?version=1&terminalKey=C5E6DBF75F13A2C1D5B2EFDB2BC940&transactionId=135&categoryProfile=4&categoryId=27282&depth=2&traverseType=DFS
 */
+ (NSURLSessionDataTask *)vodGetCategoryTreeWithCategoryId:(NSString *)categoryId WithDepth:(NSString *)depth block:(void (^)(NSArray *vod, NSError *error))block;

/*!<

 가입자 기반의 추천 asset 리스트 get
 */
+ (NSURLSessionDataTask *)vodRecommendAssetBySubscriberWithAssetProfile:(NSString *)assetProfile block:(void (^)(NSArray *vod, NSError *error))block;

// http://58.141.255.80/smapplicationserver/GetAppInitialize.asp?terminalKey=8A5D2E45D3874824FF23EC97F78D358&version=1
+ (NSURLSessionDataTask *)vodGetAppInitializeCompletion:(void (^)(NSArray *pairing, NSError *error))block;

// 이벤트
+ (NSURLSessionDataTask *)vodGetEventListCompletion:(void (^)(NSArray *pairing, NSError *error))block;

// 베너
+ (NSURLSessionDataTask *)vodGetAssetListWithCategoryId:(NSString *)categoryId WithAssetProfile:(NSString *)assetProfile completion:(void (^)(NSArray *vod, NSError *error))block;

+ (NSURLSessionDataTask *)vodGetSeriesAssetListWithSeriesId:(NSString *)seriesId WithCategoryId:(NSString *)categoryId WithAssetProfile:(NSString *)assetProfile completion:(void (^)(NSArray *vod, NSError *error))block;


+ (NSURLSessionDataTask *)vodGetEpisodePeerListByContentGroupId:(NSString *)contentGroupId completion:(void (^)(NSArray *vodDetail, NSError *error))block;

+ (NSURLSessionDataTask *)vodGetAssetListByEpisodePeerId:(NSString *)episodePeerId completion:(void (^)(NSArray *vodDetail, NSError *error))block;

@end

