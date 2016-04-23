//
//  RemoconMainViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "RemoconMainViewController.h"
#import "NSMutableDictionary+REMOCON.h"
#import "NSMutableDictionary+EPG.h"
#import "UIAlertView+AFNetworking.h"
#import "NSMutableDictionary+PVR.h"
#import "CMDBDataManager.h"
#import "CMWatchReserveList.h"

@interface RemoconMainViewController ()

@property (nonatomic, weak) IBOutlet UIButton *pBackBtn;        // back 버튼
@property (nonatomic, weak) IBOutlet UIButton *pPowerBtn;       // 전원 버튼
@property (nonatomic, weak) IBOutlet UIButton *pChannelBtn;     // 채널 버튼
@property (nonatomic, weak) IBOutlet UIButton *pVolumeDownBtn;  // 볼륨 다운 버튼
@property (nonatomic, weak) IBOutlet UIButton *pVoluumeUpBtn;   // 볼륨 업 버튼
@property (nonatomic, weak) IBOutlet UITableView *pTableView;
@property (nonatomic, strong) NSMutableArray *pChannelFullListArr;  //  전체 채널 리스트
@property (nonatomic, strong) NSMutableArray *pChannelListArr;  // 체널 리스트
@property (nonatomic, strong) NSMutableDictionary *pStatusDic;  // 현재 상태
@property (nonatomic, strong) NSMutableArray *pRecordReservListArr; // 녹화 예약 체크
@property (nonatomic, strong) NSMutableArray *recordingchannelArr;  // 녹화중인지 체크

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (strong, nonatomic) IBOutlet UILabel *channelLabel;
@property (nonatomic) BOOL isOnOff;
@property (nonatomic) int nGenreCode;
@end

@implementation RemoconMainViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.isUseNavigationBar = YES;
    self.topConstraint.constant = cmNavigationHeight;
    self.title = @"리모컨";
    
    [self setTagInit];
    [self setViewInit];
    [self requestWithChannelListFull];
//    [self requestWithGetSetTopStatus];
    
#warning TEST
    //  test
    [self setChannelNumber:@"번"];
}

#pragma mark - 초기화
#pragma mark - 화면 태그값 초기화
- (void)setTagInit
{
    self.pBackBtn.tag = REMOCON_MAIN_VIEW_BTN_01;
    self.pPowerBtn.tag = REMOCON_MAIN_VIEW_BTN_02;
    self.pChannelBtn.tag = REMOCON_MAIN_VIEW_BTN_03;
    self.pVolumeDownBtn.tag = REMOCON_MAIN_VIEW_BTN_04;
    self.pVoluumeUpBtn.tag = REMOCON_MAIN_VIEW_BTN_05;
}

#pragma mark - 화면 초기화
- (void)setViewInit
{
    self.pChannelFullListArr = [[NSMutableArray alloc] init];
    self.pChannelListArr = [[NSMutableArray alloc] init];
    self.pStatusDic = [[NSMutableDictionary alloc] init];
    self.pRecordReservListArr = [[NSMutableArray alloc] init];
    self.recordingchannelArr = [[NSMutableArray alloc] init];
    
    self.nGenreCode = 0;    // 초기값 전체
    
    // 화면 해상도 대응
    if ( [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_6_PLUS] )
    {
        self.pPowerBtn.frame = CGRectMake(14, 0, 142, 46);
        self.pChannelBtn.frame = CGRectMake(168, 0, 230, 46);
        self.pVolumeDownBtn.frame = CGRectMake(14, 20, 178, 76);
        self.pVoluumeUpBtn.frame = CGRectMake(222, 20, 178, 76);
    }
    else if ( [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_6] )
    {
        self.pPowerBtn.frame = CGRectMake(15, 0, 128, 40);
        self.pChannelBtn.frame = CGRectMake(150, 0, 208, 40);
        self.pVolumeDownBtn.frame = CGRectMake(14, 20, 142, 60);
        self.pVoluumeUpBtn.frame = CGRectMake(164, 20, 142, 60);
    }
    else
    {
        self.pPowerBtn.frame = CGRectMake(15, 0, 128, 40);
        self.pChannelBtn.frame = CGRectMake(128, 0, 177, 35);
        self.pVolumeDownBtn.frame = CGRectMake(14, 20, 154, 64);
        self.pVoluumeUpBtn.frame = CGRectMake(205, 20, 154, 64);
    }
}

#pragma mark - Private 

