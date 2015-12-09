//
//  CMSearchTableViewCell.h
//  I_NScreen
//
//  Created by 조백근 on 2015. 10. 1..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BMXSwipableCell/BMXSwipableCell.h>
#import "CMProgressView.h"

@protocol CMSearchTableViewDelegate;

@interface CMSearchTableViewCell : BMXSwipableCell

@property (nonatomic, weak) id <CMSearchTableViewDelegate>delegate2;
- (void)setData:(NSDictionary*)data WithIndex:(int)nIndex WithStar:(BOOL)isStar WithWatchCheck:(BOOL)isWatch WithRecordingCheck:(BOOL)isRecording WithReservCheck:(BOOL)isReservCheck;;

@end

@protocol CMSearchTableViewDelegate <NSObject>

@optional
- (void)CMSearchTableViewCellTag:(int)nTag;
- (void)CMSearchTableViewMoreBtn:(int)nIndex;
- (void)CMSearchTableViewDeleteBtn:(int)nIndex;

@end