//
//  MoviePopUpViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeListModel.h"
#import "MoviePopUpTableViewCell.h"

@interface MoviePopUpViewController : UIViewController

@property (nonatomic, strong) TreeListModel *pModel;
@property (nonatomic, strong) IBOutlet UITableView *pTableView;

@end
