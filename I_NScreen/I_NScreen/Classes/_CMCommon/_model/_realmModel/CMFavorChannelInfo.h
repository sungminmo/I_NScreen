//
//  CMFavorChannelInfo.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 18..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <Realm/Realm.h>

@interface CMFavorChannelInfo : RLMObject

@property NSString *pChannelId;
@property NSString *pChannelNumber;
@property NSString *pChannelName;
@property NSString *pChannelSeq;
@property NSString *pProgramId;

@end
