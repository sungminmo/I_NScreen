//
//  HomeGnbViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 11..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "HomeGnbViewController.h"

@interface HomeGnbViewController ()

@end

@implementation HomeGnbViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTagInit];
}

- (void)setTagInit
{
    self.pListBtn.tag = HOME_GNB_VIEW_BTN_TAG_01;
}

- (IBAction)onBtnClicked:(UIButton *)btn
{
    switch ([btn tag]) {
        case HOME_GNB_VIEW_BTN_TAG_01:
        {
            [self.delegate onHomeGnbViewMenuList:(int)[btn tag]];
        }break;
    }
}


@end
