//
//  RemoconMainTableViewCell.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemoconMainTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *pStarImageView; // 별표
@property (nonatomic, strong) IBOutlet UIImageView *pChannelImageView;

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index;

@end
