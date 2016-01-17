//
//  CMAppManager.h
//  I_NScreen
//
//  Created by 조백근 on 2015. 8. 18..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, APP_REFRESH_TYPE) {
    APP_REFRESH_NONE,           //  refresh없음
    APP_REFRESH_HOME,           //  홈화면 refresh
    APP_REFRESH_VOD_DETAIL,     //  vod상세보기 화면으로 이동
    APP_REFRESH_ADULT_TAB       //  성인탭으로 이동
};

@interface CMAppManager : NSObject

@property (nonatomic, unsafe_unretained) BOOL isFirst;//앱 최초실행여부
@property (nonatomic, unsafe_unretained) BOOL isNetworkErrorAlertWorking;//네트워크 에러창이 떠있는지 여부 (SIAlertView+AFNetworking 카테고리 내부에서 핸들링)
@property (nonatomic, unsafe_unretained) BOOL onLeftMenu;
@property (nonatomic) APP_REFRESH_TYPE appRefreshType;
@property (nonatomic, strong) NSDictionary* appRefreshInfo;


+ (CMAppManager *)sharedInstance;

/**
 *  @brief  기본값 설정.
 */
- (void)defaultSetting;


/**
 공용 클래스 메서드 CMAppManager 에 만들면 되나요?
 */

/**
 * @brief 왼쪽 메뉴 open
 */
- (void)onLeftMenuListOpen:(id)control;

/**
 * @brief 왼쪽 메뉴 close
 */
- (void)onLeftMenuListClose:(id)control;


- (void)setInfoDataKey:(NSString *)key Value:(id)value;

- (void)removeInfoDataKey:(NSString *)key;

- (void)setBoolDataKey:(NSString *)key Value:(BOOL)value;

- (void)removeBoolDataKey:(NSString *)key;

- (id)getInfoData:(NSString *)key;

- (BOOL)getBoolData:(NSString *)key;

/**
 * @brief 앱 버전
 */
+ (NSString *)getAppShortVersion;
+ (NSString *)getAppBuildVersion;

/**
 * @brief 디바이스 체크
 */
- (NSString *)getDeviceCheck;

/**
 * @brief 숫자에 , 삽입
 */

- (NSString *)insertComma:(NSString *)data;

/**
 * @brief 숫자에 , 삭제
 */
- (NSString *)deleteComma:(NSString *)data;

- (NSString *)getTerminalKeyCheck;

/**
 * @brief uuid 생성
 */
- (NSString*) getUniqueUuid;

/**
 * @brief 배열 검색 
   @param 
   listArr 검색 배열
   searchStr 검색 string
   key 검색할 key
 */
- (NSMutableArray *)getSearchWithArr:(NSMutableArray *)listArr WithSearchStr:(NSString *)searchStr WithKey:(NSString *)key;

/**
 * @brief 트리 리스트 데이터 파싱
 @param
 data 트리 리스트
 categoryIdSearch 파싱할 트리 메뉴
 */
- (NSMutableDictionary *)getResponseTreeSplitWithData:(NSArray *)data WithCategoryIdSearch:(NSString *)categoryIdSearch;

/**
 * @brief 시간 splite ex) 2015-11-12 22:30:00 -> 22:30
 */
- (NSString *)getSplitTimeWithDateStr:(NSString *)sDate;

/**
 * @brief 날짜 splite ex) 2015-11-12 21:00:00 -> 11월12일
 */
- (NSString *)getSplitScrollWithDateStr:(NSString *)sDate;

/**
 *  @brief 날짜 splite ex) 2015-11-12 21:00:00 -> 2015.11.12
 */
- (NSString *)replaceDashToDot:(NSString *)sDate;

/**
 * @brief 날짜 splite ex) 0000-00-03 00:00:00 -> 몇일 남았는지 몇시간 남았는지
 */
- (NSString *)getSplitTermWithDateStr:(NSString *)sDate;

- (CGFloat)getProgressViewBufferWithStartTime:(NSString *)startTime WithEndTime:(NSString *)endTime;

/**
 * @brief 요일을 리턴한다
 */
