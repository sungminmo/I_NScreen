//
//  MyCMBuyListTableViewCell.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 16..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "MyCMBuyListTableViewCell.h"

@implementation MyCMBuyListTableViewCell
@synthesize delegate;

- (void)awakeFromNib {
    // Initialization code
    
    self.pTitleLbl.font = [UIFont systemFontOfSize:CNM_DEFAULT_FONT_SIZE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index WithViewType:(int)viewType
{
    if ( index != 0 )
    {
        self.pLineImageView01.hidden = YES;
    }
    else
    {
        self.pLineImageView01.hidden = NO;
    }
    
    if ( viewType == MY_CM_MAIN_VIEW_BTN_02 )
    {
        // 구매목록
        // 결제 스티커
        NSString *sPaymentType = [NSString stringWithFormat:@"%@", [dic objectForKey:@"paymentType"]];
        
        if ( [sPaymentType isEqualToString:@"normal"] )
        {
            // 일반결제
            [self.pCouponImageView setImage:[UIImage imageNamed:@"icon_generalpay.png"]];
        }
        else if ( [sPaymentType isEqualToString:@"coupon"] )
        {
            // 쿠폰
            [self.pCouponImageView setImage:[UIImage imageNamed:@"icon_couponpay.png"]];
        }
        else if ( [sPaymentType isEqualToString:@"point"] )
        {
            // point
            [self.pCouponImageView setImage:[UIImage imageNamed:@"icon_tvpointpay.png"]];
        }
        else if ( [sPaymentType isEqualToString:@"complex"] )
        {
            // 복합 결제
            [self.pCouponImageView setImage:[UIImage imageNamed:@"icon_complexpay.png"]];
        }
        else
        {
            [self.pCouponImageView setImage:[UIImage imageNamed:@""]];
        }
        
        self.pTitleLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"productName"]]; // 타이틀
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
//        self.pLicenseEndLbl.text = [NSString stringWithFormat:@"%@", [[CMAppManager sharedInstance] getLicenseEndDate:[dic objectForKey:@"licenseEnd"]]];
        self.pLicenseEndLbl.text = [[CMAppManager sharedInstance] expiredDateStringWithPeriod:dic[@"viewablePeriod"] purchased:dic[@"purchasedTime"] state:dic[@"viewablePeriodState"]];

    }
    else if ( viewType == MY_CM_MAIN_VIEW_BTN_03 )
    {
        // 시청목록
        self.pTitleLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"title"]];
        
        NSString *sAddTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"date"]];
        NSArray *addTimeArr = [sAddTime componentsSeparatedByString:@" "];
        NSArray *addTimeArr2 = [[addTimeArr objectAtIndex:0] componentsSeparatedByString:@":"];
        NSArray *addTimeArr3 = [[addTimeArr objectAtIndex:1] componentsSeparatedByString:@":"];
        NSString *sAddTime2 = [NSString stringWithFormat:@"%@%@%@", [addTimeArr2 objectAtIndex:0], [addTimeArr2 objectAtIndex:1], [addTimeArr2 objectAtIndex:2]];
        
        NSString *sWeek = [NSString stringWithFormat:@"%@", [[CMAppManager sharedInstance] GetDayOfWeek:sAddTime2]];
        
        NSString *sMonth = [NSString stringWithFormat:@"%@", [addTimeArr2 objectAtIndex:1]];
        NSString *sDay = [NSString stringWithFormat:@"%@", [addTimeArr2 objectAtIndex:2]];
        
        NSString *sHour = [NSString stringWithFormat:@"%@", [addTimeArr3 objectAtIndex:0]];
        NSString *sMinute = [NSString stringWithFormat:@"%@", [addTimeArr3 objectAtIndex:1]];
        
        self.pPurchasedTimeLbl01.text = [NSString stringWithFormat:@"%@.%@ (%@)", sMonth, sDay, sWeek];
        self.pPurchasedTimeLbl02.text = [NSString stringWithFormat:@"%@:%@", sHour, sMinute];
        
        self.pLicenseEndLbl.hidden = YES;
        self.pPriceLbl.hidden = YES;
        self.pCouponImageView.hidden = YES;
    }
    else
    {
        // 찜목록
        self.pTitleLbl.text = [NSString stringWithFormat:@"%@", [[dic objectForKey:@"asset"] objectForKey:@"title"]];
        
        NSString *sAddTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"addTime"]];
        NSArray *addTimeArr = [sAddTime componentsSeparatedByString:@" "];
        NSArray *addTimeArr2 = [[addTimeArr objectAtIndex:0] componentsSeparatedByString:@"-"];
        NSArray *addTimeArr3 = [[addTimeArr objectAtIndex:1] componentsSeparatedByString:@":"];
        NSString *sAddTime2 = [NSString stringWithFormat:@"%@%@%@", [addTimeArr2 objectAtIndex:0], [addTimeArr2 objectAtIndex:1], [addTimeArr2 objectAtIndex:2]];
        
        NSString *sWeek = [NSString stringWithFormat:@"%@", [[CMAppManager sharedInstance] GetDayOfWeek:sAddTime2]];
        
        NSString *sMonth = [NSString stringWithFormat:@"%@", [addTimeArr2 objectAtIndex:1]];
        NSString *sDay = [NSString stringWithFormat:@"%@", [addTimeArr2 objectAtIndex:2]];
        
        NSString *sHour = [NSString stringWithFormat:@"%@", [addTimeArr3 objectAtIndex:0]];
        NSString *sMinute = [NSString stringWithFormat:@"%@", [addTimeArr3 objectAtIndex:1]];
        
        self.pPurchasedTimeLbl01.text = [NSString stringWithFormat:@"%@.%@ (%@)", sMonth, sDay, sWeek];
        self.pPurchasedTimeLbl02.text = [NSString stringWithFormat:@"%@:%@", sHour, sMinute];
//        self.pLicenseEndLbl.text = [NSString stringWithFormat:@"%@", [[CMAppManager sharedInstance] getLicenseEndDate:[[dic objectForKey:@"asset"] objectForKey:@"licenseEnd"]]];
        self.pLicenseEndLbl.text = [[CMAppManager sharedInstance] expiredDateStringWithPeriod:dic[@"asset"][@"viewablePeriod"] purchased:dic[@"asset"][@"purchasedTime"] state:dic[@"asset"][@"viewablePeriodState"]];

        
        self.pLicenseEndLbl.hidden = YES;
        self.pPriceLbl.hidden = YES;
        self.pCouponImageView.hidden = YES;
    }
    
}


@end
