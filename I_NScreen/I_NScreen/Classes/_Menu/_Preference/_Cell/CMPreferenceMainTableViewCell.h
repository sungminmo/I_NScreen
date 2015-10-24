//
//  CMPreferenceMainTableViewCell.h
//  I_NScreen
//
//  Created by 조백근 on 2015. 9. 29..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    INFO_PREFERENCE_MAIN_CELL_TYPE,
    SETTING_PREFERENCE_MAIN_CELL
} PREFERENCE_MAIN_CELL_TYPE;

typedef void(^PreferenceSwitchEvent)(UISwitch* swButton, NSIndexPath* indexPath, BOOL isOn);

@interface CMPreferenceMainTableViewCell : UITableViewCell

@property (nonatomic, copy) PreferenceSwitchEvent preferenceSwitchEvent;

- (void)setCellType:(PREFERENCE_MAIN_CELL_TYPE)type
          indexPath:(NSIndexPath*)indexPath
               icon:(BOOL)isIcon
              title:(NSString*)title
          addedInfo:(NSString*)addedInfo
     addedAttribute:(NSDictionary*)addedAttribute
             switchEvent:(PreferenceSwitchEvent)switchEvent;
@end
