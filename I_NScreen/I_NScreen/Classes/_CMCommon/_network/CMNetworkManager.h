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

// 프로그램 검색
- (NSURLSessionDataTask *)programScheduleListWithSearchString:(NSString *)searchString WithPageSize:(NSInteger)pageSize WithPageIndex:(NSInteger)pageIndex WithAreaCode:(NSString *)areaCode completion:(void (^)(NSArray *programs, NSError *error))block;

// 채널 검색
- (NSURLSessionDataTask *)epgSearchChannelListWithSearchString:(NSString *)searchString WithPageSize:(NSString *)pageSize WithPageIndex:(NSString *)pageIndex WithSortType:(NSString *)sortType block:(void (^)(NSArray *gets, NSError *error))block;

// vod 검색
- (NSURLSessionDataTask *)vodSerchListWithSearchString:(NSString *)searchString WithPageSize:(NSInteger)pageSize WithPageIndex:(NSInteger)pageIndex WithSortType:(NSString *)sortType completion:(void (^)(NSArray *gets, NSError *error))block;

// 검색어 목록
- (NSURLSessionDataTask *)searchWordListWithSearchString:(NSString*)searchString WithIncludeAdultCategory:(NSString *)adultCategory completion:(void (^)(NSArray *gets, NSError *error))block;

// 검색추가 ....
//http://192.168.40.5:8080/HApplicationServer/searchContentGroup.json?version=1&terminalKey=C5E6DBF75F13A2C1D5B2EFDB2BC940&searchKeyword=%EB%A7%89%EB%8F%BC%EB%A8%B9%EC%9D%80&contentGroupProfile=2
- (NSURLSessionDataTask *)searchContentGroupWithSearchKeyword:(NSString *)searchKeyword WithIncludeAdultCategory:(NSString *)includeAdultCategory completion:(void (^)(NSArray *gets, NSError *error))block;

@end

@interface CMNetworkManager (EPG)
- (NSURLSessionDataTask *)epgGetChannelListAreaCode:(NSString *)areaCode block:(void (^)(NSArray *gets, NSError *error))block;

- (NSURLSessionDataTask *)epgGetChannelListAreaCode:(NSString *)areaCode WithGenreCode:(NSString *)genreCode block:(void (^)(NSArray *gets, NSError *error))block;

- (NSURLSessionDataTask *)epgGetChannelGenreArecode:(NSString *)areaCode block:(void (^)(NSArray *gets, NSError *error))block;

- (NSURLSessionDataTask *)epgGetChannelAreaBlock:(void (^)(NSArray *gets, NSError *error))block;

- (NSURLSessionDataTask *)epgGetChannelScheduleChannelId:(NSString *)channelId WithAreaCode:(NSString *)areaCode block:(void (^)(NSArray *gets, NSError *error))block;

- (NSURLSessionDataTask *)epgSearchScheduleAreaCode:(NSString *)areaCode WithSearch:(NSString *)search block:(void (^)(NSArray *gets, NSError *error))block;

- (NSURLSessionDataTask *)epgSetRecordWithChannelId:(NSString *)channeId completion:(void (^)(NSArray *epgs, NSError *error))block;

- (NSURLSessionDataTask *)epgSetRecordStopWithChannelId:(NSString *)channeId completion:(void (^)(NSArray *epgs, NSError *error))block;

- (NSURLSessionDataTask *)epgSetRecordReserveWithChannelId:(NSString *)channeId WithStartTime:(NSString *)startTime completion:(void (^)(NSArray *epgs, NSError *error))block;

- (NSURLSessionDataTask *)epgSetRecordSeriesReserveWithChannelId:(NSString *)channeId WithStartTime:(NSString *)startTime WithSeriesId:(NSString *)seriesId completion:(void (^)(NSArray *epgs, NSError *error))block;

- (NSURLSessionDataTask *)epgSetRecordCancelReserveWithChannelId:(NSString *)channeId WithStartTime:(NSString *)startTime WithSeriesId:(NSString *)seriesId WithReserveCancel:(NSString *)reserveCancel completion:(void (^)(NSArray *epgs, NSError *error))block;

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

//http://58.141.255.79:8080/HApplicationServer/getCategoryTree.xml?version=1&terminalKey=D049DBBA897611A7F6B6454471B5B6&categoryProfile=1&categoryId=0&depth=2&traverseType=DFS
- (NSURLSessionDataTask *)vodGetCategoryTreeBlock:(void (^)(NSArray *vod, NSError *error))block;

