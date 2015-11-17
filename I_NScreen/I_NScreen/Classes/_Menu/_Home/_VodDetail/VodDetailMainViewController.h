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
#import "PlayerViewController.h"
#import "VodBuyViewController.h"

@protocol VodDetailMainViewDelegate;

@interface VodDetailMainViewController : CMBaseViewController <UIScrollViewDelegate, CMContentGroupCollectionViewDelegate, PlayerViewDelegate, VodBuyViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *pView01;
@property (nonatomic, strong) IBOutlet UIScrollView *pBodyView;

// 중간 View21
@property (nonatomic, strong) IBOutlet UIView *pView21;
@property (nonatomic, strong) IBOutlet UITextView *pContentTextView21;    // 컨텐츠 텍스트
@property (nonatomic, strong) IBOutlet UIButton *pWatchBtn21; // 시청버튼

// 중간 View22
@property (nonatomic, strong) IBOutlet UIView *pView22;
@property (nonatomic, strong) IBOutlet UITextView *pContentTextView22;  // 컨텐츠 텍스트
@property (nonatomic, strong) IBOutlet UIButton *pReviewBtn22;        // 미리보기
//@property (nonatomic, strong) IBOutlet UIButton *pWatchBtn22;       // 시청버튼
@property (nonatomic, strong) IBOutlet UIButton *pBuyBtn22;         // 구매하기
@property (nonatomic, strong) IBOutlet UIButton *pZzimBtn22;        // 찜하기

// 중간 View23
@property (nonatomic, strong) IBOutlet UIView *pView23;
@property (nonatomic, strong) IBOutlet UIScrollView *pSeriesScrollView23;   // 시리즈 스크롤 뷰
@property (nonatomic, strong) IBOutlet UITextView *pContentTextView23;      // 컨텐츠 텍스트
@property (nonatomic, strong) IBOutlet UIButton *pReviewBtn23;
//@property (nonatomic, strong) IBOutlet UIButton *pWatchBtn23;
@property (nonatomic, strong) IBOutlet UIButton *pBuyBtn23;             // 구매하기
@property (nonatomic, strong) IBOutlet UIButton *pZzimBtn23;

// 중간 View24
@property (nonatomic, strong) IBOutlet UIView *pView24;
@property (nonatomic, strong) IBOutlet UIScrollView *pSeriesScrollView24;
@property (nonatomic, strong) IBOutlet UITextView *pContentTextView24;
@property (nonatomic, strong) IBOutlet UIButton *pWatchBtn24;


// 중간 View25
@property (nonatomic, strong) IBOutlet UIView *pView25;
@property (nonatomic, strong) IBOutlet UIScrollView *pSeriesScrollView25;
@property (nonatomic, strong) IBOutlet UITextView *pContentTextView25;
@property (nonatomic, strong) IBOutlet UILabel *pCommentLbl25;

// 중간 View26
@property (nonatomic, strong) IBOutlet UIView *pView26;
@property (nonatomic, strong) IBOutlet UITextView *pContentTextView26;
@property (nonatomic, strong) IBOutlet UILabel *pCommentLbl26;

@property (nonatomic, strong) IBOutlet UIView *pView03;

@property (nonatomic, strong) IBOutlet UIImageView *pThumImageView; // 섬네일 이미지
@property (nonatomic, strong) IBOutlet UIImageView *pStarImage01;
@property (nonatomic, strong) IBOutlet UIImageView *pStarImage02;
@property (nonatomic, strong) IBOutlet UIImageView *pStarImage03;
@property (nonatomic, strong) IBOutlet UIImageView *pStarImage04;
@property (nonatomic, strong) IBOutlet UIImageView *pStarImage05;

@property (nonatomic, strong) IBOutlet UIImageView *pRatingImageView;   // 시청 등급 이미지
@property (nonatomic, strong) IBOutlet UIImageView *pResolutionImageView;   // hd sd 해상도
@property (nonatomic, strong) IBOutlet UIImageView *pEquipmentImageView;    // 시청 기기
@property (nonatomic, strong) IBOutlet UIImageView *pEquipmentImageView02;

@property (nonatomic, strong) IBOutlet UILabel *pTitleLbl;  // 이름
@property (nonatomic, strong) IBOutlet UILabel *pPriceLbl;  // 가격
@property (nonatomic, strong) IBOutlet UILabel *pSummaryLbl; // 개요
@property (nonatomic, strong) IBOutlet UILabel *pManagerLbl;    // 감독
@property (nonatomic, strong) IBOutlet UILabel *pCastLbl;       // 출연자
@property (nonatomic, strong) IBOutlet UILabel *pTermLbl;   // 시청 기간



@property (nonatomic, strong) IBOutlet UIScrollView *pScrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pPageControl;

@property (nonatomic, strong) NSString *pAssetIdStr;        // 어셋 아이디
@property (nonatomic, strong) NSString *pFileNameStr;       // 파일 name

@property (readwrite, retain) MPMoviePlayerController *pMoviePlayer;

@property (nonatomic, weak) id<VodDetailMainViewDelegate>delegate;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end

@protocol VodDetailMainViewDelegate <NSObject>

@optional
- (void)VodDetailMainViewWithTag:(int)nTag;

@end