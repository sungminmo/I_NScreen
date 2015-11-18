//
//  CMAppManager.h
//  I_NScreen
//
//  Created by 조백근 on 2015. 8. 18..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CMAppManager : NSObject

@property (nonatomic, unsafe_unretained) BOOL isFirst;//앱 최초실행여부 

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
- (NSString *)getAppVersion;

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
 * @brief 날짜 splite ex) 0000-00-03 00:00:00 -> 몇일 남았는지 몇시간 남았는지
 */
- (NSString *)getSplitTermWithDateStr:(NSString *)sDate;

- (CGFloat)getProgressViewBufferWithStartTime:(NSString *)startTime WithEndTime:(NSString *)endTime;

/**
 * @brief 요일을 리턴한다
 */
- (NSString *)GetDayOfWeek:(NSString *)strDay;

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

@end
