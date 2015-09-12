//
//  LeftMenuViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 11..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftMenuViewDelegate;

@interface LeftMenuViewController : UIViewController

@property (nonatomic, weak) id <LeftMenuViewDelegate>delegate;
@property (nonatomic, strong) IBOutlet UITableView *pTableView;

@property (nonatomic) int nTag;

- (IBAction)onCloseBtnClick:(id)sender;

- (void)onLeftMenuCloseComplet;

@end

@protocol LeftMenuViewDelegate <NSObject>

@optional
- (void)onLeftMenuViewCloseCompletReflash:(int)nTag;

@end
