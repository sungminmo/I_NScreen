//
//  RemoconMainTableViewCell.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "RemoconMainTableViewCell.h"
#import "CMProgressView.h"

@interface RemoconMainTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *topLineView;
@property (nonatomic, strong) IBOutlet UIImageView *pStarImageView; // 별표
@property (nonatomic, strong) IBOutlet UIImageView *pChannelLogoImageView;  // 체널 로그 이미지 뷰
@property (nonatomic, strong) IBOutlet UIImageView *pAllImageView;
@property (nonatomic, strong) IBOutlet UIImageView *pHdImageView;

@property (nonatomic, strong) IBOutlet UILabel *pChannelLbl;
@property (nonatomic, strong) IBOutlet UILabel *pTitleLbl;
@property (nonatomic, strong) IBOutlet UILabel *pTimeLbl;
@property (strong, nonatomic) IBOutlet CMProgressView *progressView;

@end

@implementation RemoconMainTableViewCell

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
        self.topLineView.hidden = YES;
    }
    else
    {
        self.topLineView.hidden = NO;
    }
    
    self.pChannelLbl.text = [NSString stringWithFormat:@"%d", index];
    self.pTitleLbl.text = [NSString stringWithFormat:@"뉴스파이터asdflkajslfkjasdlfkj %d", index];
    
    self.pAllImageView.hidden = index%2 == 0 ? true : false;
    self.pHdImageView.hidden = index%2 == 0 ? true : false;
    
    [self.progressView setProgressRatio:.5 animated:YES];
}

@end
