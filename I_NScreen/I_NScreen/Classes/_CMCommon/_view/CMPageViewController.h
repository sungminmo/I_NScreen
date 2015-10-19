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

- (id)initWithData:(NSDictionary *)dic WithPage:(int)page WithFrame:(CGRect )cgRect;

@end

@protocol CMPageViewDelegate <NSObject>

@optional
- (void)CMPageViewWithPage:(int)page;

@end