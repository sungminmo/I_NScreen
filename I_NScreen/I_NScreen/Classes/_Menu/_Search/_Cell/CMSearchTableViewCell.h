//
//  CMSearchTableViewCell.h
//  I_NScreen
//
//  Created by 조백근 on 2015. 10. 1..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BMXSwipableCell/BMXSwipableCell.h>

@protocol CMSearchTableViewDelegate;

@interface CMSearchTableViewCell : BMXSwipableCell

@property (nonatomic, weak) id <CMSearchTableViewDelegate>delegate2;
- (void)setData:(NSDictionary*)data WithIndex:(int)nIndex WithStar:(BOOL)isStar;

@end

@protocol CMSearchTableViewDelegate <NSObject>

@optional
- (void)CMSearchTableViewCellTag:(int)nTag;

@end