//
//  NSMutableDictionary+Merge.m
//  STVN
//
//  Created by lambert on 2014. 12. 17..
//
//

#import "NSMutableDictionary+Merge.h"

@implementation NSMutableDictionary (Merge)

- (void)set:(id)object for:(NSString *)key {
    if (!object) return;
    
    [self setObject:object forKey:key];
}

@end
