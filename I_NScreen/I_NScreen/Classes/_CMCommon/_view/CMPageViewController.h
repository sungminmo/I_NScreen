//
//  CMPageViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 15..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMPageViewDelegate;

@interface CMPageViewController : UIViewController

@property (nonatomic, weak) id <CMPageViewDelegate>delegate;
@property (nonatomic, strong) IBOutlet UIImageView *pImageView;
@property (nonatomic, strong) IBOutlet UIImageView *pBgImageView;

- (id)initWithData:(NSDictionary *)dic WithPage:(int)page;

@end

@protocol CMPageViewDelegate <NSObject>

@optional
- (void)CMPageViewWithPage:(int)page;
- (void)CMPageViewWithAssetId:(NSString *)sAssetId;

@end