// 댑스별 카테고리 id 추출 전문
// ex ) http://192.168.40.5:8080/HApplicationServer/getCategoryTree.xml?version=1&terminalKey=C5E6DBF75F13A2C1D5B2EFDB2BC940&transactionId=135&categoryProfile=4&categoryId=27282&depth=2&traverseType=DFS
- (NSURLSessionDataTask *)vodGetCategoryTreeWithCategoryId:(NSString *)categoryId WithDepth:(NSString *)depth block:(void (^)(NSArray *vod, NSError *error))block;

- (NSURLSessionDataTask *)vodRecommendAssetBySubscriberWithAssetProfile:(NSString *)assetProfile block:(void (^)(NSArray *vod, NSError *error))block;

// http://58.141.255.80/smapplicationserver/GetAppInitialize.asp?terminalKey=8A5D2E45D3874824FF23EC97F78D358&version=1
- (NSURLSessionDataTask *)vodGetAppInitializeCompletion:(void (^)(NSArray *pairing, NSError *error))block;

// 이벤트
- (NSURLSessionDataTask *)vodGetEventListCompletion:(void (^)(NSArray *pairing, NSError *error))block;

- (NSURLSessionDataTask *)vodGetSeriesAssetListWithSeriesId:(NSString *)seriesId WithCategoryId:(NSString *)categoryId WithAssetProfile:(NSString *)assetProfile completion:(void (^)(NSArray *vod, NSError *error))block;

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

// 페어링 셋탑쪽 삭제
- (NSURLSessionDataTask *)pairingRemoveUserCompletion:(void (^)(NSArray *pairing, NSError *error))block;


@end

@interface CMNetworkManager ( PVR )

// 녹화
// 녹화 목록 리스트
//http://192.168.44.10/SMApplicationserver/getrecordlist.asp?Version=1&terminalKey=9CED3A20FB6A4D7FF35D1AC965F988D2&deviceId=68590725-3b42-4cea-ab80-84c91c01bad2
- (NSURLSessionDataTask *)pvrGetrecordlistCompletion:(void (^)(NSArray *pvr, NSError *error))block;

// 시리즈 녹화물 목록
- (NSURLSessionDataTask *)pvrGetrecordListWithSeriesId:(NSString *)seriesId completion:(void (^)(NSArray *pvr, NSError *error))block;

// 예약 녹화 목록 리스트
//http://192.168.44.10/SMApplicationserver/getrecordReservelist.asp?Version=1&terminalKey=C5E6DBF75F13A2C1D5B2EFDB2BC940&deviceId=68590725-3b42-4cea-ab80-84c91c01bad2
- (NSURLSessionDataTask *)pvrGetrecordReservelistCompletion:(void (^)(NSArray *pvr, NSError *error))block;

@end

@interface CMNetworkManager ( DRM )

// ex) https://api.cablevod.co.kr/api/v1/mso/10/asset/www.hchoice.co.kr%7CM4151006LSG348552901/play
- (NSURLSessionDataTask *)drmApiWithAsset:(NSString *)asset WithPlayStyle:(NSString *)style completion:(void (^)(NSDictionary *drm, NSError *error))block;

@end

@interface CMNetworkManager ( REMOCON )
// http://192.168.44.10/SMApplicationserver/SetRemotePowerControl.asp?Version=1&terminalKey=9CED3A20FB6A4D7FF35D1AC965F988D2&deviceId=739d8470f604cfceb13784ab94fc368256253477&power=ON
- (NSURLSessionDataTask *)remoconSetRemotoePowerControlPower:(NSString *)power completion:(void (^)(NSArray *pvr, NSError *error))block;

// http://192.168.44.10/SMApplicationserver/SetRemoteVolumeControl.asp?Version=1&terminalKey=9CED3A20FB6A4D7FF35D1AC965F988D2&deviceId=739d8470f604cfceb13784ab94fc368256253477&volume=UP
- (NSURLSessionDataTask *)remoconSetRemoteVolumeControlVolume:(NSString *)volume completion:(void (^)(NSArray *pvr, NSError *error))block;

//http://58.141.255.80/smapplicationserver/GetSetTopStatus.asp?deviceId=8e855c79-1aa2-4d65-a230-cfebd4191165
// 셋탑 상태 체크 전원이나 ...
- (NSURLSessionDataTask *)remoconGetSetTopStatusCompletion:(void (^)(NSArray *pairing, NSError *error))block;

