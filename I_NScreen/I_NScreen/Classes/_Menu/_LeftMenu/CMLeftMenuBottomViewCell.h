//
//  CMLeftMenuBottomViewCell.h
//  I_NScreen
//
//  Created by 조백근 on 2015. 11. 20..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLeftMenuBottomViewCell : UITableViewCell
@property (weak, nonatomic) UINavigationController* navigation;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *termsButton;
@property (weak, nonatomic) IBOutlet UIView *versionButton;
@end
