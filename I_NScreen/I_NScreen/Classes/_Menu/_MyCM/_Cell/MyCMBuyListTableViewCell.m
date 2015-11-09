//
//  MyCMBuyListTableViewCell.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 16..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "MyCMBuyListTableViewCell.h"

@implementation MyCMBuyListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index
{
    if ( index != 0 )
    {
        self.pLineImageView01.hidden = YES;
    }
    else
    {
        self.pLineImageView01.hidden = NO;
    }
    
    self.pTitleLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"assetTitle"]]; // 타이틀
    self.pPriceLbl.text = [NSString stringWithFormat:@"%@", [[CMAppManager sharedInstance] insertComma:[dic objectForKey:@"price"]]];
    
    NSString *sPurchasedTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"purchasedTime"]];
    NSArray *purchasedTimeArr = [sPurchasedTime componentsSeparatedByString:@" "];
    NSArray *purchasedTimeArr2 = [[purchasedTimeArr objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSArray *purchasedTimeArr3 = [[purchasedTimeArr objectAtIndex:1] componentsSeparatedByString:@":"];
    NSString *sPurchasedTime2 = [NSString stringWithFormat:@"%@%@%@", [purchasedTimeArr2 objectAtIndex:0], [purchasedTimeArr2 objectAtIndex:1], [purchasedTimeArr2 objectAtIndex:2]];
    
    NSString *sWeek = [NSString stringWithFormat:@"%@", [[CMAppManager sharedInstance] GetDayOfWeek:sPurchasedTime2]];

    NSString *sMonth = [NSString stringWithFormat:@"%@", [purchasedTimeArr2 objectAtIndex:1]];
    NSString *sDay = [NSString stringWithFormat:@"%@", [purchasedTimeArr2 objectAtIndex:2]];
    
    NSString *sHour = [NSString stringWithFormat:@"%@", [purchasedTimeArr3 objectAtIndex:0]];
    NSString *sMinute = [NSString stringWithFormat:@"%@", [purchasedTimeArr3 objectAtIndex:1]];
    
    self.pPurchasedTimeLbl01.text = [NSString stringWithFormat:@"%@.%@ (%@)", sMonth, sDay, sWeek];
    self.pPurchasedTimeLbl02.text = [NSString stringWithFormat:@"%@:%@", sHour, sMinute];
    self.pLicenseEndLbl.text = [NSString stringWithFormat:@"%@", [[CMAppManager sharedInstance] getLicenseEndDate:[dic objectForKey:@"licenseEnd"]]];
}

@end
