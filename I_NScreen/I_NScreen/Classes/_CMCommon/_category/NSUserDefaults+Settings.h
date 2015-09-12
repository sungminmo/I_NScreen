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

@interface NSUserDefaults (Settings)

/**
 *  @brief  App 타입.
 */
@property (nonatomic, assign) CMAppType appType;

@end