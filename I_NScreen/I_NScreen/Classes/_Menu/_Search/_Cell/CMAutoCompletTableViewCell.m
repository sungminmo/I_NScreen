//
//  AutoCompletTableViewCell.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 10. 1..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMAutoCompletTableViewCell.h"

@interface CMAutoCompletTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel* titleLabel;
@property (nonatomic, weak) IBOutlet UIButton* closeButton;
@property (nonatomic, weak) IBOutlet UIView* lineView;

@end

@implementation CMAutoCompletTableViewCell

- (void)awakeFromNib {

    self.lineView.backgroundColor = [CMColor colorTableSeparator];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public

- (void)setTitle:(NSString*)title {
    self.titleLabel.text = title;
}

#pragma mark - Event

- (IBAction)buttonWasTouchUpInside:(id)sender {

    if (self.autoCompletCloseEvent && self.indexPath) {
        self.autoCompletCloseEvent(self.indexPath);
    }
}

@end
