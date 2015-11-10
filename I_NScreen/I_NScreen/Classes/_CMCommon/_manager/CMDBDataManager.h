//
//  CMDBDataManager.h
//  I_NScreen
//
//  Created by 조백근 on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMAreaInfo.h"


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

@end
