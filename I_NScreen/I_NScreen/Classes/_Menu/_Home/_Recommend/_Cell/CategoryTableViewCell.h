//
//  CategoryTableViewCell.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 20..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPageCollectionViewController.h"

@interface CategoryTableViewCell : UITableViewCell<UIScrollViewDelegate, CMPageCollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *pViewController;
@property (nonatomic, strong) IBOutlet UIScrollView *pScrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pPageCtrl;


- (void)setListData:(NSDictionary *)dic WithIndex:(int)index;

@end
