//
//  MyCMBuyListTableViewCell.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 16..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCMBuyListTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *pLineImageView01;     // 윗라인
@property (nonatomic, weak) IBOutlet UIImageView *pLineImageView02;     // 밑 라인
@property (nonatomic, weak) IBOutlet UILabel *pTitleLbl;                // 타이틀
@property (nonatomic, weak) IBOutlet UILabel *pPurchasedTimeLbl01;        // 상품 구매 시점
@property (nonatomic, weak) IBOutlet UILabel *pPurchasedTimeLbl02;        // 상품 구매 시점
@property (nonatomic, weak) IBOutlet UILabel *pLicenseEndLbl;           // 유효기간
@property (nonatomic, weak) IBOutlet UILabel *pPriceLbl;                // 가격

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index;

@end
