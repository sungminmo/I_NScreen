//
//  CMNoticeDetailViewController.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 9. 29..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMNoticeDetailViewController.h"

@interface CMNoticeDetailViewController ()
@property (nonatomic, strong) NSDictionary* noticeItem;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (weak, nonatomic) IBOutlet UIWebView* detailView;
- (IBAction)actionDoneButton:(id)sender;
@end

@implementation CMNoticeDetailViewController


- (id)initWithInfo:(NSDictionary*)item {
    if ( self = [super initWithNibName:@"CMNoticeDetailViewController" bundle:nil])
    {
        self.noticeItem = [item copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"공지사항";
    self.isUseNavigationBar = YES;
    self.topMargin.constant = cmNavigationHeight + 13;
    
    NSString* contents = self.noticeItem[@"notice_Content"];
    contents = [contents emptyCheck];
    if (contents.length > 0) {
//        NSData* data = [contents dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
//        NSAttributedString* attrText = [[NSAttributedString alloc] initWithData:data options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//                                                                                               NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
//        self.detailView.attributedText = attrText;
        
        [self.detailView loadHTMLString:contents baseURL:nil];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)actionDoneButton:(id)sender {
    [self backCommonAction];
}


@end
