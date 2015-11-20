//
//  LeftMenuViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 11..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "UIView+Layer.h"
#import "FXKeychain.h"
#import "CMDBDataManager.h"
#import "CMLeftMenuBottomViewCell.h"

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController
@synthesize delegate;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib* nib;
    nib = [UINib nibWithNibName:@"CMLeftMenuBottomViewCell" bundle:nil];
    [self.pTableView registerNib:nib forCellReuseIdentifier:@"bottomCell"];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 앱 버전 라벨
    NSString *sVerion = [NSString stringWithFormat:@"현재 버전 %@", [[CMAppManager sharedInstance] getAppVersion]];
    [self.pVerionBtn setTitle:sVerion forState:UIControlStateNormal];
    
    [self.upperView clearSubOutLineLayers];
    
    [UIView setOuterLine:self.upperView direction:HMOuterLineDirectionTop|HMOuterLineDirectionBottom lineWeight:1 lineColor:[UIColor colorWithHexString:@"ffffff"]];

 
//    if ( [[CMAppManager sharedInstance] getInfoData:CNM_OPEN_API_UUID_KEY] == NULL )
    CMDBDataManager *manager = [CMDBDataManager sharedInstance];
    if ( [manager getPairingCheck] == NO )
    {
        // UUID 값이 없으면
        self.pairingImageView.image = [UIImage imageNamed:@"icon_pairing_before.png"];
        [self.pairingButton setTitle:@"셋탑박스 연동하기" forState:UIControlStateNormal];
        self.pairingButton.selected = NO;
        self.pairingMessageLabel.text = @"원할한 서비스 이용을 위해\n셋탑박스를 연동해주세요.";
    }
    else
    {
        // UUID 값이 있으면
        self.pairingImageView.image = [UIImage imageNamed:@"icon_pairing_after.png"];
        [self.pairingButton setTitle:@"셋탑박스 재 연동 " forState:UIControlStateNormal];
        self.pairingButton.selected = YES;
        self.pairingMessageLabel.text = @"셋탑박스와 연동중입니다.";
    }
}

#pragma mark - ui change
- (void)changePairingCondition:(BOOL)isPairing {
//    if (isPairing == NO) {
//        self.pairingImageView.image = [UIImage imageNamed:@"icon_pairing_before.png"];
//        [self.pairingButton setTitle:@"셋탑박스 연동하기" forState:UIControlStateNormal];
//        self.pairingButton.selected = NO;
//        self.pairingMessageLabel.text = @"원할한 서비스 이용을 위해\n셋탑박스를 연동해주세요.";
//    }
//    else {
//        self.pairingImageView.image = [UIImage imageNamed:@"icon_pairing_after.png"];
//        [self.pairingButton setTitle:@"셋탑박스 재연동 " forState:UIControlStateNormal];
//        self.pairingButton.selected = YES;
//        self.pairingMessageLabel.text = @"셋탑박스와 연동중입니다.";
//    }
    
//        if ( [[[FXKeychain defaultKeychain] objectForKey:CNM_OPEN_API_UUID_KEY] length] != 0 ) 일단 테스트라 USERDEFAULT 에 저장하고 나중에 수정

    CMDBDataManager* manager= [CMDBDataManager sharedInstance];
    
    if ( [manager getPairingCheck] == YES )
    {
        // 페어링이 되어 있으면
        self.pairingImageView.image = [UIImage imageNamed:@"icon_pairing_after.png"];
        [self.pairingButton setTitle:@"셋탑박스 재 연동 " forState:UIControlStateNormal];
        self.pairingButton.selected = YES;
        self.pairingMessageLabel.text = @"셋탑박스와 연동중입니다.";

        [SIAlertView alert:@"셋탑박스 재 연동" message:@"셋탑박스 재 연동 시 기존 연동은 해제 되며,\n구매 비밀번호 재설정이 필요합니다.\n\n계속 진행하시겠습니까?"
                    cancel:@"취소"
                   buttons:@[@"확인"]
                completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                    if ( buttonIndex == 1 )
                    {
                        // 연동 화면
                        [[CMAppManager sharedInstance] onLeftMenuListClose:self];
                        self.nTag = 6;
                    }
                }];
    }
    else
    {
        // 페어링이 안되어 있으면
        self.pairingImageView.image = [UIImage imageNamed:@"icon_pairing_before.png"];
        [self.pairingButton setTitle:@"셋탑박스 연동하기" forState:UIControlStateNormal];
        self.pairingButton.selected = NO;
        self.pairingMessageLabel.text = @"원할한 서비스 이용을 위해\n셋탑박스를 연동해주세요.";

        // 연동 화면
        [[CMAppManager sharedInstance] onLeftMenuListClose:self];
        self.nTag = 6;
    }
    
    ///
}


#pragma mark - 클릭 이벤트
#pragma mark - 버튼 클릭 이벤트
- (IBAction)onCloseBtnClick:(id)sender
{
    self.nTag = 0;
    
    [[CMAppManager sharedInstance] onLeftMenuListClose:self];
}

- (IBAction)actionPairingButton:(id)sender {
    BOOL selected = ((UIButton*)sender).isSelected;
    [self changePairingCondition:!selected];
}


