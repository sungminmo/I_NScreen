//
//  LeftMenuViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 11..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "UIView+Layer.h"
#import "CMTermsViewController.h"
#import "CMVersionViewController.h"

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController
@synthesize delegate;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.upperView clearSubOutLineLayers];
    [self.bottomView clearSubOutLineLayers];
    
    [UIView setOuterLine:self.upperView direction:HMOuterLineDirectionTop|HMOuterLineDirectionBottom lineWeight:1 lineColor:[UIColor colorWithHexString:@"ffffff"]];
    [UIView setOuterLine:self.bottomView direction:HMOuterLineDirectionTop lineWeight:1 lineColor:[UIColor colorWithHexString:@"ffffff"]];
    
}

#pragma mark - ui change
- (void)changePairingCondition:(BOOL)isPairing {
    if (isPairing == NO) {
        self.pairingImageView.image = [UIImage imageNamed:@"icon_pairing_before.png"];
        [self.pairingButton setTitle:@"셋탑박스 연동하기" forState:UIControlStateNormal];
        self.pairingButton.selected = NO;
        self.pairingMessageLabel.text = @"원할한 서비스 이용을 위해\n셋탑박스를 연동해주세요.";
    }
    else {
        self.pairingImageView.image = [UIImage imageNamed:@"icon_pairing_after.png"];
        [self.pairingButton setTitle:@"셋탑박스 재연동 " forState:UIControlStateNormal];
        self.pairingButton.selected = YES;
        self.pairingMessageLabel.text = @"셋탑박스와 연동중입니다.";
    }
    
    
    // 연동 화면
    [[CMAppManager sharedInstance] onLeftMenuListClose:self];
    self.nTag = 6;
    
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

- (IBAction)actionTermsButton:(id)sender {
    CMTermsViewController *controller = [[CMTermsViewController alloc] initWithNibName:@"CMTermsViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)actionVersionButton:(id)sender {
    CMVersionViewController *controller = [[CMVersionViewController alloc] initWithNibName:@"CMVersionViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
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
    
    if (indexPath.row == 1) {//리모컨
        if (NO) {//TODO: 서비스 미가입고객여부 체크해서 조건 수정할 것
            [SIAlertView alert:@"안내" message:@"현재 가입하신 상품으로는 이용할 수 없는\n서비스 기능입니다. 가입상품을 확인해주세요."];
            return;
        }
    }
    
    [[CMAppManager sharedInstance] onLeftMenuListClose:self];
    self.nTag = (int)[indexPath row] + 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
