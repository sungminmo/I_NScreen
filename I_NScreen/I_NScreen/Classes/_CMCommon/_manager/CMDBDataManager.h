//
//  CMDBDataManager.h
//  I_NScreen
//
//  Created by 조백근 on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <Foundation/Foundation.h>

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
- (void)saveDefaultAeraCode;


@end
