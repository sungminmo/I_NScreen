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

@interface CMPaytvListViewController ()
@property (nonatomic, strong) NSArray* paytvList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (weak, nonatomic) IBOutlet UITableView *contentsTable;
@end

@implementation CMPaytvListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"유료채널 안내";
    self.isUseNavigationBar = YES;
    self.topMargin.constant = 0;
    
    //임시
    self.paytvList = @[@"", @"", @"", @""];
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
    NSString* text = @"";
    //    text = self.noticeList[indexPath.row][@"title"];
    text = @"channel title";//임시로 박음.
    cell.titleLabel.text = text;
    cell.imageView.image = [UIImage imageNamed:@"testimg.png"];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* item = nil;
    item = self.paytvList[indexPath.row];
    
    CMPaytvGuideViewController* controller = [[CMPaytvGuideViewController alloc] initWithNibName:@"CMPaytvGuideViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    [controller settingInfo:item];
}

@end
