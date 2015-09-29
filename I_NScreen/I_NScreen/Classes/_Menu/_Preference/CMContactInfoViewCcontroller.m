//
//  CMContactInfoViewCcontroller.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 9. 29..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMContactInfoViewCcontroller.h"

@interface CMContactInfoViewCcontroller ()

@end

@implementation CMContactInfoViewCcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"고객센터안내";
    self.isUseNavigationBar = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)actionDoneButton:(id)sender {
    [self backCommonAction];
}

@end
