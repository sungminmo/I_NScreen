//
//  NSUserDefaults+Settings.m
//  STVN
//
//  Created by lambert on 2014. 9. 30..
//
//

#import "NSUserDefaults+Settings.h"

NSString* const NSUserDefaultsAppType = @"NSUserDefaultsAppType";
NSString* const NSUserDefaultsRestrictType = @"NSUserDefaultsRestrictType";

@implementation NSUserDefaults (Settings)

#pragma mark - App 타입

- (void)setAppType:(CMAppType)appType {
    [self setInteger:appType forKey:NSUserDefaultsAppType];
}

- (CMAppType)appType {
    return [self integerForKey:NSUserDefaultsAppType];
}

- (void)setRestrictType:(CMContentsRestrictedType)restrictType {
    [self setInteger:restrictType forKey:NSUserDefaultsRestrictType];
}

- (CMContentsRestrictedType)restrictType {
    return [self integerForKey:NSUserDefaultsRestrictType];
}



@end