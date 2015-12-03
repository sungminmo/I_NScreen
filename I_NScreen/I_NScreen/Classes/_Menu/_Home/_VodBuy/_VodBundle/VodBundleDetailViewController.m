//
//  VodBundleDetailViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 27..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "VodBundleDetailViewController.h"
#import "NSMutableDictionary+Payment.h"
#import "UIAlertView+AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "NSMutableDictionary+VOD.h"

@interface VodBundleDetailViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *pThumImageView;
@property (nonatomic, weak) IBOutlet UIImageView *pSaleImageView;
@property (nonatomic, weak) IBOutlet UIImageView *pRatingImageView;
@property (nonatomic, weak) IBOutlet UIImageView *pStarImageView01;
@property (nonatomic, weak) IBOutlet UIImageView *pStarImageView02;
@property (nonatomic, weak) IBOutlet UIImageView *pStarImageView03;
@property (nonatomic, weak) IBOutlet UIImageView *pStarImageView04;
@property (nonatomic, weak) IBOutlet UIImageView *pStarImageView05;
@property (nonatomic, weak) IBOutlet UIImageView *pHdSdImageView;
@property (nonatomic, weak) IBOutlet UIImageView *pTvImageView;
@property (nonatomic, weak) IBOutlet UIImageView *pMobileImageView;
@property (nonatomic, weak) IBOutlet UILabel *pTitleLbl;
@property (nonatomic, weak) IBOutlet UILabel *pPriceLbl;
@property (nonatomic, weak) IBOutlet UILabel *pSalePriceLbl;
@property (nonatomic, weak) IBOutlet UILabel *pGenreLbl;
@property (nonatomic, weak) IBOutlet UILabel *pDirectorLbl; // 감독
@property (nonatomic, weak) IBOutlet UILabel *pStarringLbl; // 출연진
@property (nonatomic, weak) IBOutlet UILabel *pSeeDayLbl;   // 시청 기간
@property (nonatomic, weak) IBOutlet UITextView *pContentTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;

@end

@implementation VodBundleDetailViewController
@synthesize sAsset;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewInit];
    [self setDataInit];
    
    [self requestWithAssetInfo];
}

#pragma mark - 초기화
#pragma mark - 화면 초기화
- (void)setViewInit
{
    self.title = @"상세정보";
    self.isUseNavigationBar = YES;
    self.topMargin.constant = cmNavigationHeight;
}

#pragma mark - 데이터 초기화
- (void)setDataInit
{

}

#pragma mark - 전문
#pragma mark - vod 상세
- (void)requestWithAssetInfo
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetAssetInfoWithAssetId:self.sAsset WithAssetProfile:@"9" completion:^(NSArray *vod, NSError *error) {
        
        DDLogError(@"vod 상세 = [%@]", vod);
        
        if ( [vod count] == 0 )
            return;
        
        self.pTitleLbl.text = [NSString stringWithFormat:@"%@", [[[vod objectAtIndex:0] objectForKey:@"asset"] objectForKey:@"title"]];
        
        NSString *sRating = [NSString stringWithFormat:@"%@", [[[vod objectAtIndex:0] objectForKey:@"asset"] objectForKey:@"rating"]];
        
        if ( [sRating isEqualToString:@"19"] )
        {
            [self.pRatingImageView setImage:[UIImage imageNamed:@"19.png"]];
        }
        else if ( [sRating isEqualToString:@"19세"] )
        {
            [self.pRatingImageView setImage:[UIImage imageNamed:@"19.png"]];
        }
        else if ( [sRating isEqualToString:@"15"] )
        {
            [self.pRatingImageView setImage:[UIImage imageNamed:@"15.png"]];
        }
        else if ( [sRating isEqualToString:@"12"] )
        {
            [self.pRatingImageView setImage:[UIImage imageNamed:@"12.png"]];
        }
        else if ( [sRating isEqualToString:@"7"] )
        {
            [self.pRatingImageView setImage:[UIImage imageNamed:@"7.png"]];
        }
        else
        {
            [self.pRatingImageView setImage:[UIImage imageNamed:@"all.png"]];
        }
        
        // 장르
        self.pGenreLbl.text = [NSString stringWithFormat:@"%@", [[[vod objectAtIndex:0] objectForKey:@"asset"] objectForKey:@"genre"]];
        
        // 감독
        self.pDirectorLbl.text = [NSString stringWithFormat:@"%@", [[[vod objectAtIndex:0] objectForKey:@"asset"] objectForKey:@"director"]];
        
        // 출연진
        self.pStarringLbl.text = [NSString stringWithFormat:@"%@", [[[vod objectAtIndex:0] objectForKey:@"asset"] objectForKey:@"starring"]];
        
        // 시청 기간
        
        
        // 시청 기기
        NSString *sPublicationRight = [NSString stringWithFormat:@"%@", [[[vod objectAtIndex:0] objectForKey:@"asset"] objectForKey:@"publicationRight"]];
        
        if ( [sPublicationRight isEqualToString:@"2"] )
        {
            // tv 모바일
            self.pMobileImageView.image = [UIImage imageNamed:@"icon_mobile.png"];
            self.pMobileImageView.hidden = NO;
        }
        else
        {
            // tv 전용
            self.pMobileImageView.hidden = YES;
        }
        
        // 상세
        self.pContentTextView.text = [NSString stringWithFormat:@"%@", [[[vod objectAtIndex:0] objectForKey:@"asset"] objectForKey:@"synopsis"]];
        
        // 별점
        
        // 이미지
        NSString *sUrl = [NSString stringWithFormat:@"%@", [[[vod objectAtIndex:0] objectForKey:@"asset"] objectForKey:@"smallImageFileName"]];
        [self.pThumImageView setImageWithURL:[NSURL URLWithString:sUrl]];
        
        // 가격
        NSObject *itemObject = [[[[vod objectAtIndex:0] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"];
        
        if ( [itemObject isKindOfClass:[NSDictionary class]] )
        {
            self.pPriceLbl.text = [NSString stringWithFormat:@"%@", [(NSDictionary *)itemObject objectForKey:@"price"]];
            
        }
        else
        {
            self.pPriceLbl.text = [NSString stringWithFormat:@"%@", [[(NSArray *)itemObject objectAtIndex:0] objectForKey:@"price"]];
            
        }
        
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}
@end
