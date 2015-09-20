//
//  CMTabMenuView.h
//  I_NScreen
//
//  Created by bjm on 2015. 9. 20..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMTabMenuViewDelegate;

@interface CMTabMenuView : UIView

@property (nonatomic, weak) id<CMTabMenuViewDelegate> delegate;

- (instancetype)initWithMenuArray:(NSArray*)menuArray posY:(float)posY delegate:(id<CMTabMenuViewDelegate>)delegate;

- (NSInteger)getTabMenuIndex;
- (void)selectTabMenu:(NSInteger)index;

@end

@protocol CMTabMenuViewDelegate <NSObject>

- (void)tabMenu:(CMTabMenuView *)sender didSelectedTab:(NSInteger)tabIndex;

@end