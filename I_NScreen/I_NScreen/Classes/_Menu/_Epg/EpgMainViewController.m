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
@property (nonatomic) int nGenreCode;
@end

@implementation EpgMainViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"채널가이드";
    self.isUseNavigationBar = YES;
    
    [self setTagInit];
    [self setViewInit];
    [self setViewDataInit];
    
    // 전체
    [self requestWithChannelListFull];
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
    self.nGenreCode = 0;    // 초기값 전체
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
            pViewController.delegate = self;
            pViewController.nGenreCode = self.nGenreCode;
            pViewController.view.frame = self.view.bounds;
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
    pViewController.pListDataDic = [self.pListDataArr objectAtIndex:indexPath.row];
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
#pragma mark - 전체 채널 리스트 전문
- (void)requestWithChannelListFull
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary epgGetChannelListAreaCode:CNM_AREA_CODE block:^(NSArray *gets, NSError *error) {
        DDLogError(@"epg = [%@]", gets);
        
        if ( [gets count] == 0 )
            return;
        
        [self.pListDataArr removeAllObjects];
        [self.pListDataArr setArray:[[gets objectAtIndex:0] objectForKey:@"channelItem"]];
        
        [self.pTableView reloadData];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 체널 리스트 전문
- (void)requestWithChannelListWithGenreCode:(NSString *)genreCode
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary epgGetChannelListAreaCode:CNM_AREA_CODE WithGenreCode:genreCode completion:^(NSArray *epgs, NSError *error) {
        
        
        DDLogError(@"epg = [%@]", epgs);
        
        if ( [epgs count] == 0 )
            return;
        
        [self.pListDataArr removeAllObjects];
        [self.pListDataArr setArray:[[epgs objectAtIndex:0] objectForKey:@"channelItem"]];
        
        [self.pTableView reloadData];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 댈라개아트
#pragma mark - EpgPopUpViewController 델리게이트
- (void)EpgPopUpViewReloadWithGenre:(NSDictionary *)genreDic WithTag:(int)nTag
{
    self.nGenreCode = nTag;
    
    if ( [genreDic count] == 0 )
    {
        if ( nTag == 0 )
        {
            // 전체 채널
            [self.pPopUpBtn setTitle:@"전체채널" forState:UIControlStateNormal];
            [self requestWithChannelListFull];    // 전체
        }
        else
        {
            // 선호 채널
            [self.pPopUpBtn setTitle:@"선호채널" forState:UIControlStateNormal];
        }
        
    }
    else
    {
        NSString *sGenreName = [NSString stringWithFormat:@"%@", [genreDic objectForKey:@"genreName"]];
        NSString *sGenreCode = [NSString stringWithFormat:@"%@", [genreDic objectForKey:@"genreCode"]];
        
        [self.pPopUpBtn setTitle:sGenreName forState:UIControlStateNormal];
        [self requestWithChannelListWithGenreCode:sGenreCode];
    }
    
    
}

@end
