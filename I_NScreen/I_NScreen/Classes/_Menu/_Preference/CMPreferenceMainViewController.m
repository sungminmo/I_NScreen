//
//  CMPreferenceMainViewController.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 9. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMPreferenceMainViewController.h"
#import "CMDBDataManager.h"

static NSString* const CellIdentifier = @"preferenceMainCell";

@interface CMPreferenceMainViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UITableView* tableView;

@property (nonatomic, strong) NSArray* tableList;

//성인컨텐츠 제한관련 변수
@property (nonatomic, strong) UISwitch* switchButton;
@property (nonatomic, unsafe_unretained) BOOL isSwitchOn;


@end

@implementation CMPreferenceMainViewController

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self settingListData];
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CNMHandleOpenURLNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"설정";
    self.isUseNavigationBar = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CMPreferenceMainTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:CNMHandleOpenURLNotification
                                                      object:nil
                                                       queue:[NSOperationQueue currentQueue]
                                                  usingBlock:^(__unused NSNotification *note) {

                                                      NSDictionary *dic = note.object;
                                                      NSString* value = dic[@"result"];
                                                      if ([value isEqualToString:@"Y"]) {
                                                          //성인인증성공
//                                                          NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
//                                                          [ud setAdultCertYN:CMAdultCertificationSuccess];
//                                                          [ud synchronize];
                                                          
                                                          
                                                          //Application 관련 딜리게이트가 제대로 종료되도록 약간의 딜레이가 필요하다.
                                                          [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
                                                          
                                                          [[CMAppManager sharedInstance] setKeychainAdultCertification:YES];
                                                          
                                                          if (self.switchButton != nil) {
                                                              [self adultAuthorizationSuccessAfterEventWithSwitchButton:self.switchButton value:self.isSwitchOn];
                                                          }

                                                          //화면갱신 
                                                          [self settingListData];
                                                          [self.tableView reloadData];
                                                      }
                                                      
                                                  }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private


- (void)settingListData {
    
    //1. 지역설정 가져오기
    CMDBDataManager* manager = [CMDBDataManager sharedInstance];
    CMAreaInfo* info = [manager currentAreaInfo];
    NSString* areaDesc = [NSString stringWithFormat:@"TV시청지역 : %@", info.areaName];
    
    //2. 성인인증 여부
    NSString* addDesc = @"성인인증이 필요합니다.";
    if ( [[CMAppManager sharedInstance] getKeychainAdultCertification] == YES )
    {
        addDesc = @"성인인증 되셨습니다.";
    }
    
    self.tableList = @[@{@"type":@(INFO_PREFERENCE_MAIN_CELL_TYPE)},
                       @{@"type":@(SETTING_PREFERENCE_MAIN_CELL), @"class":@"CMRegionSettingViewController", @"icon":@(true), @"title":@"지역설정", @"addedInfo":areaDesc, @"attributedString":@{@"target":@":", @"color":[CMColor colorViolet]}},
                       @{@"type":@(SETTING_PREFERENCE_MAIN_CELL), @"class":@"CMPurchaseCertPasswordViewController", @"icon":@(true), @"title":@"구매인증 비밀번호 관리"},
                       @{@"type":@(SETTING_PREFERENCE_MAIN_CELL), @"icon":@(true), @"title":@"성인검색 제한설정", @"switchEvent":^(UISwitch* swButton, NSIndexPath* indexPath, BOOL isOn){[self switchEventAtIndexPath:indexPath switchButton:swButton value:isOn];}},
                       @{@"type":@(SETTING_PREFERENCE_MAIN_CELL), @"class":@"CMAdultAuthViewController", @"icon":@(true), @"title":@"성인인증", @"addedInfo":addDesc, @"attributedString":@{@"color":[UIColor redColor]}},
                       @{@"type":@(SETTING_PREFERENCE_MAIN_CELL), @"class":@"CMNoticeListViewController", @"title":@"공지사항"},
                       @{@"type":@(SETTING_PREFERENCE_MAIN_CELL), @"class":@"CMPaytvListViewController", @"title":@"유료채널 안내"},
                       @{@"type":@(SETTING_PREFERENCE_MAIN_CELL), @"class":@"CMContactInfoViewCcontroller", @"title":@"고객센터 안내"}];
}

#pragma mark - Event
- (void)adultAuthorizationSuccessAfterEventWithSwitchButton:(UISwitch*)swButton value:(BOOL)isOn {

    [[CMAppManager sharedInstance] setKeychainAdultLimit:!isOn];

    self.switchButton = nil;
    self.isSwitchOn = isOn;
}


- (void)switchEventAtIndexPath:(NSIndexPath*)indexPath switchButton:(UISwitch*)swButton value:(BOOL)isOn {
    
    if ( [[CMAppManager sharedInstance] getKeychainAdultCertification] == YES ) {
        [self adultAuthorizationSuccessAfterEventWithSwitchButton:swButton value:isOn];
        [self settingListData];
        [self.tableView reloadData];
    }
    else {
        Class class = NSClassFromString(@"CMAdultAuthViewController");
        CMBaseViewController* controller = (CMBaseViewController*)[[class alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        
        self.switchButton = swButton;
        self.isSwitchOn = isOn;
    }
}

#pragma mark - UITablevewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tableList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CMPreferenceMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary* dic = self.tableList[indexPath.row];
    
    
    [cell setCellType:[dic[@"type"] integerValue] indexPath:indexPath icon:[dic[@"icon"] boolValue] title:dic[@"title"] addedInfo:dic[@"addedInfo"] addedAttribute:dic[@"attributedString"] switchEvent:dic[@"switchEvent"]];
    
    return cell;
}

#pragma mark - UITableVewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    NSString* className = self.tableList[indexPath.row][@"class"];
    
    if (className) {
        
        if ([className isEqualToString:@"CMPurchaseCertPasswordViewController"]) {
            //  add alertView
            
            Class class = NSClassFromString(className);
            
            CMBaseViewController* controller = (CMBaseViewController*)[[class alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
        else if ([className isEqualToString:@"CMAdultAuthViewController"]) {//성인인증이 된상태면 건너뜀
            
            if ( [[CMAppManager sharedInstance] getKeychainAdultCertification] == YES ) {
                return;
            }
            
            Class class = NSClassFromString(className);
            
            CMBaseViewController* controller = (CMBaseViewController*)[[class alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
        else {
            Class class = NSClassFromString(className);
            
            CMBaseViewController* controller = (CMBaseViewController*)[[class alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

@end
