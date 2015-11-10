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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index WithOpen:(BOOL)isOpen {
    
//    NSString *sLeaf = [NSString stringWithFormat:@"%@", [dic objectForKey:@"leaf"]];
//    NSString *sDepth = [NSString stringWithFormat:@"depth"];//4
    
    self.pDic = [dic copy];
    
    // 4댑스
    self.pFourDepthView.hidden = NO;
    self.pFourDepthLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"categoryName"]];
    
}

- (IBAction)onBtnClicked:(UIButton *)btn {
    [self.delegate MainPopUpTableViewCellData:self.pDic];
}

@end
