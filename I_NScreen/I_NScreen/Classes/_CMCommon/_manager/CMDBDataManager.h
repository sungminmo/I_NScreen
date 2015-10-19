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

- (NSString*)purchaseAuthorizedNumber;

- (void)savePurchaseAuthorizedNumber:(NSString*)number;


- (void)saveDefaultAeraCode;

- (void)saveDefaultProductCode;

@end
