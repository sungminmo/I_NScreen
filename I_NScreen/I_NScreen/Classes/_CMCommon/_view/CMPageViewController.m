//
//  CMPageViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 15..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMPageViewController.h"

@interface CMPageViewController ()
{
    NSDictionary *pDic;
    int nPage;
    CGRect rect;
}
@end

@implementation CMPageViewController
@synthesize delegate;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithData:(NSDictionary *)dic WithPage:(int)page WithFrame:(CGRect )cgRect
{
    if ( self = [super initWithNibName:@"CMPageViewController" bundle:nil])
    {
        pDic = dic;
        nPage = page;
        rect = cgRect;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    int nBannerHeight = 0;
    
    int nWith = [UIScreen mainScreen].bounds.size.width;
    
    if ( [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_6_PLUS] )
    {
        nBannerHeight = 225;
        
    }else
    {
        nBannerHeight = 225 * nWith / 414;
    }
    
//    if ( nPage == 0 )
//    {
//        self.view.backgroundColor = [UIColor redColor];
//        
//    }
//    else if ( nPage == 1 )
//    {
//        self.view.backgroundColor = [UIColor grayColor];
//        
//    }
//    else
//    {
//        self.view.backgroundColor = [UIColor yellowColor];
//        
//    }
    
    
    UIImage *pBgImage = [UIImage imageNamed:@"banner_empty.png"];
//    UIImageView *pBgImagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, pBgImage.size.width, pBgImage.size.height)];
   UIImageView *pBgImagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    pBgImagView.image = pBgImage;
    [pBgImagView setContentMode:UIViewContentModeScaleAspectFit];
//    [self.view addSubview:pBgImagView];
    
    UIImage *pImage = [UIImage imageNamed:@"banner_sample.png"];
    UIImageView *pImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 0, rect.size.width - 2, rect.size.height - 2)];
    pImageView.image = pImage;
    [pImageView setContentMode:UIViewContentModeScaleAspectFit];
//    [self.view addSubview:pImageView];
    
    UIButton *pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pBtn.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    [pBtn addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:pBtn];
}

- (void)onBtnClicked:(UIButton *)btn
{
    
}


@end
