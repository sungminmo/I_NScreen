//
//  RemoconMainTableViewCell.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RemoconMainTableViewDelegate;

@interface RemoconMainTableViewCell : UITableViewCell

@property (nonatomic, weak) id <RemoconMainTableViewDelegate>delegate;

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index WithStar:(BOOL)isStar;
- (IBAction)onBtnClicked:(UIButton *)btn;

@end

@protocol RemoconMainTableViewDelegate <NSObject>

@optional
- (void)RemoconMainTableViewCellWithTag:(int)nTag;

@end