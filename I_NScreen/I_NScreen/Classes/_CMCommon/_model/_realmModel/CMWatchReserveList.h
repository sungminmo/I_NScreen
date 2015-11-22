//
//  CMWatchReserveList.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 22..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <Realm/Realm.h>

@interface CMWatchReserveList : RLMObject

@property NSString *programTitleStr;
@property NSString *programGradeStr;
@property NSString *programBroadcastingEndTimeStr;
@property NSString *programHDStr;
@property NSString *programBroadcastingStartTimeStr;
@property NSString *programPVRStr;
@property NSString *scheduleSeqStr;
@property NSString *programIdStr;
@property NSString *broadcastingDateStr;

@end
