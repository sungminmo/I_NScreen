//
//  CMContentGroupCollectionViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 29..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMContentGroupCollectionViewCell.h"

@protocol CMContentGroupCollectionViewDelegate;

@interface CMContentGroupCollectionViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, CMContentGroupCollectionViewCellDelegate>

@property (nonatomic, weak) id <CMContentGroupCollectionViewDelegate>delegate;
@property (nonatomic, weak) IBOutlet UICollectionView *pCollectionView;

- (id)initWithData:(NSArray *)arr WithPage:(int)page;

@end

@protocol CMContentGroupCollectionViewDelegate <NSObject>

@optional
- (void)CMContentGroupCollectionBtnClicked:(int)nSelect WithAssetId:(NSString *)assetId;

@end