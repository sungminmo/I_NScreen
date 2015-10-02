//
//  AutoCompletTableViewCell.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 10. 1..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMAutoCompletTableViewCell.h"

@interface CMAutoCompletTableViewCell ()

@property (nonatomic, strong) IBOutlet UILabel* titleLabel;
@property (nonatomic, strong) IBOutlet UIButton* closeButton;

@end

@implementation CMAutoCompletTableViewCell

- (void)awakeFromNib {
    // Initialization code
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
