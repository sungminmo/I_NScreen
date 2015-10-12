//
//  PopularProgramMainViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"

@interface PopularProgramMainViewController : CMBaseViewController

@property (nonatomic, strong) IBOutlet UIScrollView *pMainScrollView;
@property (nonatomic, strong) IBOutlet UIView *pPopularView;
@property (nonatomic, strong) IBOutlet UIPageControl *pPopularPgControl;
@property (nonatomic, strong) IBOutlet UIButton *pMorePopularBtn;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end
