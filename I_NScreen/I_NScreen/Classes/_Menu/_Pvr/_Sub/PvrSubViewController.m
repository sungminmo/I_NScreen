//
//  PvrSubViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "PvrSubViewController.h"

@interface PvrSubViewController ()

@property (nonatomic, weak) IBOutlet UITableView *pTableView;
@property (strong, nonatomic) IBOutlet UIView *titleView;   //  커스텀 타이틀뷰
@property (strong, nonatomic) IBOutlet UILabel* titleLabel; //  제목 라벨
@property (strong, nonatomic) IBOutlet UIImageView *seriesImageView;    //  타이틀에 시리즈 이미지

@end

@implementation PvrSubViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //  커스텀 네비게이션 타이틀 뷰
    self.isUseNavigationBar = YES;
    self.navigationItem.titleView = self.titleView;
    self.seriesImageView.hidden = false;
    self.titleLabel.text = @"뉴스파이터";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *pCellIn = @"PvrSubTableViewCell";
    
    PvrSubTableViewCell *pCell = (PvrSubTableViewCell *)[tableView dequeueReusableCellWithIdentifier:pCellIn];
    
    if (pCell == nil)
    {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PvrSubTableViewCell" owner:nil options:nil];
        pCell = [arr objectAtIndex:0];
    }
    
    [pCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [pCell setListData:nil WithIndex:(int)indexPath.row];
    
    return pCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    EpgSubViewController *pViewController = [[EpgSubViewController alloc] initWithNibName:@"EpgSubViewController" bundle:nil];
    //    [self.navigationController pushViewController:pViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 24;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DDLogError(@"delete");
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return @"녹화예약취소";
}

@end
