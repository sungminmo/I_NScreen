//
//  EpgPopUpViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 14..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CMBaseViewController.h"

@interface EpgPopUpViewController : CMBaseViewController

@property (nonatomic, weak) IBOutlet UIButton *pCloseBtn;   // 닫기
@property (nonatomic, weak) IBOutlet UIButton *pChannelFullBtn;  // 전체 체널 버튼
@property (nonatomic, weak) IBOutlet UIButton *pChannelFavorBtn;    // 선호 채널 버튼
@property (nonatomic, weak) IBOutlet UIButton *pChannelBgBtn;       // bg 버튼

- (IBAction)onBtnClick:(UIButton *)btn;

@end
