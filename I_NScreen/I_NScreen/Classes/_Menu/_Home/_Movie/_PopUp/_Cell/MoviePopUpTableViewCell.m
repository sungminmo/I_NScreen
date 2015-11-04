//
//  MoviePopUpTableViewCell.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 13..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "MoviePopUpTableViewCell.h"

@implementation MoviePopUpTableViewCell
@synthesize pTitleLbl, pArrowImgView;
@synthesize delegate;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index WithOpen:(BOOL)isOpen
{
    self.pDic = [[NSDictionary alloc] init];
    self.pDic = dic;
    
    if ( [[dic objectForKey:@"leaf"] isEqualToString:@"0"] )
    {
        
        if ( isOpen == NO )
        {
            pArrowImgView.image = [UIImage imageNamed:@"icon_2depth_close.png"];
        }
        else
        {
            pArrowImgView.image = [UIImage imageNamed:@"icon_2depth_open.png"];
        }
    }
    else
    {
        pArrowImgView.image = [UIImage imageNamed:@""];
    }
    
    
    pTitleLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"categoryName"]];
}

- (IBAction)onBtnClicked:(UIButton *)btn
{
    [self.delegate MoviePopUpTableViewCellData:self.pDic];
}

@end
