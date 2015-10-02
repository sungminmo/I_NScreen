//
//  CMAutoCompletTableViewCell.h
//  I_NScreen
//
//  Created by 조백근 on 2015. 10. 1..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AutoCompletCloseEvent)(NSIndexPath* indexPath);

@interface CMAutoCompletTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath* indexPath;
@property (nonatomic, copy) AutoCompletCloseEvent autoCompletCloseEvent;

- (void)setTitle:(NSString*)title;

@end
