//
//  CMPaytvGuideViewController.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 9. 29..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMPaytvGuideViewController.h"
#import "NSMutableDictionary+Preference.h"
#import "UIImageView+AFNetworking.h"

@interface CMPaytvGuideViewController ()
@property (nonatomic, strong) NSDictionary* guideItem;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (weak, nonatomic) IBOutlet UIImageView* imageView;
@property (weak, nonatomic) IBOutlet UIWebView* detailView;
@property (weak, nonatomic) IBOutlet UILabel* subTitleLabel;
- (IBAction)actionDoneButton:(id)sender;
@end

@implementation CMPaytvGuideViewController

- (id)initWithGuideInfo:(NSDictionary*)item {
    if ( self = [super initWithNibName:@"CMPaytvGuideViewController" bundle:nil])
    {
        self.guideItem = [item copy];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.isUseNavigationBar = YES;
    self.topMargin.constant = cmNavigationHeight + 13;
    
    [self loadContents];
    [self requestGuide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadContents {
    self.title = [self.guideItem[@"Joy_Title"] emptyCheck];
}

- (IBAction)actionDoneButton:(id)sender {
    [self backCommonAction];
}

- (void)requestGuide {
    NSString* tv = self.guideItem[@"Joy_ID"];
    if (tv.length > 0) {
        [NSMutableDictionary preferenceGetServiceJoyNInfoCode:tv completion:^(NSArray *preference, NSError *error) {
            NSDictionary* item = preference.lastObject[@"JoyN_Item"];
            
            NSString* thumb = [item[@"Joy_Img"] emptyCheck];
            [self.imageView setImageWithURL:[NSURL URLWithString:thumb]];
            
            NSString* contents = item[@"Joy_Content"];
            contents = [contents emptyCheck];
            if (contents.length > 0) {
//                NSData* data = [contents dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
//                NSAttributedString* attrText = [[NSAttributedString alloc] initWithData:data options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//                                                                                                       NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
//                self.detailView.attributedText = attrText;
                [self.detailView loadHTMLString:contents baseURL:nil];
            }
            
        }];
    }
}


@end

/*
 
 Joy_Thumbnail_Img = http://58.141.255.80/data/JoyN/201101281737190.png;
 Joy_SubTitle = 성공을 부르는 습관 한국경제TV;
 Joy_Title = 한국경제TV (Ch. 504);
 Joy_Content = <Div style="Padding:30px;text-align:justify;">
 <Font size=2>
 한국경제 TV는 방송을 시청하면서 동시에 실시간 주가현황, 종목뉴스, 증권사투자 정보 등 다양한 경제 주식 정보를 이용 할 수 있는 양방향 서비스 입니다.</P>
 <이용안내><BR>
 한국 경제TV 채널 504번 시청 중 TV화면 우측 상단에 빨간 버튼이 나타나면 리모콘의 빨간 버튼을 눌러 이용하실 수 있습니다. </Font></Div>;
 Joy_ID = 3;
 
 */
