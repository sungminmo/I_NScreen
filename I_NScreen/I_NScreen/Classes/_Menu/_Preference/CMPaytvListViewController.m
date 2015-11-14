//
//  CMPaytvListViewController.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 9. 29..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMPaytvListViewController.h"
#import "CMPaytvTableViewCell.h"
#import "CMPaytvGuideViewController.h"
#import "NSMutableDictionary+Preference.h"
#import "UIAlertView+AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface CMPaytvListViewController ()
@property (nonatomic, strong) NSMutableArray* paytvList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (weak, nonatomic) IBOutlet UITableView *contentsTable;
@end

@implementation CMPaytvListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"유료채널 안내";
    self.isUseNavigationBar = YES;
    self.topMargin.constant = 0;
    
    self.paytvList = [@[] mutableCopy];
    [self requestWithGetServiceJoinList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.paytvList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"CMPaytvTableViewCell";
    CMPaytvTableViewCell *cell = (CMPaytvTableViewCell *)[self cellWithTableView:tableView cellIdentifier:cellIdentifier nibName:cellIdentifier];
    
    NSDictionary* cellItem = self.paytvList[indexPath.row];
    if (cellItem) {
        NSString* channel = [cellItem[@"Joy_Title"] emptyCheck];
        NSString* thumb = [cellItem[@"Joy_Thumbnail_Img"] emptyCheck];
        [cell.thumbView setImageWithURL:[NSURL URLWithString:thumb]];
        cell.titleLabel.text = channel;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* item = nil;
    item = self.paytvList[indexPath.row];
    
    CMPaytvGuideViewController* controller = [[CMPaytvGuideViewController alloc] initWithGuideInfo:item];
    [self.navigationController pushViewController:controller animated:YES];

}

#pragma mark - 전문
#pragma mark - 유료체널 전문
- (void)requestWithGetServiceJoinList {
    NSURLSessionDataTask *task = [NSMutableDictionary preferenceGetServiceJoyNListCompletion:^(NSArray *preference, NSError *error) {
        DDLogError(@"%@", preference);
        for ( NSDictionary *dic in ((NSDictionary* )preference.firstObject)[@"JoyList_Item"] )
        {
            [self.paytvList addObject:dic];
        }
        
        [self.contentsTable reloadData];
    }];
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

@end
