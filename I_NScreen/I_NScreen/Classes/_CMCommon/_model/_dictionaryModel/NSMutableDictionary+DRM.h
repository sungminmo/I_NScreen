//
//  NSMutableDictionary+DRM.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 30..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (DRM)

// ex) https://api.cablevod.co.kr/api/v1/mso/10/asset/www.hchoice.co.kr%7CM4151006LSG348552901/play
+ (NSURLSessionDataTask *)drmApiWithAsset:(NSString *)asset WithPlayStyle:(NSString *)style completion:(void (^)(NSDictionary *drm, NSError *error))block;

@end
