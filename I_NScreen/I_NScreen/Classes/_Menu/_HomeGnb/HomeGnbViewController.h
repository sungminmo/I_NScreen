//
//  HomeGnbViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 11..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeGnbViewDelegate;

@interface HomeGnbViewController : UIViewController

@property (nonatomic, weak) id <HomeGnbViewDelegate>delegate;
@property (nonatomic, strong) IBOutlet UIButton *pListBtn;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end

@protocol HomeGnbViewDelegate <NSObject>

@optional
- (void)onHomeGnbViewMenuList:(int)nTag;

@end