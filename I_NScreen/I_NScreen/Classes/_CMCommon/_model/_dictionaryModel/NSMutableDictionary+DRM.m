//
//  NSMutableDictionary+DRM.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 30..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "NSMutableDictionary+DRM.h"

@implementation NSMutableDictionary (DRM)

+ (NSURLSessionDataTask *)drmApiWithAsset:(NSString *)asset completion:(void (^)(NSDictionary *drm, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] drmApiWithAsset:asset completion:block];
}

@end
