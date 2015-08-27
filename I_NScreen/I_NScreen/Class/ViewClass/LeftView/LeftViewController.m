//
//  LeftViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 8. 27..
//  Copyright (c) 2015년 JUNG KIL BAE. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController
@synthesize delegate;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)onCloseBtnClick:(id)sender
{
    [[DataManager getInstance].p_gUserClass onCloseBtnClickWithControl:self];
}

- (void)onCloseCollback
{
    [self.delegate onCloseCompletionReflash];
}

@end
