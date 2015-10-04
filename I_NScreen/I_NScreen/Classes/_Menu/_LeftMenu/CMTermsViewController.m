//
//  CMTermsViewController.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 10. 4..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMTermsViewController.h"

@interface CMTermsViewController ()

@end

@implementation CMTermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"서비스 이용약관";
    self.isUseNavigationBar = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)actionDoneButton:(id)sender {
    [self backCommonAction];
}

@end
