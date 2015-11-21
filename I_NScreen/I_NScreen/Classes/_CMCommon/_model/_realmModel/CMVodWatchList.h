//
//  CMVodWatchList.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 22..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <Realm/Realm.h>

@interface CMVodWatchList : RLMObject

@property NSString *pWatchDateStr;
@property NSString *pAssetIdStr;
@property NSString *pTitleStr;

@end
