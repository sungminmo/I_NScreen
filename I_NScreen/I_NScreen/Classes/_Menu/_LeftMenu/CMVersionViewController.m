//
//  CMVersionViewController.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 10. 4..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMVersionViewController.h"
#import "NSMutableDictionary+Preference.h"

@interface CMVersionViewController ()
@property (weak, nonatomic) IBOutlet UILabel* versionValueLabel;
@property (weak, nonatomic) IBOutlet UILabel* regValueLabel;
@property (weak, nonatomic) IBOutlet UILabel* modValueLabel;
@end

@implementation CMVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"버전 정보";
    self.isUseNavigationBar = YES;
    [self requestVersion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)actionDoneButton:(id)sender {
    [self backCommonAction];
}

- (void)requestVersion {
    [NSMutableDictionary perferenceGetAppVersionInfoCompletion:^(NSArray *preference, NSError *error) {
        if (preference != nil) {
            NSDictionary* dic = (NSDictionary*)preference.lastObject;
            NSString* ver = dic[@"AppVersion"];
            NSString* reg = dic[@"registdate"];
            NSString* mod = dic[@"Modifydate"];
            self.versionValueLabel.text = [ver emptyCheck];
            self.regValueLabel.text = [reg emptyCheck];
            self.modValueLabel.text = [mod emptyCheck];
        }
    }];
}

@end
