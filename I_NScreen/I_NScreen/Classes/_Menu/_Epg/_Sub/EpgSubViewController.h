//
//  EpgSubViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 14..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"
#import "EpgSubTableViewCell.h"
#import "CMSearchTableViewCell.h"
#import "CMDateScrollView.h"

@interface EpgSubViewController : CMBaseViewController<EpgSubTableViewDelegate, CMDateScrollViewDelegate>

@end
