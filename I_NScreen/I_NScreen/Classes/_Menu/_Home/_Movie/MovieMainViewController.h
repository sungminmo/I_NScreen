//
//  MovieMainViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"

@protocol MovieMainViewDelegate;

@interface MovieMainViewController : CMBaseViewController

@property (nonatomic, strong) IBOutlet UIScrollView *pScrollView;
@property (nonatomic, strong) IBOutlet UIView *pView01;
@property (nonatomic, strong) IBOutlet UIView *pView02;

@property (nonatomic, strong) IBOutlet UIButton *pListBtn;

@property (nonatomic, weak) id <MovieMainViewDelegate>delegate;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end


@protocol MovieMainViewDelegate <NSObject>

@optional
- (void)MovieMainViewWithBtnTag:(int)nTag;

@end