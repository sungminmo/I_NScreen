//
//  CMPageCollectionViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 16..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPageCollectionViewCell.h"

@protocol CMPageCollectionViewDelegate;

@interface CMPageCollectionViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, CMPageCollectionViewCellDelegate>

@property (nonatomic, weak) id <CMPageCollectionViewDelegate>delegate;
@property (nonatomic, weak) IBOutlet UICollectionView *pCollectionView;

- (id)initWithData:(NSArray *)arr WithPage:(int)page;

@end

@protocol CMPageCollectionViewDelegate <NSObject>

@optional
- (void)CMPageCollectionBtnClicked:(int)nSelect WithAssetId:(NSString *)assetId;

@end