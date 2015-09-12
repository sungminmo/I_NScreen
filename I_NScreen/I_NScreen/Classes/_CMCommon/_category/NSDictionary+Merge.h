//
//  NSDictionary+Merge.h
//  STVN
//
//  Created by lambert on 2014. 12. 16..
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Merge)

+ (NSDictionary *)dictionaryByMerging:(NSDictionary *)dict1 with: (NSDictionary *)dict2;
- (NSDictionary *)dictionaryByMergingWith:(NSDictionary *)dict;



@end
