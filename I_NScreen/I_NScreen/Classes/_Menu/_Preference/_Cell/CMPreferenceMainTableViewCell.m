//
//  CMPreferenceMainTableViewCell.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 9. 29..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMPreferenceMainTableViewCell.h"
#import "CMBaseViewController.h"

@interface CMPreferenceMainTableViewCell ()

@property (nonatomic, strong) IBOutlet UIView* infoView;
@property (nonatomic, strong) IBOutlet UIView* settingView;

@property (nonatomic, strong) NSIndexPath* indexPath;
@property (nonatomic, strong) IBOutlet UIButton* preIconButton;
@property (nonatomic, strong) IBOutlet UILabel* titleLabel;
@property (nonatomic, strong) IBOutlet UILabel* addedInfoLabel;
@property (nonatomic, strong) IBOutlet UIImageView* indicatorImageView;
@property (nonatomic, strong) IBOutlet UISwitch* switchButton;

@property (nonatomic, unsafe_unretained) BOOL isSwitchWorking;

@end

@implementation CMPreferenceMainTableViewCell

- (void)awakeFromNib {

    self.switchButton.tintColor = [CMColor colorViolet];
    self.switchButton.onTintColor = [CMColor colorViolet];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellType:(PREFERENCE_MAIN_CELL_TYPE)type
          indexPath:(NSIndexPath*)indexPath
               icon:(BOOL)isIcon
              title:(NSString*)title
          addedInfo:(NSString*)addedInfo
     addedAttribute:(NSDictionary*)addedAttribute
        switchEvent:(PreferenceSwitchEvent)switchEvent {
    
    self.indexPath = indexPath;
    
    self.infoView.hidden = true;
    self.settingView.hidden = true;
    
    if (INFO_PREFERENCE_MAIN_CELL_TYPE == type) {
        
        self.infoView.hidden = false;
        
    } else if (SETTING_PREFERENCE_MAIN_CELL == type) {
        
        self.settingView.hidden = false;
        
        self.preIconButton.hidden = !isIcon;
        self.titleLabel.text = title;
        
        if (addedInfo) {
            self.addedInfoLabel.text = addedInfo;
        } else {
            self.addedInfoLabel.text = @"";
        }
        
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.addedInfoLabel.attributedText];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, self.addedInfoLabel.text.length)];
        
        if (addedAttribute) {
            if (addedAttribute[@"target"] && addedAttribute[@"color"]) {
                
                NSRange targetRange = [self.addedInfoLabel.text rangeOfString:addedAttribute[@"target"]];
                [attributedString addAttribute:NSForegroundColorAttributeName value:addedAttribute[@"color"] range:NSMakeRange(targetRange.location + 1, self.addedInfoLabel.text.length - targetRange.location - 1)];
                
            } else if (addedAttribute[@"color"]) {
                [attributedString addAttribute:NSForegroundColorAttributeName value:addedAttribute[@"color"] range:NSMakeRange(0, self.addedInfoLabel.text.length)];
            }
        }
        
        self.addedInfoLabel.attributedText = attributedString;
        
        self.preferenceSwitchEvent = switchEvent;
        if (switchEvent) {
            self.indicatorImageView.hidden = true;
            self.switchButton.hidden = false;
            
//            NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
//            CMContentsRestrictedType type = [ud restrictType];
//            BOOL isRestricted = type==CMContentsRestrictedTypeAdult?YES:NO;
            BOOL isRestricted = [[CMAppManager sharedInstance] getKeychainAdultLimit];
            self.switchButton.on = isRestricted;
            
        } else {
            self.indicatorImageView.hidden = false;
            self.switchButton.hidden = true;
        }
    }
}

- (IBAction)actionCellGuide:(id)sender {
    NSString* title = self.titleLabel.text;
    if ([title isEqualToString:@"지역설정"]) {
        [CMBaseViewController actionGuide:100];
    }
    else if ([title isEqualToString:@"구매인증 비밀번호 관리"]) {
        [CMBaseViewController actionGuide:101];
    }
    else if ([title isEqualToString:@"성인검색 제한설정"]) {
        [CMBaseViewController actionGuide:102];
    }
    else if ([title isEqualToString:@"성인인증"]) {
        [CMBaseViewController actionGuide:103];
    }

}

- (IBAction)buttonWasTouchUpInside:(id)sender {
    
    if (self.preferenceSwitchEvent) {
        
        if (self.isSwitchWorking == YES) {
            return;
        }
        
        BOOL isOn = self.switchButton.isOn;
        if (isOn == NO) {//성인인증제한 설정 해재 필요
            self.isSwitchWorking = YES;
            
            if ( [[CMAppManager sharedInstance] getKeychainAdultCertification] == YES ){
                self.preferenceSwitchEvent(self.switchButton, self.indexPath, NO/*컨텐츠 해제*/);
                return;
            }
                
            [SIAlertView alert:@"성인인증 필요" message:@"성인검색 제한 설정을 해제하기 위해서는\n성인인증이 필요합니다.\n\n성인인증을 진행하시겠습니까?" containBoldText:@"성인인증을 진행하시겠습니까?" cancel:@"아니요" buttons:@[@"예"] completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                if (buttonIndex == 1) {//성인인증 진행이동
                    self.preferenceSwitchEvent(self.switchButton, self.indexPath, NO);
                } else {
                    self.switchButton.on = YES;
                }
                self.isSwitchWorking = NO;
            }];
        }
        else {
//            NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
//            [ud setRestrictType:CMContentsRestrictedTypeAdult];
//            [ud synchronize];
            [[CMAppManager sharedInstance] setKeychainAdultLimit:NO];
        }

    }
}

@end
