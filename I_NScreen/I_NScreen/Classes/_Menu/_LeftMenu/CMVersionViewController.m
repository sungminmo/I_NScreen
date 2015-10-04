//
//  CMVersionViewController.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 10. 4..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMVersionViewController.h"

@interface CMVersionViewController ()

@end

@implementation CMVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"버전 정보";
    self.isUseNavigationBar = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)actionDoneButton:(id)sender {
    [self backCommonAction];
}

@end
