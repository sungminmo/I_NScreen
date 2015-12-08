//
//  CMContactInfoViewCcontroller.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 9. 29..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMContactInfoViewCcontroller.h"
#import "NSMutableDictionary+Preference.h"

@interface CMContactInfoViewCcontroller ()
@property (weak, nonatomic) IBOutlet UIWebView* termsView;
@end

@implementation CMContactInfoViewCcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"고객센터안내";
    self.isUseNavigationBar = YES;
    [self requestContact];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)actionDoneButton:(id)sender {
    [self backCommonAction];
}

- (void)requestContact {
    [NSMutableDictionary perferenceGetServiceguideInfoWithCode:@"2" completion:^(NSArray *preference, NSError *error) {
        if (preference != nil) {
            NSDictionary* dic = (NSDictionary*)preference.lastObject;
            NSDictionary* guide = dic[@"Guide_Item"];
            
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