//http://192.168.44.10/SMApplicationServer/SetRemoteChannelControl.asp?deviceId=739d8470f604cfceb13784ab94fc368256253477&channelId=10
- (NSURLSessionDataTask *)remoconSetRemoteChannelControlWithChannelId:(NSString *)channelId completion:(void (^)(NSArray *pairing, NSError *error))block;

@end

@interface CMNetworkManager ( MyC_M )
//http://192.168.40.5:8080/HApplicationServer/getWishList.xml?version=1&terminalKey=C5E6DBF75F13A2C1D5B2EFDB2BC940&userId=68590725-3b42-4cea-ab80-84c91c01bad2
// 찜목록
- (NSURLSessionDataTask *)myCmGetWishListCompletion:(void (^)(NSArray *myCm, NSError *error))block;

//http://192.168.40.5:8080/HApplicationServer/getValidPurchaseLogList.xml?version=1&terminalKey=C5E6DBF75F13A2C1D5B2EFDB2BC940&purchaseLogProfile=1
// 구매목록
- (NSURLSessionDataTask *)myCmGetValidPurchaseLogListCompletion:(void (^)(NSArray *myCm, NSError *error))block;
@end

@interface CMNetworkManager ( Preference )
// 유료체널 리스트 정보
- (NSURLSessionDataTask *)preferenceGetServiceJoyNListCompletion:(void (^)(NSArray *preference, NSError *error))block;

// 특정 유료체널 상세 정보
- (NSURLSessionDataTask *)preferenceGetServiceJoyNInfoCode:(NSString*)code completion:(void (^)(NSArray *preference, NSError *error))block;

// 공지사항 리스트 및 상세 정보 ex)areaCode = 0 , productCode = 11
- (NSURLSessionDataTask *)preferenceGetServiceNoticeInfoCompletion:(void (^)(NSArray *preference, NSError *error))block;

//고객센터, 이용약관
- (NSURLSessionDataTask *)perferenceGetServiceguideInfoWithCode:(NSString*)code completion:(void (^)(NSArray *preference, NSError *error))block;

//버전정보
- (NSURLSessionDataTask *)perferenceGetAppVersionInfoCompletion:(void (^)(NSArray *preference, NSError *error))block;


@end

@interface CMNetworkManager ( Payment )
// 요청한 가입자에 대해 지원 가능한 결제 방식 // 도메인 id = CnM, HCN, Tbroad
- (NSURLSessionDataTask  *)paymentGetAvailablePaymentTypeWithDomainId:(NSString *)domainId completion:(void (^)(NSArray *preference, NSError *error))block;

// 포인트를 이용한 구매요청 RVOD,SVOD, Package 상품 타입에 대한 구매 지원
// assetId = RVOD 상품인 경우 필수 값, SVOD 나 PACKAGE 상품인 경우 옵션
// RVOD, SVOD, Package 상품 타입인 경우 <productId, goodId> 쌍으로 상품 id 를 표현하므로 goodId 값이 반드시 있어야 한다.
- (NSURLSessionDataTask *)paymentPurchaseByPointWithDomainId:(NSString *)domainId WithAssetId:(NSString *)assetId WithProductId:(NSString *)productId WithGoodId:(NSString *)goodId WithPrice:(NSString *)price WithCategoryId:(NSString *)categoryId completion:(void (^)(NSArray *preference, NSError *error))block;

- (NSURLSessionDataTask *)paymentPurchaseAssetEx2WithProductId:(NSString *)productId WithGoodId:(NSString *)goodId WithUiComponentDomain:(NSString *)uiComponentDomain WithUiComponentId:(NSString *)uiComponentId WithPrice:(NSString *)price completion:(void (^)(NSArray *preference, NSError *error))block;
@end

@interface CMNetworkManager ( WISH )
// 찜목록 가져오기
- (NSURLSessionDataTask *)wishGetWishListCompletion:(void (^)(NSArray *wish, NSError *error))block;

// 찜하기
- (NSURLSessionDataTask *)wishAddWishItemWithAssetId:(NSString *)assetId completion:(void (^)(NSArray *wish, NSError *error))block;

// 찜삭제하기
- (NSURLSessionDataTask *)wishRemoveWishWithAssetId:(NSString *)assetId completion:(void (^)(NSArray *wish, NSError *error))block;

@end