- (void)setChannelNumber:(NSString*)channel {
    NSString* fixedText = @"현재시청채널 :";
    NSString* desc = [NSString stringWithFormat:@"%@ %@", fixedText, channel];
    self.channelLabel.text = desc;
    
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.channelLabel.attributedText];
    NSRange range = NSMakeRange(fixedText.length, channel.length + 1);
    [attributedText addAttributes:@{NSForegroundColorAttributeName : [CMColor colorViolet]} range:range];
    
    self.channelLabel.attributedText = attributedText;
}

#pragma mark - 액션 이벤트
#pragma mark - 버튼 클릭 이벤트
- (IBAction)onBtnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case REMOCON_MAIN_VIEW_BTN_01:
        {
            // back
            [self.navigationController popViewControllerAnimated:YES];
            
        }break;
        case REMOCON_MAIN_VIEW_BTN_02:
        {
            // 전원 버튼
            if ( self.isOnOff == NO )
            {
                // 꺼진 상태 킨다
                [self requestWithSetRemoteWithPower:@"ON"];
            }
            else
            {
                // 켜진상태 끈다
                [self requestWithSetRemoteWithPower:@"OFF"];
            }
            
        }break;
        case REMOCON_MAIN_VIEW_BTN_03:
        {
            // 채널 버튼
            EpgPopUpViewController *pViewController = [[EpgPopUpViewController alloc] initWithNibName:@"EpgPopUpViewController" bundle:nil];
            pViewController.delegate = self;
            pViewController.nGenreCode = self.nGenreCode;
            pViewController.view.frame = self.view.bounds;
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.view addSubview:pViewController.view];
        }break;
        case REMOCON_MAIN_VIEW_BTN_04:
        {
            // 볼륨 다운 버튼
            [self requestWithSetRemoteWithVolume:@"DOWN"];
        }break;
        case REMOCON_MAIN_VIEW_BTN_05:
        {
            // 볼륨 업 버튼
            [self requestWithSetRemoteWithVolume:@"UP"];
        }break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *pCellIn = @"RemoconMainTableViewCellIn";
    
    RemoconMainTableViewCell *pCell = (RemoconMainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:pCellIn];
    
    if (pCell == nil)
    {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"RemoconMainTableViewCell" owner:nil options:nil];
        pCell = [arr objectAtIndex:0];
    }
    
    [pCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    pCell.delegate = self;
    CMDBDataManager *manager = [CMDBDataManager sharedInstance];
    RLMArray *ramArr = [manager getFavorChannel];
    
    NSString *channelNumber = [NSString stringWithFormat:@"%@", [[self.pChannelListArr objectAtIndex:indexPath.row] objectForKey:@"channelNumber"]];
    
    BOOL isCheck = NO;
    for ( CMFavorChannelInfo *info in ramArr )
    {
        if ( [info.pChannelNumber isEqualToString:channelNumber] )
        {
            // 선호체널
            isCheck = YES;
        }
    }
    
    [pCell setListData:[self.pChannelListArr objectAtIndex:indexPath.row] WithIndex:(int)indexPath.row WithStar:isCheck WithWatchCheck:[self getWatchReserveIndex:(int)indexPath.row] WithRecordingCheck:[self getRecordingChannelIndex:(int)indexPath.row] WithReservCheck:[self getRecordReservListIndex:(int)indexPath.row]];
    
    return pCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self requestWithChannelControlWithSelect:(int)indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int nTotal = (int)[self.pChannelListArr count];
    return nTotal;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - 전문
- (void)checkSetopBoxResult:(NSString*)code {
    if ([@[@"206", @"028"] containsObject:code]) {
        [SIAlertView alert:@"딜라이브 모바일 TV" message:@"셋탑박스와 통신이 끊어졌습니다.\n전원을 확인해주세요."];
    }
}

- (BOOL)checkRemoteControlState:(NSString*)code {
    if ([code isEqualToString:@"014"]) {// Hold Mode
        [SIAlertView alert:@"채널 변경" message:@"셋탑박스가 꺼져있습니다."];
        return NO;
    }
    else if ([code isEqualToString:@"020"]) {
        [SIAlertView alert:@"채널 변경" message:@"데이터 방송 시청중엔 채널변경이 불가능합니다."];
        return NO;
    }
    else if ([code isEqualToString:@"021"]) {// VOD 시청중
        [SIAlertView alert:@"채널 변경" message:@"VOD 시청중엔 채널변경이 불가능합니다."];
        return NO;
    }
    else if ([code isEqualToString:@"008"]) {// 녹화물 재생중
        [SIAlertView alert:@"채널 변경" message:@"녹화물 재생중엔 채널변경이 불가능합니다."];
        return NO;
    }
    return YES;
}

#pragma mark - 볼룸 조절 전문 리스트 UP, DOWN
- (void)requestWithSetRemoteWithVolume:(NSString *)volume
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary remoconSetRemoteVolumeControlVolume:volume completion:^(NSArray *pvr, NSError *error) {
        
        DDLogError(@"볼륨 조절 = [%@]", pvr);
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 셋탑 전원 전문 리스트 ON, OFF
- (void)requestWithSetRemoteWithPower:(NSString *)power
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary remoconSetRemotoePowerControlPower:power completion:^(NSArray *pvr, NSError *error) {
        
        DDLogError(@"셋탑 전원 전문 = [%@]", pvr);
        NSString *sResultCode = [NSString stringWithFormat:@"%@", [[pvr objectAtIndex:0] objectForKey:@"resultCode"]];
        if ( [sResultCode isEqualToString:@"100"] )
        {
            self.isOnOff = !self.isOnOff;
        }
        
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
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
            [self.pChannelFullListArr removeAllObjects];
            [self.pChannelFullListArr setArray:[[gets objectAtIndex:0] objectForKey:@"channelItem"]];
            
            [self.pChannelListArr removeAllObjects];
            [self.pChannelListArr setArray:[[gets objectAtIndex:0] objectForKey:@"channelItem"]];
            
        }
        else
        {
            [self.pChannelListArr removeAllObjects];
            
            CMDBDataManager *manager = [CMDBDataManager sharedInstance];
            RLMArray *ramArr = [manager getFavorChannel];
            
            for ( NSDictionary *dic in [[gets objectAtIndex:0] objectForKey:@"channelItem"] )
            {
                NSString *channelNumber = [NSString stringWithFormat:@"%@", [dic objectForKey:@"channelNumber"]];
                
                for ( CMFavorChannelInfo *info in ramArr )
                {
                    if ( [info.pChannelNumber isEqualToString:channelNumber] )
                    {
                        [self.pChannelListArr addObject:dic];
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
        
        [self.pChannelListArr removeAllObjects];
        [self.pChannelListArr setArray:[[epgs objectAtIndex:0] objectForKey:@"channelItem"]];
        
        [self requestWithGetSetTopStatus];
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 리모컨 상태 체크 전문
- (void)requestWithGetSetTopStatus
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary remoconGetSetTopStatusCompletion:^(NSArray *pairing, NSError *error) {
        
        DDLogError(@"리모컨 상태 체크 = [%@]", pairing);
        
        NSString *sResultCode = [[pairing objectAtIndex:0] objectForKey:@"resultCode"];
        [self checkSetopBoxResult:sResultCode];
        
        if ( [pairing count] == 0 )
            return;
        
        
        [self.pStatusDic removeAllObjects];
        [self.pStatusDic setDictionary:[pairing objectAtIndex:0]];
        
        NSString *sStatus = [NSString stringWithFormat:@"%@", [self.pStatusDic objectForKey:@"state"]];
        NSString *sWatchingchannel = [NSString stringWithFormat:@"%@", [self.pStatusDic objectForKey:@"watchingchannel"]];
        
        NSString *sChannelNumber = @"";
        for ( NSDictionary *dic in self.pChannelFullListArr )
        {
            NSString *sChannelId = [dic objectForKey:@"channelId"];
            
            if ( [sChannelId isEqualToString:sWatchingchannel] )
            {
                sChannelNumber = [NSString stringWithFormat:@"%@번", [dic objectForKey:@"channelNumber"]];
            }
        }
        
        if ( [sWatchingchannel isEqualToString:@"(null)"] || [sWatchingchannel length] == 0 )
        {
             [self setChannelNumber:@""];
        }
        else
        {
             [self setChannelNumber:sChannelNumber];
        }
        
       
        
        if ( [sStatus isEqualToString:@"4"] )
        {
            // 꺼진 상태
            self.isOnOff = NO;
        }
        else
        {
            // 켜진 상태
            self.isOnOff = YES;
        }
        
        NSString *sRecordingchannel1 = [NSString stringWithFormat:@"%@", [[pairing objectAtIndex:0] objectForKey:@"recordingchannel1"]];
        NSString *sRecordingchannel2 = [NSString stringWithFormat:@"%@", [[pairing objectAtIndex:0] objectForKey:@"recordingchannel2"]];
        
        [self.recordingchannelArr removeAllObjects];
        
        [self.recordingchannelArr addObject:sRecordingchannel1];
        [self.recordingchannelArr addObject:sRecordingchannel2];

        [self requestWithGetRecordReserveList];
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 체널 변경 전문
- (void)requestWithChannelControlWithSelect:(int)nSelect
{
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.pChannelListArr objectAtIndex:nSelect] objectForKey:@"channelId"]];
    NSString *sChannelNumber = [NSString stringWithFormat:@"%@", [[self.pChannelListArr objectAtIndex:nSelect] objectForKey:@"channelNumber"]];
    NSURLSessionDataTask *tesk = [NSMutableDictionary remoconSetRemoteChannelControlWithChannelId:sChannelId completion:^(NSArray *pairing, NSError *error) {
        
        DDLogError(@"pairing = [%@]", pairing);
        
        if ( [[[pairing objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
        {
            // 체널 변경후 상태 값 다시 맵핑
            NSString *sWatchingchannel = [NSString stringWithFormat:@"%@번", sChannelNumber];
            
            [self setChannelNumber:sWatchingchannel];
        }
        else {
            [self checkRemoteControlState:[[pairing objectAtIndex:0] objectForKey:@"resultCode"]];
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
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 시청예약 체크
- (BOOL)getWatchReserveIndex:(int)index
{
    NSString *sTilte = [NSString stringWithFormat:@"%@", [[self.pChannelListArr objectAtIndex:index] objectForKey:@"programTitle"]];
    NSString *sStartTime = [NSString stringWithFormat:@"%@", [[self.pChannelListArr objectAtIndex:index] objectForKey:@"programBroadcastingStartTime"]];
    NSString *sSeq = [NSString stringWithFormat:@"%@", [[self.pChannelListArr objectAtIndex:index] objectForKey:@"scheduleSeq"]];
    NSString *sProgramId = [NSString stringWithFormat:@"%@", [[self.pChannelListArr objectAtIndex:index] objectForKey:@"programId"]];
    NSString *sHd = [NSString stringWithFormat:@"%@", [[self.pChannelListArr objectAtIndex:index] objectForKey:@"programHD"]];
    
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
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.pChannelListArr objectAtIndex:index] objectForKey:@"ChannelId"]];
    
    if ([sChannelId isEqualToString:@"(null)"]) {
        return NO;
    }
    
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
    NSString *sRecordStartTime = [NSString stringWithFormat:@"%@", [[self.pChannelListArr objectAtIndex:index] objectForKey:@"RecordStartTime"]];
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.pChannelListArr objectAtIndex:index] objectForKey:@"ChannelId"]];
    
    BOOL isCheck = NO;
    for ( NSDictionary *dic in self.pRecordReservListArr )
    {
        NSString *sDicRecordStartTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"RecordStartTime"]];
        NSString *sDicChannelId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"ChannelId"]];
        
        if ( [sRecordStartTime isEqualToString:sDicRecordStartTime] &&
            [sChannelId isEqualToString:sDicChannelId] )
        {
            isCheck = YES;
        }
    }
    return isCheck;
}


#pragma mark - 델리게이트
#pragma mark - EpgPopUpView 델리게이트
- (void)EpgPopUpViewReloadWithGenre:(NSDictionary *)genreDic WithTag:(int)nTag
{
    self.nGenreCode = nTag;
    
    if ( [genreDic count] == 0 )
    {
        if ( nTag == 0 )
        {
            // 전체 채널
            [self.pChannelBtn setTitle:@"전체채널" forState:UIControlStateNormal];
            [self requestWithChannelListFull];    // 전체
        }
        else
        {
            // 선호 채널
            [self.pChannelBtn setTitle:@"선호채널" forState:UIControlStateNormal];
            
            [self requestWithChannelListFull];
        }
        
    }
    else
    {
        NSString *sGenreName = [NSString stringWithFormat:@"%@", [genreDic objectForKey:@"genreName"]];
        NSString *sGenreCode = [NSString stringWithFormat:@"%@", [genreDic objectForKey:@"genreCode"]];
        
        [self.pChannelBtn setTitle:sGenreName forState:UIControlStateNormal];
        [self requestWithChannelListWithGenreCode:sGenreCode];
    }
}

#pragma mark - RemoconMainTableViewCell 델리게이트
- (void)RemoconMainTableViewCellWithTag:(int)nTag
{
    if ( self.nGenreCode == 1 )
    {
        // 선호 체널이면
        [self.pChannelListArr removeObjectAtIndex:nTag];
        
    }
    [self.pTableView reloadData];
}

@end
