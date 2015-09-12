//
//  NSUserDefaults+Settings.m
//  STVN
//
//  Created by lambert on 2014. 9. 30..
//
//

#import "NSUserDefaults+Settings.h"

NSString * const NSUserDefaultsAppType = @"NSUserDefaultsAppType";

@implementation NSUserDefaults (Settings)

#pragma mark - App 타입

- (void)setAppType:(CMAppType)appType {
    [self setInteger:appType forKey:NSUserDefaultsAppType];
}

- (CMAppType)appType {
    return [self integerForKey:NSUserDefaultsAppType];
}

@end