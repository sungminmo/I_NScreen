//
//  CMLeftMenuBottomViewCell.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 11. 20..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMLeftMenuBottomViewCell.h"
#import "CMTermsViewController.h"
#import "CMVersionViewController.h"

@implementation CMLeftMenuBottomViewCell

- (void)awakeFromNib {
    [self.bottomView clearSubOutLineLayers];
    [UIView setOuterLine:self.bottomView direction:HMOuterLineDirectionTop lineWeight:1 lineColor:[UIColor colorWithHexString:@"ffffff"]];
    
    // 앱 버전 라벨
    NSString* ver = [CMAppManager getAppShortVersion];
    NSString* build = [CMAppManager getAppBuildVersion];

//#if DEBUG
    NSString *sVerion = [NSString stringWithFormat:@"버전 %@ (build ver. %@)", ver, build];
//#else
//    NSString *sVerion = [NSString stringWithFormat:@"버전 %@", ver];
//#endif
    
    [self.versionButton setTitle:sVerion forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)actionTermsButton:(id)sender {
    CMTermsViewController *controller = [[CMTermsViewController alloc] initWithNibName:@"CMTermsViewController" bundle:nil];
    [self.navigation pushViewController:controller animated:YES];
}

- (IBAction)actionVersionButton:(id)sender {
    /*!<
     앱 버전 정보 버튼 비활성화로 수정됨
     CMVersionViewController *controller = [[CMVersionViewController alloc] initWithNibName:@"CMVersionViewController" bundle:nil];
     [self.navigation pushViewController:controller animated:YES];
     */
}

@end
