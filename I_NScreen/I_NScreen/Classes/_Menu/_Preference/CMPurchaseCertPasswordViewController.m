//
//  CMPurchaseCertPasswordViewController.m
//  I_NScreen
//
//  Created by kimteaksoo on 2015. 9. 29..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMPurchaseCertPasswordViewController.h"

@interface CMPurchaseCertPasswordViewController ()

@property (nonatomic, strong) IBOutlet UITextField* textField1;
@property (nonatomic, strong) IBOutlet UITextField* textField2;

@end

@implementation CMPurchaseCertPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"구매인증 비밀번호 관리";
    self.isUseNavigationBar = YES;
    
    self.textField1.backgroundColor = [UIColor whiteColor];
    self.textField1.layer.borderWidth = 1.f;
    self.textField1.layer.cornerRadius = 4.0f;
    self.textField1.layer.masksToBounds = YES;
    self.textField1.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.textField2.layer.borderWidth = 1.f;
    self.textField2.layer.cornerRadius = 4.0f;
    self.textField2.layer.masksToBounds = YES;
    self.textField2.layer.borderColor = [UIColor redColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
