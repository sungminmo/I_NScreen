//
//  NSUserDefaults+Settings.h
//  STVN
//
//  Created by lambert on 2014. 9. 30..
//
//

#import <Foundation/Foundation.h>

/**
 *  @brief  App 타입.
 */
extern NSString * const NSUserDefaultsAppType;
extern NSString* const NSUserDefaultsRestrictType;
extern NSString* const NSUserDefaultsAdultCertYN;

@interface NSUserDefaults (Settings)

/**
 *  @brief  App 타입.
 */
@property (nonatomic, assign) CMAppType appType;

/**
 *  컨텐츠 제한 타입.
 */
@property (nonatomic, assign) CMContentsRestrictedType restrictType;

@end