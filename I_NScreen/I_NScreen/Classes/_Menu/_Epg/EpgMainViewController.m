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
#import "CMDBDataManager.h"
#import "NSMutableDictionary+REMOCON.h"
#import "NSMutableDictionary+PVR.h"
#import "CMWatchReserveList.h"

@interface EpgMainViewController ()

@property (nonatomic, strong) NSMutableArray *pListDataArr;
@property (nonatomic) int nGenreCode;
@property (nonatomic, strong) NSMutableArray *recordingchannelArr;  // 녹화중인지 배열
@property (nonatomic, strong) NSMutableArray *pRecordReservListArr; // 녹화 예약 목록 배열
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
    [self requestWithGetSetTopStatus];
    [self requestWithGetRecordReserveList];
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
    self.pRecordReservListArr = [[NSMutableArray alloc] init];
    self.recordingchannelArr = [[NSMutableArray alloc] init];
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
    pCell.delegate = self;
    
    [pCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    CMDBDataManager *manager = [CMDBDataManager sharedInstance];
    RLMArray *ramArr = [manager getFavorChannel];
    
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.pListDataArr objectAtIndex:indexPath.row] objectForKey:@"channelId"]];
    
    BOOL isCheck = NO;
    for ( CMFavorChannelInfo *info in ramArr )
    {
        if ( [info.pChannelId isEqualToString:sChannelId] )
        {
            // 선호체널
            isCheck = YES;
        }
    }

    [pCell setListData:[self.pListDataArr objectAtIndex:indexPath.row] WithIndex:(int)indexPath.row WithStar:isCheck WithWatchCheck:[self getWatchReserveIndex:(int)indexPath.row] WithRecordingCheck:[self getRecordingChannelIndex:(int)indexPath.row] WithReservCheck:[self getRecordReservListIndex:(int)indexPath.row]];
    
    return pCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    EpgSubViewController *pViewController = [[EpgSubViewController alloc] initWithNibName:@"EpgSubViewController" bundle:nil];
    pViewController.delegate = self;
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
    CMAreaInfo* areaInfo = [[CMDBDataManager sharedInstance] currentAreaInfo];
    NSURLSessionDataTask *tesk = [NSMutableDictionary epgGetChannelListAreaCode:areaInfo.areaCode/*CNM_AREA_CODE*/ block:^(NSArray *gets, NSError *error) {
        DDLogError(@"epg = [%@]", gets);
        
        if ( [gets count] == 0 )
            return;
        
        if ( self.nGenreCode == 0 )
        {
            [self.pListDataArr removeAllObjects];
            [self.pListDataArr setArray:[[gets objectAtIndex:0] objectForKey:@"channelItem"]];
        }
        else
        {
            [self.pListDataArr removeAllObjects];
            
            CMDBDataManager *manager = [CMDBDataManager sharedInstance];
            RLMArray *ramArr = [manager getFavorChannel];
            
            for ( NSDictionary *dic in [[gets objectAtIndex:0] objectForKey:@"channelItem"] )
            {
                NSString *sChannelId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"channelId"]];
                
                for ( CMFavorChannelInfo *info in ramArr )
                {
                    if ( [info.pChannelId isEqualToString:sChannelId] )
                    {
                        [self.pListDataArr addObject:dic];
                    }
                }
            }
        }
        
        [self requestWithGetSetTopStatus];
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 체널 리스트 전문
- (void)requestWithChannelListWithGenreCode:(NSString *)genreCode
{
    CMAreaInfo* areaInfo = [[CMDBDataManager sharedInstance] currentAreaInfo];
    NSURLSessionDataTask *tesk = [NSMutableDictionary epgGetChannelListAreaCode:areaInfo.areaCode/*CNM_AREA_CODE*/ WithGenreCode:genreCode completion:^(NSArray *epgs, NSError *error) {
        
        
        DDLogError(@"epg = [%@]", epgs);
        
        if ( [epgs count] == 0 )
            return;
        
        [self.pListDataArr removeAllObjects];
        [self.pListDataArr setArray:[[epgs objectAtIndex:0] objectForKey:@"channelItem"]];
        
        [self requestWithGetSetTopStatus];
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 리모컨 상태 체크 전문( 녹화중인지 체크 )
- (void)requestWithGetSetTopStatus
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary remoconGetSetTopStatusCompletion:^(NSArray *pairing, NSError *error) {
        
        DDLogError(@"리모컨 상태 체크 = [%@]", pairing);
        
        NSString *sResultCode = [[pairing objectAtIndex:0] objectForKey:@"resultCode"];

        if ([[CMAppManager sharedInstance] checkSTBStateCode:sResultCode])
        {
            if ( [pairing count] == 0 )
                return;
            
            NSString *sRecordingchannel1 = [NSString stringWithFormat:@"%@", [[pairing objectAtIndex:0] objectForKey:@"recordingchannel1"]];
            NSString *sRecordingchannel2 = [NSString stringWithFormat:@"%@", [[pairing objectAtIndex:0] objectForKey:@"recordingchannel2"]];
            
            [self.recordingchannelArr removeAllObjects];
            
            [self.recordingchannelArr addObject:sRecordingchannel1];
            [self.recordingchannelArr addObject:sRecordingchannel2];
            
            DDLogError(@"녹화중 체크 = [%@]", self.recordingchannelArr );
            
            [self requestWithGetRecordReserveList];
        }
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}


#pragma mark - 녹화 예약 목록 가져오는 전문
- (void)requestWithGetRecordReserveList
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary pvrGetrecordReservelistCompletion:^(NSArray *pvr, NSError *error) {
        
        DDLogError(@"녹화 예약 목록 = [%@]", pvr);
        if ( [pvr count] == 0 )
            return;
        
        [self.pRecordReservListArr removeAllObjects];
        
        NSString* resultCode = [[pvr objectAtIndex:0] objectForKey:@"resultCode"];
        if ([[CMAppManager sharedInstance] checkSTBStateCode:resultCode])
        {
            NSObject *itemObject = [[pvr objectAtIndex:0] objectForKey:@"Reserve_Item"];
            
            if ( [itemObject isKindOfClass:[NSDictionary class]] )
            {
                [self.pRecordReservListArr addObject:(NSDictionary *)itemObject];
            }
            else
            {
                [self.pRecordReservListArr setArray:(NSArray *)itemObject];
            }
            
            DDLogError(@"녹화예약목록2 = [%@]", self.pRecordReservListArr);
            
            [self.pTableView reloadData];
        }
        else
        {
            [self.pTableView reloadData];
        }
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 시청예약 체크
- (BOOL)getWatchReserveIndex:(int)index
{
    NSString *sTilte = [NSString stringWithFormat:@"%@", [[self.pListDataArr objectAtIndex:index] objectForKey:@"programTitle"]];
    NSString *sStartTime = [NSString stringWithFormat:@"%@", [[self.pListDataArr objectAtIndex:index] objectForKey:@"programBroadcastingStartTime"]];
    NSString *sSeq = [NSString stringWithFormat:@"%@", [[self.pListDataArr objectAtIndex:index] objectForKey:@"scheduleSeq"]];
    NSString *sProgramId = [NSString stringWithFormat:@"%@", [[self.pListDataArr objectAtIndex:index] objectForKey:@"programId"]];
    NSString *sHd = [NSString stringWithFormat:@"%@", [[self.pListDataArr objectAtIndex:index] objectForKey:@"programHD"]];
    
    CMDBDataManager *manager = [CMDBDataManager sharedInstance];
    BOOL isCheck = NO;
    for ( CMWatchReserveList *info in [manager getWatchReserveList] )
    {
        if ( [sTilte isEqualToString:info.programTitleStr] &&
            [sStartTime isEqualToString:info.programBroadcastingStartTimeStr] &&
            [sSeq isEqualToString:info.scheduleSeqStr] &&
            [sProgramId isEqualToString:info.programIdStr] &&
            [sHd isEqualToString:info.programHDStr] )
        {
            isCheck = YES;
        }
    }
    
    return isCheck;
}

#pragma mark - 녹화중 체크
- (BOOL)getRecordingChannelIndex:(int)index
{
    // 체널 id 로 체크
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.pListDataArr objectAtIndex:index] objectForKey:@"channelId"]];
    
    BOOL isCheck = NO;
    for ( NSString *str in self.recordingchannelArr )
    {
        if ( [str isEqualToString:sChannelId] )
        {
            isCheck = YES;
        }
    }
    return isCheck;
}

#pragma mark - 녹화 예약 체크
- (BOOL)getRecordReservListIndex:(int)index
{
    NSString *sRecordStartTime = [NSString stringWithFormat:@"%@", [[self.pListDataArr objectAtIndex:index] objectForKey:@"RecordStartTime"]];
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.pListDataArr objectAtIndex:index] objectForKey:@"channelId"]];

    BOOL isCheck = NO;
    for ( NSDictionary *dic in self.pRecordReservListArr )
    {
        NSString *sDicRecordStartTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"RecordStartTime"]];
        NSString *sDicChannelId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"channelId"]];
        
        if ( [sRecordStartTime isEqualToString:sDicRecordStartTime] &&
            [sChannelId isEqualToString:sDicChannelId] )
        {
            isCheck = YES;
        }
    }
    return isCheck;
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
            
            [self requestWithChannelListFull];
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

#pragma mark - EpgMainTableViewCell 델리게이트
- (void)EpgMainTableViewWithTag:(int)nTag
{
    if ( self.nGenreCode == 1 )
    {
        // 선호 체널이면

        [self.pListDataArr removeObjectAtIndex:nTag];
        
    }
    [self.pTableView reloadData];
}

#pragma mark - EpgSubView 델리게이트
- (void)EpgSubViewWithTag:(int)nTag
{
    [self requestWithChannelListFull];
}



@end
