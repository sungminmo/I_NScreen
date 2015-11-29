//
//  MainPopUpTableViewCell.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 5..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "MainPopUpTableViewCell.h"

@implementation MainPopUpTableViewCell

- (void)awakeFromNib {
    [self.pFourDepthLbl sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.pressEffectView.hidden = NO;
    }
}

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index WithOpen:(BOOL)isOpen {   
    self.pDic = [dic copy];
    
    // 4댑스
    self.pFourDepthView.hidden = NO;
    self.pFourDepthLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"categoryName"]];
 
}

- (IBAction)onBtnClicked:(UIButton *)btn {
    [self.delegate MainPopUpTableViewCellData:self.pDic];
}

@end
