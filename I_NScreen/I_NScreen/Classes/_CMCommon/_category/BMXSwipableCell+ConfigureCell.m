//
//  BMXSwipableCell+ConfigureCell.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 10. 11..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "BMXSwipableCell+ConfigureCell.h"

@implementation BMXSwipableCell (ConfigureCell)

- (void)configureCellForItem:(NSDictionary*)item {
    
    CGFloat cellHeight = CGRectGetHeight(self.bounds);
    self.basementVisibleWidth = cellHeight * 2;
    CGFloat x = self.basementVisibleWidth - cellHeight * 2;
    
    if (!self.basementConfigured) {
        
        UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        moreButton.backgroundColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0f];
        moreButton.frame = CGRectMake(x, 0, cellHeight, cellHeight);
        [moreButton setTitle: @"More" forState: UIControlStateNormal];
        [moreButton.titleLabel setAdjustsFontSizeToFitWidth:true];
        [moreButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [moreButton addTarget: self
                       action: @selector(userPressedMoreButton:)
             forControlEvents: UIControlEventTouchUpInside];
        
        [self.basementView addSubview: moreButton];
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.backgroundColor = [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0f];
        deleteButton.frame = CGRectMake(x + cellHeight, 0, cellHeight, cellHeight);
        [deleteButton setTitle: @"Delete" forState: UIControlStateNormal];
        [deleteButton.titleLabel setAdjustsFontSizeToFitWidth:true];
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

- (void)configureCellForItem:(NSDictionary *)item WithItemCount:(int)nCount
{
    CGFloat cellHeight = CGRectGetHeight(self.bounds);
    self.basementVisibleWidth = cellHeight * 2;
    CGFloat x = self.basementVisibleWidth - cellHeight * 2;
    
    if (!self.basementConfigured) {
        
        if ( nCount == 2 )
        {
            NSString *sMore = [NSString stringWithFormat:@"%@", [item objectForKey:@"More"]];
            
            UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
            moreButton.backgroundColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0f];
            moreButton.frame = CGRectMake(x, 0, cellHeight, cellHeight);
            if ( sMore.length == 0 )
                sMore = @"More";
            [moreButton setTitle: sMore forState: UIControlStateNormal];
            [moreButton.titleLabel setAdjustsFontSizeToFitWidth:true];
            [moreButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
            [moreButton addTarget: self
                           action: @selector(userPressedMoreButton:)
                 forControlEvents: UIControlEventTouchUpInside];
            
            [self.basementView addSubview: moreButton];
        }
        
        if ( nCount == 2 || nCount == 1 )
        {
            NSString *sDelete = [NSString stringWithFormat:@"%@", [item objectForKey:@"Delete"]];

            UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteButton.backgroundColor = [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0f];
            deleteButton.frame = CGRectMake(x + cellHeight, 0, cellHeight, cellHeight);
            if ( sDelete.length == 0 )
                sDelete = @"Delete";
            [deleteButton setTitle:sDelete forState: UIControlStateNormal];
            [deleteButton.titleLabel setAdjustsFontSizeToFitWidth:true];
            [deleteButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
            [deleteButton addTarget: self
                             action: @selector(userPressedDeleteButton:)
                   forControlEvents: UIControlEventTouchUpInside];
            
            [self.basementView addSubview: deleteButton];
        }
       
    }
    
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.bounds),  CGRectGetHeight(self.bounds));
    self.selectedBackgroundView = [[UIView alloc] initWithFrame: rect];
    self.selectedBackgroundView.backgroundColor = [UIColor yellowColor];
}

- (void)userPressedMoreButton:(id)sender
{
    DDLogError(@"more");
}

- (void)userPressedDeleteButton:(id)sender
{
    DDLogError(@"delete");
}

@end
