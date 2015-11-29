//
//  MainPopUpTableView2thOpenCell.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 11. 10..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "MainPopUpTableView2thOpenCell.h"

@implementation MainPopUpTableView2thOpenCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index WithOpen:(BOOL)isOpen
{
    self.pDic = [dic copy];
    
    self.pTwoDepthOpneLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"categoryName"]];
}

- (IBAction)onBtnClicked:(UIButton *)btn {
    [self.delegate MainPopUpTableViewCellData:self.pDic];
}

@end
