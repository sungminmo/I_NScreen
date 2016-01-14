//
//  HomeGnbViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 11..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeGnbViewDelegate;

@interface HomeGnbViewController : UIViewController

@property (nonatomic, weak) id <HomeGnbViewDelegate>delegate;
@property (nonatomic, strong) IBOutlet UIButton *pListBtn;
@property (nonatomic, strong) IBOutlet UIButton *pSearchBtn;
@property (nonatomic, strong) IBOutlet UIButton *pMenu01;   // 추천 버튼
@property (nonatomic, strong) IBOutlet UIView *pLine01;     // 추천 하단 라인
@property (nonatomic, strong) IBOutlet UIButton *pMenu02;   // 영화 버튼
@property (nonatomic, strong) IBOutlet UIView *pLine02;     // 추천 하단 라인
@property (nonatomic, strong) IBOutlet UIButton *pMenu03;   // 애니키즈
@property (nonatomic, strong) IBOutlet UIView *pLine03;     // 추천 하단 라인
@property (nonatomic, strong) IBOutlet UIButton *pMenu04;   // 인기프로그램
@property (nonatomic, strong) IBOutlet UIView *pLine04;     // 추천 하단 라인
@property (nonatomic, strong) IBOutlet UIButton *pMenu05;   // 성인
@property (nonatomic, strong) IBOutlet UIView *pLine05;     // 추천 하단 라인
@property (nonatomic, strong) IBOutlet UIButton *pTestBtn;  // 테스트 버튼

- (IBAction)onBtnClicked:(UIButton *)btn;

- (void)selectTabTag:(NSInteger)tag;
- (NSInteger)currentTabTag;

@end

@protocol HomeGnbViewDelegate <NSObject>

@optional
- (void)onHomeGnbViewMenuList:(int)nTag;

@end