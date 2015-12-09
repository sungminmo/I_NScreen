//
//  CMNoticeListViewController.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 9. 29..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMNoticeListViewController.h"
#import "CMNoticeTableViewCell.h"
#import "CMNoticeDetailViewController.h"
#import "NSMutableDictionary+Preference.h"


@interface CMNoticeListViewController ()

@property (nonatomic, strong) NSMutableArray* noticeList;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (weak, nonatomic) IBOutlet UITableView *contentsTable;

@end

@implementation CMNoticeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"공지사항";
    self.isUseNavigationBar = YES;
    self.topMargin.constant = 0;
    
    self.noticeList = [@[] mutableCopy];
    [self requestNotice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.noticeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"CMNoticeTableViewCell";
    CMNoticeTableViewCell *cell = (CMNoticeTableViewCell *)[self cellWithTableView:tableView cellIdentifier:cellIdentifier nibName:cellIdentifier];
    
    NSString* text = @"";
    text = self.noticeList[indexPath.row][@"notice_Title"];
    cell.titleLabel.text = text;
    return cell;
}

#pragma mark - UITableViewDelegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* item = nil;
    item = self.noticeList[indexPath.row];
    
    CMNoticeDetailViewController* controller = [[CMNoticeDetailViewController alloc] initWithInfo:item];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 
- (void)requestNotice {
    [NSMutableDictionary perferenceGetServiceNoticeInfoCompletion:^(NSArray *preference, NSError *error) {
        
        if (preference.count > 0) {
            NSDictionary* item = preference.lastObject;
            id obj = item[@"Notice_Item"];
            
            if ([obj isKindOfClass:[NSArray class]]) {
                NSDictionary* item = preference.lastObject;
                [self.noticeList addObjectsFromArray:item[@"Notice_Item"]];
            }
            else if ([obj isKindOfClass:[NSDictionary class]]) {
                [self.noticeList addObject:item[@"Notice_Item"]];
            }
            
            [self.contentsTable reloadData];
        }
        
    }];
}

@end
