//
//  PvrSubViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//
/*/================================================================================================
 PVR - SUB
 ================================================================================================/*/

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"
#import "PvrSubTableViewCell.h"

@protocol PvrSubViewDelegate;

@interface PvrSubViewController : CMBaseViewController

@property (nonatomic, strong) NSString *pSeriesIdStr;
@property (nonatomic, strong) NSString *pTitleStr;
@property (nonatomic, strong) NSMutableArray *pSeriesReserveListArr;
@property (nonatomic)BOOL isTapCheck;   // no 이면 녹화예약관리, yes 면 녹화물 목록

@property (nonatomic, weak) id <PvrSubViewDelegate>delegate;

@end

@protocol PvrSubViewDelegate <NSObject>

@optional
- (void)PvrSubViewWithTap:(BOOL)isTap;

@end