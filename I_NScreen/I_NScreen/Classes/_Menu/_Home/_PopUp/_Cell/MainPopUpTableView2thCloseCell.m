//
//  MainPopUpTableView2thCloseCell.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 11. 10..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "MainPopUpTableView2thCloseCell.h"

@implementation MainPopUpTableView2thCloseCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index WithOpen:(BOOL)isOpen {
    self.pDic = [dic copy];
    self.pTwoDepthCloseLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"categoryName"]];
    
    NSString *sDepth = [NSString stringWithFormat:@"%@", dic[@"depth"]];
    if ([sDepth isEqualToString:@"0"]) {
        self.pTwoDepthCloseImg.hidden = NO;
    }
    else {
        self.pTwoDepthCloseImg.hidden = YES;
    }
}

- (IBAction)onBtnClicked:(UIButton *)btn {
    [self.delegate MainPopUpTableViewCellData:self.pDic];
}

@end
