//
//  CMPreferenceMainTableViewCell.h
//  I_NScreen
//
//  Created by kimteaksoo on 2015. 9. 29..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    INFO_PREFERENCE_MAIN_CELL_TYPE,
    SETTING_PREFERENCE_MAIN_CELL
} PREFERENCE_MAIN_CELL_TYPE;

@interface CMPreferenceMainTableViewCell : UITableViewCell

- (void)setCellType:(PREFERENCE_MAIN_CELL_TYPE)type
               icon:(BOOL)isIcon
              title:(NSString*)title
          addedInfo:(NSString*)addedInfo
     addedAttribute:(NSDictionary*)addedAttribute
             switch:(BOOL)isSwitch;
@end
