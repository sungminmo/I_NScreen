//
//  CMPurchaseCertPasswordViewController.m
//  I_NScreen
//
//  Created by kimteaksoo on 2015. 9. 29..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMPurchaseCertPasswordViewController.h"
#import "CMTextField.h"

@interface CMPurchaseCertPasswordViewController ()

@property (nonatomic, strong) IBOutlet CMTextField* textField1;
@property (nonatomic, strong) IBOutlet CMTextField* textField2;

@end

@implementation CMPurchaseCertPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"구매인증 비밀번호 관리";
    self.isUseNavigationBar = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
