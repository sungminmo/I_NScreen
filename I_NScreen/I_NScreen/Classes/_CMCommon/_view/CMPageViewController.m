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

    UIImage *pBgImage = [UIImage imageNamed:@"banner_empty.png"];
    UIImageView *pBgImagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, pBgImage.size.width, pBgImage.size.height)];
    pBgImagView.image = pBgImage;
    [self.view addSubview:pBgImagView];
    
    UIImage *pImage = [UIImage imageNamed:@"banner_sample.png"];
    UIImageView *pImageView = [[UIImageView alloc] initWithFrame:CGRectMake((pBgImage.size.width - pImage.size.width)/2, 0, pImage.size.width, pImage.size.height)];
    pImageView.image = pImage;
    [self.view addSubview:pImageView];
    
    UIButton *pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pBtn.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [pBtn addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pBtn];
}

- (void)onBtnClicked:(UIButton *)btn
{
    
}


@end
