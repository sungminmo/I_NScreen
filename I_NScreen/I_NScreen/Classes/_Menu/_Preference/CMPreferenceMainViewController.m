//
//  CMPreferenceMainViewController.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 9. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMPreferenceMainViewController.h"

static NSString* const CellIdentifier = @"preferenceMainCell";

@interface CMPreferenceMainViewController ()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (nonatomic, strong) IBOutlet UITableView* tableView;

@property (nonatomic, strong) NSArray* tableList;

@end

@implementation CMPreferenceMainViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"설정";
    self.isUseNavigationBar = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CMPreferenceMainTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    [self settingListData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)settingListData {

    self.tableList = @[@{@"type":@(INFO_PREFERENCE_MAIN_CELL_TYPE)},
                       @{@"type":@(SETTING_PREFERENCE_MAIN_CELL), @"icon":@(true), @"title":@"지역설정", @"addedInfo":@"현재설정지역 : 강동구", @"attributedString":@{@"target":@":", @"color":[CMColor colorViolet]}},
                       @{@"type":@(SETTING_PREFERENCE_MAIN_CELL), @"icon":@(true), @"title":@"구매인증 비밀번호 관리"},
                       @{@"type":@(SETTING_PREFERENCE_MAIN_CELL), @"icon":@(true), @"title":@"성인검색 제한설정", @"switch":@(true)},
                       @{@"type":@(SETTING_PREFERENCE_MAIN_CELL), @"icon":@(true), @"title":@"성인인증", @"addedInfo":@"성인인증이 필요합니다.", @"attributedString":@{@"color":[UIColor redColor]}},
                       @{@"type":@(SETTING_PREFERENCE_MAIN_CELL), @"title":@"공지사항"},
                       @{@"type":@(SETTING_PREFERENCE_MAIN_CELL), @"title":@"유료채널 안내"},
                       @{@"type":@(SETTING_PREFERENCE_MAIN_CELL), @"title":@"고객센터 안내"}];
}

#pragma mark - UITablevewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tableList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CMPreferenceMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary* dic = self.tableList[indexPath.row];
    
    [cell setCellType:[dic[@"type"] integerValue] icon:[dic[@"icon"] boolValue] title:dic[@"title"] addedInfo:dic[@"addedInfo"] addedAttribute:dic[@"attributedString"] switch:[dic[@"switch"] boolValue]];
    
    return cell;
}

#pragma mark - UITableVewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
@end
