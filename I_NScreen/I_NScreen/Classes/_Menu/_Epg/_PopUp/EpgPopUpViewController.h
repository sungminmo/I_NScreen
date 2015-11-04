//
//  EpgPopUpViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 14..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CMBaseViewController.h"

@protocol EpgPopUpViewDelegate;

@interface EpgPopUpViewController : CMBaseViewController

@property (nonatomic, weak) IBOutlet UIButton *pCloseBtn;   // 닫기
@property (nonatomic, weak) IBOutlet UIButton *pChannelFullBtn;  // 전체 체널 버튼
@property (nonatomic, weak) IBOutlet UIButton *pChannelFavorBtn;    // 선호 채널 버튼
@property (nonatomic, weak) IBOutlet UIButton *pChannelBgBtn;       // bg 버튼

@property (nonatomic, weak) IBOutlet UIButton *pSubBtn01;
@property (nonatomic, weak) IBOutlet UIButton *pSubBtn02;
@property (nonatomic, weak) IBOutlet UIButton *pSubBtn03;
@property (nonatomic, weak) IBOutlet UIButton *pSubBtn04;
@property (nonatomic, weak) IBOutlet UIButton *pSubBtn05;
@property (nonatomic, weak) IBOutlet UIButton *pSubBtn06;
@property (nonatomic, weak) IBOutlet UIButton *pSubBtn07;
@property (nonatomic, weak) IBOutlet UIButton *pSubBtn08;
@property (nonatomic, weak) IBOutlet UIButton *pSubBtn09;
@property (nonatomic) int nGenreCode;

@property (nonatomic, weak) id<EpgPopUpViewDelegate>delegate;

- (IBAction)onBtnClick:(UIButton *)btn;

@end

@protocol EpgPopUpViewDelegate <NSObject>

@optional
- (void)EpgPopUpViewReloadWithGenre:(NSDictionary *)genreDic WithTag:(int)nTag;

@end