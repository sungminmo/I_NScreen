//
//  AdultMainViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"
#import "CMHomeCommonCollectionViewCell.h"
#import "VodDetailMainViewController.h"
#import "CMPreferenceMainViewController.h"

@protocol AdultMainViewDelegate;

@interface AdultMainViewController : CMBaseViewController<CMHomeCommonCollectionViewCellDelegate, VodDetailMainViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *pView01; // 버튼 뷰
@property (nonatomic, strong) IBOutlet UIButton *pDepthBtn; // 댑스 버튼

@property (nonatomic, strong) IBOutlet UIView *pView21; // 인기 순위 탭 있는 뷰
@property (nonatomic, strong) IBOutlet UIButton *pRealTimeBtn;   // 실시간 인기 순위 버튼
@property (nonatomic, strong) IBOutlet UIButton *pWeekBtn;      // 주간 인기 순위 버튼
@property (nonatomic, strong) IBOutlet UICollectionView* pCollectionView21;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* pLeftLineHeight;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* pRightLineHeight;


@property (nonatomic, strong) IBOutlet UIView *pView22; // 리스트 뷰만 있는 뷰
@property (nonatomic, strong) IBOutlet UICollectionView* pCollectionView22;
@property (nonatomic) BOOL isItemCheck;     // 댑스 체크 no 이면 실시간 인기 순위, yes 이면 주간 인기 순위
@property (nonatomic, strong) NSString *pViewerTypeStr;
@property (nonatomic, strong) NSDictionary *pDataDic;

@property (nonatomic, weak) id <AdultMainViewDelegate>delegate;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end

@protocol AdultMainViewDelegate <NSObject>

@optional
- (void)AdultMainViewWithBtnTag:(int)nTag WithCategoryId:(NSString *)categoryId currentData:(NSDictionary*)dataDic;

@end