//
//  CMBaseViewController.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 9. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMBaseViewController.h"

@interface CMBaseViewController ()

@end

@implementation CMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBarHidden) {
        self.isPrevNavigationBarHidden = YES;
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isPrevNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}

@end
