//
//  NSDictionary+Merge.m
//  STVN
//
//  Created by lambert on 2014. 12. 16..
//
//

#import "NSDictionary+Merge.h"

@implementation NSDictionary (Merge)

+ (NSDictionary *)dictionaryByMerging:(NSDictionary *)dict1 with: (NSDictionary *)dict2 {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:dict1];
    
    [dict2 enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        if ([dict1 objectForKey:key]) {
            // 키가 같으면...
            NSMutableArray *temp = [NSMutableArray array];
            
            id dictObj1 = [dict1 objectForKey:key];
            if ([dictObj1 isKindOfClass:[NSArray class]]) {
                [dictObj1 enumerateObjectsUsingBlock:^(id tObj, NSUInteger tIdx, BOOL *tStop) {
                    [temp addObject:tObj];
                }];
            }
            
            if ([obj isKindOfClass:[NSArray class]]) {
                [obj enumerateObjectsUsingBlock:^(id tObj, NSUInteger tIdx, BOOL *tStop) {
                    [temp addObject:tObj];
                }];
            }
            [result setObject:temp forKey:key];
        }
        else {
            // 키가 다르면...
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *newVal = [[dict1 objectForKey:key] dictionaryByMergingWith:(NSDictionary *)obj];
                [result setObject:newVal forKey:key];
            }
            else {
                [result setObject:obj forKey:key];
            }
        }
    }];

    return (NSDictionary *)[result mutableCopy];
}

- (NSDictionary *)dictionaryByMergingWith:(NSDictionary *)dict {
    return [[self class] dictionaryByMerging:self with:dict];
}

@end
