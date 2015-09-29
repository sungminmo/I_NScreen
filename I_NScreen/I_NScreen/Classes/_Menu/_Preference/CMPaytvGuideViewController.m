//
//  CMPaytvGuideViewController.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 9. 29..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMPaytvGuideViewController.h"

@interface CMPaytvGuideViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (weak, nonatomic) IBOutlet UIImageView* imageView;
@property (weak, nonatomic) IBOutlet UITextView* detailView;
- (IBAction)actionDoneButton:(id)sender;
@end

@implementation CMPaytvGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";//채널타이틀 세팅필요
    self.isUseNavigationBar = YES;
    self.topMargin.constant = cmNavigationHeight + 13;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)settingInfo:(NSDictionary*)item {
    self.title = @"";
}

- (IBAction)actionDoneButton:(id)sender {
    [self backCommonAction];
}

@end
