//
//  CMSearchMainViewController.h
//  I_NScreen
//
//  Created by 조백근 on 2015. 9. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMBaseViewController.h"
#import "CMTabMenuView.h"
#import "CMTextField.h"
#import "CMSearchTableViewCell.h"

@interface CMSearchMainViewController : CMBaseViewController <CMTabMenuViewDelegate, CMSearchTableViewDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>

@end
