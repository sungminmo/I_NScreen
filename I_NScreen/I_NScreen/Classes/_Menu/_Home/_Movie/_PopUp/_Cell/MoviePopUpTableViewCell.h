//
//  MoviePopUpTableViewCell.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 13..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviePopUpTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *pTitleLbl;
@property (nonatomic, weak) IBOutlet UIImageView *pArrowImgView;

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index WithOpen:(BOOL)isOpen;

@end