- (IBAction)actionPairingGuide:(id)sender {
    NSString* title = @"셋탑박스 연동이란?";
    NSString* message = @"\nC&M 방송 서비스를 이용하고 계시는\n 고객님의 셋탑박스와 모바일 앱을 연동하여\n VOD 구매, 방송 시청 예약 등\n다양한 서비스를 이용하실 수 있습니다.\n\n";
    [SIAlertView alert:title message:message button:nil];
}

- (void)onLeftMenuCloseComplet
{
    if ( [self.delegate respondsToSelector:@selector(onLeftMenuViewCloseCompletReflash:)] )
    {
        [self.delegate onLeftMenuViewCloseCompletReflash:self.nTag];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.row != 5) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        }
        
        switch (indexPath.row) {
            case 0:
            {
                cell.imageView.image = [UIImage imageNamed:@"icon_menu_chguide.png"];
                cell.textLabel.text = @"채널가이드";
            }break;
            case 1:
            {
                cell.imageView.image = [UIImage imageNamed:@"icon_menu_remotecontrol.png"];
                cell.textLabel.text = @"리모컨";
            }break;
            case 2:
            {
                cell.imageView.image = [UIImage imageNamed:@"icon_menu_recording.png"];
                cell.textLabel.text = @"녹화";
            }break;
            case 3:
            {
                cell.imageView.image = [UIImage imageNamed:@"icon_menu_myc_m.png"];
                cell.textLabel.text = @"MY C&M";
            }break;
            case 4:
            {
                cell.imageView.image = [UIImage imageNamed:@"icon_menu_setting.png"];
                cell.textLabel.text = @"설정";
            }break;
                //        case 5://TODO: 임시 나중에 제거
                //        {
                //            cell.imageView.image = [UIImage imageNamed:@"icon_menu_remotecontrol.png"];
                //            cell.textLabel.text = @"검색";
                //        }break;
        }
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"bottomCell"];
        
        if(cell == nil) {
            cell = [[CMLeftMenuBottomViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bottomCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        }
        
        ((CMLeftMenuBottomViewCell*)cell).navigation = self.navigationController;
    }
    
    return cell;
    
}

static NSInteger ivTag = 1212;
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_pres.png"]];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    iv.frame = cell.bounds;
    iv.tag = ivTag;
    [cell.contentView addSubview:iv];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView* iv = (UIImageView* )[cell.contentView viewWithTag:ivTag];
    if (iv) {
        [iv removeFromSuperview];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 리모컨은 pvr hd 이외엔 막고, 녹화는 pvr 이외만 막고, my c&m 은 페어링안되어 있을때만 막음
    CMDBDataManager* manager= [CMDBDataManager sharedInstance];
    
    if (indexPath.row == 1) {//리모컨
//        if (NO) {//TODO: 서비스 미가입고객여부 체크해서 조건 수정할 것
//            [SIAlertView alert:@"안내" message:@"현재 가입하신 상품으로는 이용할 수 없는\n서비스 기능입니다. 가입상품을 확인해주세요."];
//            return;
//        }
        // 리모컨 상태 체크
        // 페어링이 안됬으면 진입 불가, HD, PVR 이 아니면 진입 불가
       
        if ( [manager getPairingCheck] == NO )
        {
            [SIAlertView alert:@"리모컨 미 지원 상품" message:@"리모콘 기능은 HD/PVR 셋탑박스와 연동 시에만\n사용하실 수 있습니다."];
            return;
        }
        else
        {
//            if ( !([[[CMAppManager sharedInstance] getInfoData:CNM_OPEN_API_SET_TOP_BOK_KIND] isEqualToString:@"PVR"] ||
//                   [[[CMAppManager sharedInstance] getInfoData:CNM_OPEN_API_SET_TOP_BOK_KIND] isEqualToString:@"HD"] ))
            if ( !([[manager getSetTopBoxKind] isEqualToString:@"PVR"] ||
                   [[manager getSetTopBoxKind] isEqualToString:@"HD"] ))
            {
                [SIAlertView alert:@"리모컨 미 지원 상품" message:@"리모콘 기능은 HD/PVR 셋탑박스와 연동 시에만\n사용하실 수 있습니다."];
                return;
            }
        }
        
    }
    
    else if (indexPath.row == 2) {//녹화

        if ( [manager getPairingCheck] == NO )
        {
            [SIAlertView alert:@"녹화 미 지원 상품" message:@"녹화 기능은 PVR 셋탑박스와 연동 시에만 사용하실 수 있습니다."];
             return;
        }
        else
        {
            if ( ![[manager getSetTopBoxKind] isEqualToString:@"PVR"] )
            {
                [SIAlertView alert:@"녹화 미 지원 상품" message:@"녹화 기능은 PVR 셋탑박스와 연동 시에만 사용하실 수 있습니다."];
                return;
            }
        }
    }
    
    else if ( indexPath.row == 3 ) // my c&m
    {
        if ( [manager getPairingCheck] == NO )
        {
            [SIAlertView alert:@"마이 C&M 미 지원 상품" message:@"마이 C&M은 셋탑박스와 연동 시에만\n사용하실 수 있습니다."];
            return;
        }
    }
    
    [[CMAppManager sharedInstance] onLeftMenuListClose:self];
    self.nTag = (int)[indexPath row] + 1;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        return 125.f;
    }
    return 60.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
