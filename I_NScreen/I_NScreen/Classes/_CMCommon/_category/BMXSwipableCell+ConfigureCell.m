//
//  BMXSwipableCell+ConfigureCell.m
//  I_NScreen
//
//  Created by kimts on 2015. 10. 11..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "BMXSwipableCell+ConfigureCell.h"

@implementation BMXSwipableCell (ConfigureCell)

- (void)configureCellForItem:(NSDictionary*)item {
    
    CGFloat cellHeight = CGRectGetHeight(self.bounds);
    CGFloat x = self.basementVisibleWidth - cellHeight * 2;
    
    if (!self.basementConfigured) {
        
        UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        moreButton.backgroundColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0f];
        moreButton.frame = CGRectMake(x, 0, cellHeight, cellHeight);
        [moreButton setTitle: @"More" forState: UIControlStateNormal];
        [moreButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [moreButton addTarget: self
                       action: @selector(userPressedMoreButton:)
             forControlEvents: UIControlEventTouchUpInside];
        
        [self.basementView addSubview: moreButton];
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.backgroundColor = [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0f];
        deleteButton.frame = CGRectMake(x + cellHeight, 0, cellHeight, cellHeight);
        [deleteButton setTitle: @"Delete" forState: UIControlStateNormal];
        [deleteButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [deleteButton addTarget: self
                         action: @selector(userPressedDeleteButton:)
               forControlEvents: UIControlEventTouchUpInside];
        
        [self.basementView addSubview: deleteButton];
    }
    
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.bounds),  CGRectGetHeight(self.bounds));
    self.selectedBackgroundView = [[UIView alloc] initWithFrame: rect];
    self.selectedBackgroundView.backgroundColor = [UIColor yellowColor];
}

- (void)userPressedMoreButton:(id)sender
{
    NSLog(@"more");
}

- (void)userPressedDeleteButton:(id)sender
{
    NSLog(@"delete");
}

@end
