//
//  MovieMainViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "MovieMainViewController.h"

@interface MovieMainViewController ()

@end

@implementation MovieMainViewController
@synthesize delegate;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTagInit];
    [self setViewInit];
}

#pragma mark - 초기화
#pragma mark - 버튼 태그 초기화
- (void) setTagInit
{
    self.pDepthBtn.tag = MOVIE_MAIN_VIEW_BTN_01;
    self.pRealTimeBtn.tag = MOVIE_MAIN_VIEW_BTN_02;
    self.pWeekBtn.tag = MOVIE_MAIN_VIEW_BTN_03;
}

#pragma mark - 화면 초기화
- (void) setViewInit
{
//    [self.pScrollView addSubview:self.pView01];
//    [self.pScrollView addSubview:self.pView02];
//    
//    self.pView01.frame = CGRectMake(0, 0, self.pView01.frame.size.width, self.pView01.frame.size.height);
//    self.pView02.frame = CGRectMake(0, self.pView01.frame.origin.y + self.pView01.frame.size.height, self.pView02.frame.size.width, self.pView02.frame.size.height);
//    
//    int nHeight = self.pView01.frame.size.height + self.pView02.frame.size.height;
//    
//    [self.pScrollView setContentSize:CGSizeMake(self.pScrollView.frame.size.width, nHeight)];
    
}

#pragma mark - 액션 이벤트
#pragma mark - 버튼 액션 이벤트
- (IBAction)onBtnClicked:(UIButton *)btn
{
    switch ([btn tag]) {
        case MOVIE_MAIN_VIEW_BTN_01:
        {
            [self.delegate MovieMainViewWithBtnTag:MOVIE_MAIN_VIEW_BTN_01];
        }break;
        case MOVIE_MAIN_VIEW_BTN_02:
        {
            // 실시간 인기 순위 버튼
            
        }break;
        case MOVIE_MAIN_VIEW_BTN_03:
        {
            // 주간 인기 순위 버튼
            
        }break;
    }
}

#pragma mark - 전문
#pragma mark - 2탭스 카테고리 tree 리스트 전문
- (void)requestWithGetCategoryTree2Depth
{
//    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetAssetInfoWithAssetId:self.pAssetIdStr WithAssetProfile:@"9" completion:^(NSArray *vod, NSError *error) {
//        
//        DDLogError(@"vod 상세 = [%@]", vod);
//        
//        if ( [vod count] == 0 )
//            return;
//        [self.pAssetInfoDic removeAllObjects];
//        [self.pAssetInfoDic setDictionary:[vod objectAtIndex:0]];
//        
//        self.pFileNameStr = [NSString stringWithFormat:@"%@", [[[vod objectAtIndex:0] objectForKey:@"asset"] objectForKey:@"fileName"]];
//        
//        [self requestWithDrm];
//        [self setResponseViewInit];
//        
//    }];
//    
//    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];

}

@end
