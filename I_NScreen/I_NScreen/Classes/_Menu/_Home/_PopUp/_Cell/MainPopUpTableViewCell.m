//
//  MainPopUpTableViewCell.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 5..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "MainPopUpTableViewCell.h"

@implementation MainPopUpTableViewCell
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
    
    NSString *sLeaf = [NSString stringWithFormat:@"%@", [dic objectForKey:@"leaf"]];
    NSString *sDepth = [NSString stringWithFormat:@"depth"];
//    
//    if ( [[dic objectForKey:@"leaf"] isEqualToString:@"0"] )
//    {
//        
//        if ( isOpen == NO )
//        {
//            pArrowImgView.image = [UIImage imageNamed:@"icon_2depth_close.png"];
//        }
//        else
//        {
//            pArrowImgView.image = [UIImage imageNamed:@"icon_2depth_open.png"];
//        }
//    }
//    else
//    {
//        pArrowImgView.image = [UIImage imageNamed:@""];
//    }
//    
//    
//    pTitleLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"categoryName"]];
    
    if ( [sDepth isEqualToString:@"2"] )
    {
        // 2댑스
        if ( [sLeaf isEqualToString:@"0"] )
        {
            // 하위 댑스 있음
            if ( isOpen == NO )
            {
                // 닫힘
                self.pTwoDepthCloseView.hidden = NO;
                self.pTwoDepthCloseLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"categoryName"]];
            }
            else
            {
                // 열림
                self.pTwoDepthOpenView.hidden = NO;
                self.pTwoDepthOpneLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"categoryName"]];
            }
        }
        else
        {
            // 하위 댑스 없음
            self.pTwoDepthCloseView.hidden = NO;
            self.pTwoDepthCloseImg.hidden = YES;
            self.pTwoDepthCloseLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"categoryName"]];
        }
    }
    else if ( [sDepth isEqualToString:@"3"] )
    {
        // 3댑스
        if ( [sLeaf isEqualToString:@"0"] )
        {
            // 하위 댑스 있음
            if ( isOpen == NO )
            {
                // 닫힘
                self.pThreeDepthCloseView.hidden = NO;
                self.pThreeDepthCloseLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"categoryName"]];
                
            }
            else
            {
                // 열림
                self.pThreeDepthOpenView.hidden = NO;
                self.pThreeDepthOpenLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"categoryName"]];
            }
        }
        else
        {
            // 하위 댑스 없음
            self.pThreeDepthCloseView.hidden = NO;
            self.pThreeDepthCloseImg.hidden = YES;
            self.pThreeDepthCloseLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"categoryName"]];
        }
    }
    else
    {
        // 4댑스
        self.pFourDepthView.hidden = NO;
        self.pFourDepthLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"categoryName"]];
    }
    
}

- (IBAction)onBtnClicked:(UIButton *)btn
{
    [self.delegate MainPopUpTableViewCellData:self.pDic];
}

@end