- (NSString *)GetDayOfWeek:(NSString *)strDay;

/* @brief compareDate로부터 licenseDateString까지 남은 시간 (초)
 */
- (double)getLicenseRemainMinuteWithLicenseDate:(NSString*)licenseDateString compareDate:(NSDate*)compareDate;

/* 남은시간 구하기 
 */
- (NSString*)expiredDateStringWithPeriod:(NSString*)period purchased:(NSString*)purchased state:(NSString*)state;
- (NSNumber*)expiredDateIntervalWithPeriod:(NSString*)period purchased:(NSString*)purchased state:(NSString *)state;

/**
 * @brief 남은 시간 구하기 2015-11-10 23:59:59 -> 몇시간 남음
 */
- (NSString *)getLicenseEndDate:(NSString *)endDate;

/**
 * @brief 유니크 uuid keychain 등록
 */
- (void)setKeychainUniqueUuid;

/**
 * @brief 유니크 keychain uuid get
 */
- (NSString *)getKeychainUniqueUuid;

/**
 * @brief 유니크 구매 비밀번호 set
 */
- (void)setKeychainBuyPw:(NSString *)buyPw;

/**
 * @brief 유니크 구매비밀번호 get
 */
- (NSString *)getKeychainBuyPw;

/**
 * @brief 유니크 구매비밀번호 remove
 */
- (void)removeKeychainBuyPw;

/**
 * @brief 유니크 privateTerminalKey set
 */
- (void)setKeychainPrivateTerminalkey:(NSString *)terminalKey;

/**
 * @brief 유니크 privateTerminalKey get
 */
- (NSString *)getKeychainPrivateTerminalKey;

/**
 * @brief 유니크 privateTerminalKey remove
 */
- (void)removeKeychainPrivateTerminalKey;

/**
 * @brief 유니크 성인 인증 여부 체크 set
 */
- (void)setKeychainAdultCertification:(BOOL)isAdult;

/**
 * @brief 유니크 성인 인증 여부 체크 get
 */
- (BOOL)getKeychainAdultCertification;

/**
 * @brief 유니크 성인 인증 여부 체크 remove
 */
- (void)removeKeychainAdultCertification;

/**
 * @brief 유니크 성인 검색 제한 설정 set
 */
- (void)setKeychainAdultLimit:(BOOL)isAdult;

/**
 * @brief 유니크 성인 검색 제한 설정 get
 */
- (BOOL)getKeychainAdultLimit;

/**
 * @brief 유니크 성인 인증 여부 체크 remove
 */
- (void)removeKeychainAdultLimit;

/**
 * @brief 지역 설정 set
 */
- (void)setKeychainAreaCodeValue:(NSDictionary *)area;

/**
 * @brief 지역 설정 get
 */
- (NSDictionary *)getKeychainAreaCodeValue;

/**
 * @brief 지역 설정 remove
 */
- (void)removeKeychainAreaCodeValue;

-(NSString *)GetToday;

- (void)notiBuyListRegist:(NSDictionary *)dic WithSetRemove:(BOOL)isCheck;

/**
 *  전문에 resultCode 처리
 *
 *  @param code resultCode
 */
- (BOOL)checkSTBStateCode:(NSString*)code;

/**
 *  프로모션 이미지 생성
 *
 *  @param item 데이터
 *
 *  @return 프로모션 이미지
 */
- (UIImage*)makePromotionImage:(NSDictionary*)item;

/**
 *  성인인증 후, 이동할 탭 정보 저장
 *
 *  @param tag 이동할 탭의 태그
 */
- (void)setRefreshTabInfoWithTag:(NSInteger)tag;

/**
 *  성인인증 후, 이동할 vod상세보기 화면 정보 저장
 *
 *  @param assetId              assetId
 *  @param episodePeerExistence episodePeerExistence
 *  @param contentGroupId       contentGroupId
 *  @param delegate             delegate
 */
- (void)setRefreshVodInfoWithAssetId:(NSString*)assetId episodePeerExistence:(NSString*)episodePeerExistence contentGroupId:(NSString*)contentGroupId delegate:(id)delegate;

- (void)excuteRefreshState;

@end
