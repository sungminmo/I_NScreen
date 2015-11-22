//
//  CMDBDataManager.h
//  I_NScreen
//
//  Created by 조백근 on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMAreaInfo.h"
#import "CMFavorChannelInfo.h"
#import <Realm/Realm.h>

@interface CMDBDataManager : NSObject

+ (CMDBDataManager *)sharedInstance;

/**
 *  구매인증번호 조회
 *
 *  @return 구매인증번호 
 */
- (NSString*)purchaseAuthorizedNumber;

/**
 *  구매인증번호 저장
 *
 *  @param number 구매인증번호
 */
- (void)savePurchaseAuthorizedNumber:(NSString*)number;

/**
 *  지역코드 기본설정
 */
- (void)saveDefaultAeraCodeForce:(BOOL)isForce;

/**
 *  지역정보 저장
 *
 *  @param code 코드
 *  @param name 명칭
 */
- (void)saveAreaCode:(NSString*)code name:(NSString*)name;

/**
 *  지역정보 반환
 *
 *  @return 지역정보
 */
- (CMAreaInfo*)currentAreaInfo;

/**
 *  프라이빗 터미널 키 저장
 *
 *  @param terminalKey 프라이빗 터미널 키
 */
- (void)savePrivateTerminalKey:(NSString *)terminalKey;


/**
 *  프라이빗 터미널 키 반환
 *
 *  @return 프라이빗 터미널 키
 */
- (NSString *)getPrivateTerminalKey;

/**
 *  페어링 유무 체크 반환
 *
 *  @return 페어링 유무 체크
 */
- (BOOL)getPairingCheck;

/**
 *  페어링 유무 저장
 *
 *  @return 페어링 유무
 */
- (void)setPariringCheck:(BOOL)isParing;

/**
 *   프라이빗 터미널 키 삭제
 *
 *  @return  프라이빗 터미널 키 삭제
 */
- (void)removePrivateTerminalKey;

/**
 *  페어링 셋탑 종류 저장
 *
 *  @return 페어링 유무
 */
- (void)setSetTopBoxKind:(NSString *)kind;

/**
 *  페어링 셋탑 종류 체크
 *
 *  @return 페어링 유무
 */
- (NSString *)getSetTopBoxKind;

/**
 *  선호체널 데이터 저장
 */
- (void)setFavorChannel:(NSDictionary *)data;

/**
 *  @return 선호체널 데이터 호출
 */
- (RLMArray *)getFavorChannel;

/**
 *  선호체널 삭제
 */
- (void)removeFavorChannel:(int)index;

/**
 *  VOD 시청목록 데이터 저장
 */
- (void)setVodWatchList:(NSDictionary *)data;

/**
 *  @return vod 시청목록 데이터 호출
 */
- (RLMArray *)getVodWatchList;

/**
 *   vod 시청목록 삭제
 */
- (void)removeVodWatchList:(int)index;

/**
 *  시청예약 데이터 저장
 */
- (void)setWatchReserveList:(NSDictionary *)dic;

/**
 *  @return 시청예약 데이터 호출
 */
- (RLMArray *)getWatchReserveList;

/**
 *   시청예약 삭제
 */
- (void)removeWatchReserveList:(NSDictionary *)dic;
@end
