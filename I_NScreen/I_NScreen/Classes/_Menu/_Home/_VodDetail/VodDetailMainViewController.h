//
//  VodDetailMainViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 28..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"
#import "CMPageViewController.h"
#import "CMContentGroupCollectionViewController.h"

@interface VodDetailMainViewController : CMBaseViewController <UIScrollViewDelegate, CMContentGroupCollectionViewCellDelegate>

@property (nonatomic, strong) IBOutlet UIView *pView01;
@property (nonatomic, strong) IBOutlet UIScrollView *pBodyView;
@property (nonatomic, strong) IBOutlet UIView *pView02;
@property (nonatomic, strong) IBOutlet UIView *pView03;

@property (nonatomic, strong) IBOutlet UIButton *pBackBtn;  // back 버튼
@property (nonatomic, strong) IBOutlet UIButton *pWatchBtn; // 시청버튼

@property (nonatomic, strong) IBOutlet UIImageView *pThumImageView; // 섬네일 이미지
@property (nonatomic, strong) IBOutlet UIImageView *pStarImage01;
@property (nonatomic, strong) IBOutlet UIImageView *pStarImage02;
@property (nonatomic, strong) IBOutlet UIImageView *pStarImage03;
@property (nonatomic, strong) IBOutlet UIImageView *pStarImage04;
@property (nonatomic, strong) IBOutlet UIImageView *pStarImage05;

@property (nonatomic, strong) IBOutlet UIImageView *pRatingImageView;   // 시청 등급 이미지
@property (nonatomic, strong) IBOutlet UIImageView *pResolutionImageView;   // hd sd 해상도
@property (nonatomic, strong) IBOutlet UIImageView *pEquipmentImageView;    // 시청 기기

@property (nonatomic, strong) IBOutlet UILabel *pTitleLbl;  // 이름
@property (nonatomic, strong) IBOutlet UILabel *pPriceLbl;  // 가격
@property (nonatomic, strong) IBOutlet UILabel *pSummaryLbl; // 개요
@property (nonatomic, strong) IBOutlet UILabel *pManagerLbl;    // 감독
@property (nonatomic, strong) IBOutlet UILabel *pCastLbl;       // 출연자
@property (nonatomic, strong) IBOutlet UILabel *pTermLbl;   // 시청 기간

@property (nonatomic, strong) IBOutlet UITextView *pContentTextView;    // 컨텐츠 텍스트

@property (nonatomic, strong) IBOutlet UIScrollView *pScrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pPageControl;

@property (nonatomic, strong) NSString *pAssetIdStr;        // 어셋 아이디 

- (IBAction)onBtnClicked:(UIButton *)btn;

@end
