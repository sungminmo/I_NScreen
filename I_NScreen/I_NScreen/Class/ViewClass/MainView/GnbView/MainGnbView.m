//
//  MainGnbView.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 8. 28..
//  Copyright (c) 2015년 JUNG KIL BAE. All rights reserved.
//

#import "MainGnbView.h"

@interface MainGnbView ()

@end

@implementation MainGnbView

#pragma mark - 뷰 초기화
//-(void)awakeFromNib
//{
////    self.backgroundColor= [UIColor yellowColor];
//}


- (id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] objectAtIndex:0];
    if (self) {
        //        [self.outletMenuTableView registerNib:[UINib nibWithNibName:@"GNBCellView" bundle:nil] forCellReuseIdentifier:[GNBCellView getCellIdentifier]];
      
    }
    return self;
}

@end
