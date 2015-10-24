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

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (nonatomic, strong) IBOutlet UITableView* tableView;

@property (nonatomic, strong) NSArray* tableList;

@end

@implementation CMPreferenceMainViewController

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self settingListData];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"설정";
    self.isUseNavigationBar = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CMPreferenceMainTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private


- (void)settingListData {
    
    //1. 지역설정 가져오기
    CMDBDataManager* manager = [CMDBDataManager sharedInstance];
    CMAreaInfo* info = [manager currentAreaInfo];
    NSString* areaDesc = [NSString stringWithFormat:@"현재설정지역 : %@", info.areaName];
    
    self.tableList = @[@{@"type":@(INFO_PREFERENCE_MAIN_CELL_TYPE)},
                       @{@"type":@(SETTING_PREFERENCE_MAIN_CELL), @"class":@"CMRegionSettingViewController", @"icon":@(true), @"title":@"지역설정", @"addedInfo":areaDesc, @"attributedString":@{@"target":@":", @"color":[CMColor colorViolet]}},
                       @{@"type":@(SETTING_PREFERENCE_MAIN_CELL), @"class":@"CMPurchaseCertPasswordViewController", @"icon":@(true), @"title":@"구매인증 비밀번호 관리"},
                       @{@"type":@(SETTING_PREFERENCE_MAIN_CELL), @"icon":@(true), @"title":@"성인검색 제한설정", @"switchEvent":^(UISwitch* swButton, NSIndexPath* indexPath, BOOL isOn){[self switchEventAtIndexPath:indexPath switchButton:swButton value:isOn];}},
                       @{@"type":@(SETTING_PREFERENCE_MAIN_CELL), @"class":@"", @"icon":@(true), @"title":@"성인인증", @"addedInfo":@"성인인증이 필요합니다.", @"attributedString":@{@"color":[UIColor redColor]}},
                       @{@"type":@(SETTING_PREFERENCE_MAIN_CELL), @"class":@"CMNoticeListViewController", @"title":@"공지사항"},
                       @{@"type":@(SETTING_PREFERENCE_MAIN_CELL), @"class":@"CMPaytvListViewController", @"title":@"유료채널 안내"},
                       @{@"type":@(SETTING_PREFERENCE_MAIN_CELL), @"class":@"CMContactInfoViewCcontroller", @"title":@"고객센터 안내"}];
}

#pragma mark - Event

- (void)switchEventAtIndexPath:(NSIndexPath*)indexPath switchButton:(UISwitch*)swButton value:(BOOL)isOn {
    //TODO: 성인인증 제한해제 위한 성인인증 후 상태변경 처리 연동 필요
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    CMContentsRestrictedType type = isOn?CMContentsRestrictedTypeAdult:CMContentsRestrictedTypeNone;
    [ud setRestrictType:type];
    [ud synchronize];
    
    //성인인증 성공하면 변경
    @synchronized(self) {
        [swButton setOn:isOn animated:NO];
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
        } else {
            Class class = NSClassFromString(className);
            
            CMBaseViewController* controller = (CMBaseViewController*)[[class alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

@end
