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
@property (nonatomic, weak) IBOutlet UIView* alphaView;
@property (weak, nonatomic) IBOutlet UIView *upperView;
@property (weak, nonatomic) IBOutlet UILabel *pairingLabel;
@property (weak, nonatomic) IBOutlet UIButton *pairingButton;

@property (nonatomic, weak) IBOutlet UITableView *pTableView;

@property (weak, nonatomic) IBOutlet UIImageView *pairingImageView;
@property (weak, nonatomic) IBOutlet UILabel *pairingMessageLabel;
//actionVersionButton
@property (weak, nonatomic) IBOutlet UIButton *pVerionBtn;


@property (nonatomic) int nTag;

- (IBAction)onCloseBtnClick:(id)sender;

- (void)onLeftMenuCloseComplet;

@end

@protocol LeftMenuViewDelegate <NSObject>

@optional
- (void)onLeftMenuViewCloseCompletReflash:(int)nTag;

@end
