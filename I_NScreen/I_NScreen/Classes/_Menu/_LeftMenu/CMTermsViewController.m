//
//  CMTermsViewController.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 10. 4..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMTermsViewController.h"
#import "NSMutableDictionary+Preference.h"

@interface CMTermsViewController ()
@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UIWebView* termsView;
@end

@implementation CMTermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"서비스 이용약관";
    self.isUseNavigationBar = YES;
    [self requestTerms];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)actionDoneButton:(id)sender {
    [self backCommonAction];
}

- (void)requestTerms {
    [NSMutableDictionary perferenceGetServiceguideInfoWithCode:@"1" completion:^(NSArray *preference, NSError *error) {
        if (preference != nil) {
            NSDictionary* dic = (NSDictionary*)preference.lastObject;
            NSDictionary* guide = dic[@"Guide_Item"];
            
            // 가이드 타이틀 빼라 
//            NSString* title = guide[@"guide_title"];
//            self.titleLabel.text = [title emptyCheck];
            
            NSString* contents = guide[@"guide_Content"];
            contents = [contents emptyCheck];
            if (contents.length > 0) {
//                NSData* data = [contents dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
//                NSAttributedString* attrText = [[NSAttributedString alloc] initWithData:data options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//                                                                                                       NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
//                self.termsView.attributedText = attrText;
                [self.termsView loadHTMLString:contents baseURL:nil];
            }
        }
        
    }];
}

@end
