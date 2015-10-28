//
//  CMNetworkManager.h
//  I_NScreen
//
//  Created by 조백근 on 2015. 8. 18..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface CMDRMServerClient : AFHTTPSessionManager
@end

@interface CMSMAppServerClient : AFHTTPSessionManager
@end

@interface CMSMAppServerClientVPN : AFHTTPSessionManager

@end

@interface CMWebHasServerClient : AFHTTPSessionManager
@end

@interface CMRUMPUSServerClient : AFHTTPSessionManager
@end

@interface CMRUMPUSServerClientVPN : AFHTTPSessionManager

@end

@interface CMAirCodeServerClient : AFHTTPSessionManager
@end

@interface CMNetworkManager : NSObject

@property (nonatomic, strong) CMDRMServerClient* drmClient;
@property (nonatomic, strong) CMSMAppServerClient* smClient;
@property (nonatomic, strong) CMSMAppServerClientVPN* smClientVpn;
@property (nonatomic, strong) CMWebHasServerClient* webClient;
@property (nonatomic, strong) CMRUMPUSServerClient* rumClient;
@property (nonatomic, strong) CMRUMPUSServerClientVPN* rumClientVpn;
@property (nonatomic, strong) CMAirCodeServerClient* acodeClient;

+ (CMNetworkManager *)sharedInstance;

@end


@interface CMNetworkManager(SEARCH)

- (NSURLSessionDataTask *)searchProgram:(NSString *)keyword block:(void (^)(NSArray *posts, NSError *error))block;

// 프로그램 검색
- (NSURLSessionDataTask *)programSearchListWithSearchString:(NSString *)searchString WithPageSize:(NSInteger)pageSize WithPageIndex:(NSInteger)pageIndex WithAreaCode:(NSString *)areaCode WithProductCode:(NSString *)productCode completion:(void (^)(NSArray *gets, NSError *error))block;

// 채널 검색
- (NSURLSessionDataTask *)epgSearchChannelListWithSearchString:(NSString *)searchString WithPageSize:(NSString *)pageSize WithPageIndex:(NSString *)pageIndex WithSortType:(NSString *)sortType block:(void (^)(NSArray *gets, NSError *error))block;

// vod 검색
- (NSURLSessionDataTask *)vodSerchListWithSearchString:(NSString *)searchString WithPageSize:(NSInteger)pageSize WithPageIndex:(NSInteger)pageIndex WithSortType:(NSString *)sortType completion:(void (^)(NSArray *gets, NSError *error))block;

// 검색어 목록
- (NSURLSessionDataTask *)searchWordListWithSearchString:(NSString*)searchString completion:(void (^)(NSArray *gets, NSError *error))block;

@end

@interface CMNetworkManager (EPG)

- (NSURLSessionDataTask *)epgGetChannelListAreaCode:(NSString *)areaCode WithGenreCode:(NSString *)genreCode block:(void (^)(NSArray *gets, NSError *error))block;

- (NSURLSessionDataTask *)epgGetChannelGenreBlock:(void (^)(NSArray *gets, NSError *error))block;

- (NSURLSessionDataTask *)epgGetChannelAreaBlock:(void (^)(NSArray *gets, NSError *error))block;

- (NSURLSessionDataTask *)epgGetChannelScheduleChannelId:(NSString *)channelId block:(void (^)(NSArray *gets, NSError *error))block;

- (NSURLSessionDataTask *)epgSearchScheduleAreaCode:(NSString *)areaCode WithSearch:(NSString *)search block:(void (^)(NSArray *gets, NSError *error))block;

- (NSURLSessionDataTask *)epgSetRecordWithChannelId:(NSString *)channeId completion:(void (^)(NSArray *epgs, NSError *error))block;

@end

@interface CMNetworkManager (VOD)

// 인기순위 Top20
- (NSURLSessionDataTask *)vodGetPopularityChartWithCategoryId:(NSString *)categoryId WithRequestItems:(NSString *)requestItems block:(void (^)(NSArray *gets, NSError *error))block;

// 상세 페이지 ( 인기순위 top 20 은 이미지를 상세에서 받는다 )
- (NSURLSessionDataTask *)vodGetAssetInfoWithAssetId:(NSString *)assetId WithAssetProfile:(NSString *)assetProfile block:(void (^)(NSArray *gets, NSError *error))block;

// 금주의 신작영화
- (NSURLSessionDataTask *)vodGetContentGroupListWithContentGroupProfile:(NSString *)contentGroupProfile WithCategoryId:(NSString *)categoryId block:(void (^)(NSArray *gets, NSError *error))block;

// 연관 컨텐츠
- (NSURLSessionDataTask *)vodRecommendContentGroupByAssetId:(NSString *)assetId WithContentGroupProfile:(NSString *)contentGroupProfile block:(void (^)(NSArray *gets, NSError *error))block;

// 묶음 상품
- (NSURLSessionDataTask *)vodGetBundleProductListWithProductProfile:(NSString *)productProfile block:(void (^)(NSArray *gets, NSError *error))block;

// 배너
- (NSURLSessionDataTask *)vodGetServicebannerlistBlock:(void(^)(NSArray *vod, NSError *error))block;

@end

@interface CMNetworkManager ( PAIRING )

// 페어링
// authCod = 셋탑 인증 코드
// 192.168.40.5:8080/HApplicationServer/addUser.json?version=1?terminalKey=9CED3A20FB6A4D7FF35D1AC965F988D2&userId=128738912649127482194&authCode=102030
- (NSURLSessionDataTask *)pairingAddUserWithAuthCode:(NSString *)authCode completion:(void (^)(NSArray *pairing, NSError *error))block;

// privte 터미널 키 획득
// 192.168.40.5:8080/HApplicationServer/authenticateDevice.json?version=1&secondDeviceId=6192378192479184
- (NSURLSessionDataTask *)pairingAuthenticateDeviceCompletion:(void (^)(NSArray *pairing, NSError *error))block;

- (NSURLSessionDataTask *)pairingClientSetTopBoxRegistWithAuthKey:(NSString *)authKey completion:(void (^)(NSArray *pairing, NSError *error))block;

@end

@interface CMNetworkManager ( PVR )

// 녹화
// 녹화 목록 리스트
// ext) 192.168.44.10/SMApplicationserver/dev.getrecordlist.asp?Version=1&terminalKey=9CED3A20FB6A4D7FF35D1AC965F988D2&deviceId=739d8470f604cfceb13784ab94fc368256253477
- (NSURLSessionDataTask *)pvrGetrecordlistCompletion:(void (^)(NSArray *pvr, NSError *error))block;

// 예약 녹화 목록 리스트
// ex)192.168.44.10/SMApplicationserver/dev.getrecordReservelist.asp?Version=1&terminalKey=9CED3A20FB6A4D7FF35D1AC965F988D2&deviceId=739d8470f604cfceb13784ab94fc368256253477
- (NSURLSessionDataTask *)pvrGetrecordReservelistCompletion:(void (^)(NSArray *pvr, NSError *error))block;

@end