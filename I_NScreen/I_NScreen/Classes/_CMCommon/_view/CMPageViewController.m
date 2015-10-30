//
//  CMPageViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 15..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMPageViewController.h"
#import "UIImageView+AFNetworking.h"

@interface CMPageViewController ()
{
    NSDictionary *pDic;
    int nPage;
}
@end

@implementation CMPageViewController
@synthesize delegate;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithData:(NSDictionary *)dic WithPage:(int)page
{
    if ( self = [super initWithNibName:@"CMPageViewController" bundle:nil])
    {
        pDic = dic;
        nPage = page;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.pImageView setImageWithURL:[NSURL URLWithString:[self getImageUrlSplit]]];
//    [self.pImageView setContentMode:UIViewContentModeScaleAspectFit];
//    [self.view addSubview:self.pImageView];
    
    UIButton *pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pBtn.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [pBtn addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pBtn];
}

#pragma mark - 액션 이벤트
#pragma mark - 버튼 액션 이벤트
- (void)onBtnClicked:(UIButton *)btn
{
    
}

#pragma mark - url split
- (NSString *)getImageUrlSplit
{
    NSString *sNNImage = @"";
    
    NSString *sImgUrl = [NSString stringWithFormat:@"%@", [pDic objectForKey:@"iphone_imgurl"]];
    
    NSArray *sImageArr = [sImgUrl componentsSeparatedByString:@"://"];
    
    if ( [sImageArr count] != 0 )
    {
        NSString *sNImgUrl = [NSString stringWithFormat:@"%@", [sImageArr objectAtIndex:[sImageArr count] - 1]];
        
        NSArray *sNImageArr = [sNImgUrl componentsSeparatedByString:@"/"];
        
        int nCount = 0;
        NSMutableString *sImageAdd = [NSMutableString new];
        
        for ( NSString *str in sNImageArr )
        {
            if ( nCount == 0 )
            {
                [sImageAdd appendString:@"http://192.168.44.10"];
            }
            else
            {
                [sImageAdd appendFormat:@"/%@", str];
            }
            
            nCount++;
        }
        
        sNNImage = [NSString stringWithString:sImageAdd];
    }
    
    return sNNImage;
}

@end
