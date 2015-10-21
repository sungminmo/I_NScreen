//
//  EpgMainViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 11..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "EpgMainViewController.h"
#import "NSMutableDictionary+EPG.h"
#import "UIAlertView+AFNetworking.h"

@interface EpgMainViewController ()

@property (nonatomic, strong) NSMutableArray *pListDataArr;

@end

@implementation EpgMainViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTagInit];
    [self setViewInit];
    [self setViewDataInit];
    
    // 1은 지상판데 전체는 머지
    [self requestWithChannelListWithGenreCode:@"1"];
}

#pragma mark - 초기화
#pragma mark - 버튼 태그 초기화
- (void)setTagInit
{
    self.pBackBtn.tag = EPG_MAIN_VIEW_BTN_TAG_01;
    self.pPopUpBtn.tag = EPG_MAIN_VIEW_BTN_TAG_02;
}

#pragma mark - 화면 초기화
- (void)setViewInit
{

}

#pragma mark - 데이터 초기화
- (void)setViewDataInit
{
    self.pListDataArr = [[NSMutableArray alloc] init];
}

- (IBAction)onBtnClick:(UIButton *)btn;
{
    switch ([btn tag]) {
        case EPG_MAIN_VIEW_BTN_TAG_01:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }break;
        case EPG_MAIN_VIEW_BTN_TAG_02:
        {
            // 팝업 뷰
            EpgPopUpViewController *pViewController = [[EpgPopUpViewController alloc] initWithNibName:@"EpgPopUpViewController" bundle:nil];
//            [self.navigationController pushViewController:pViewController animated:NO];
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.view addSubview:pViewController.view];
            
        }break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *pCellIn = @"EpgMainTableViewCellIn";
    
    EpgMainTableViewCell *pCell = (EpgMainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:pCellIn];
    
    if (pCell == nil)
    {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"EpgMainTableViewCell" owner:nil options:nil];
        pCell = [arr objectAtIndex:0];
    }
    
    [pCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [pCell setListData:[self.pListDataArr objectAtIndex:indexPath.row] WithIndex:(int)indexPath.row];
    
    return pCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EpgSubViewController *pViewController = [[EpgSubViewController alloc] initWithNibName:@"EpgSubViewController" bundle:nil];
    [self.navigationController pushViewController:pViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int nTotal = (int)[self.pListDataArr count];
    
    return nTotal;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - 전문
#pragma mark - 체널 리스트 전문
- (void)requestWithChannelListWithGenreCode:(NSString *)genreCode
{
    NSString *sAreaCode = @"0";
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary epgGetChannelListAreaCode:sAreaCode WithGenreCode:genreCode completion:^(NSArray *epgs, NSError *error) {
        
        
        NSLog(@"epg = [%@]", epgs);
        
        if ( [epgs count] == 0 )
            return;
        
        [self.pListDataArr removeAllObjects];
        [self.pListDataArr setArray:[[epgs objectAtIndex:0] objectForKey:@"channelItem"]];
        
        [self.pTableView reloadData];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

@end
