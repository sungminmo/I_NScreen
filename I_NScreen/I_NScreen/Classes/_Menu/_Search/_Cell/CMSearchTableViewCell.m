//
//  CMSearchTableViewCell.m
//  I_NScreen
//
//  Created by kimteaksoo on 2015. 10. 1..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMSearchTableViewCell.h"

@interface CMSearchTableViewCell ()

@property (nonatomic, strong) IBOutlet UIView* lineView;
@end

@implementation CMSearchTableViewCell

- (void)awakeFromNib {

    self.lineView.backgroundColor = [CMColor colorTableSeparator];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
