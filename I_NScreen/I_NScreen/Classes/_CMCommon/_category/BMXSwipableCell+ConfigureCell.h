//
//  BMXSwipableCell+ConfigureCell.h
//  I_NScreen
//
//  Created by kimts on 2015. 10. 11..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "BMXSwipableCell.h"

@interface BMXSwipableCell (ConfigureCell)

- (void)configureCellForItem:(NSDictionary*)item;

- (void)configureCellForItem:(NSDictionary *)item WithItemCount:(int)nCount;

@end
