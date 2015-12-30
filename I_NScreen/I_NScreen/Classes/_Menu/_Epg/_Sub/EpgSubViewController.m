//
//  EpgSubViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 14..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "EpgSubViewController.h"
#import "BMXSwipableCell+ConfigureCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSMutableDictionary+EPG.h"
#import "UIAlertView+AFNetworking.h"
#import "NSMutableDictionary+REMOCON.h"
#import "NSMutableDictionary+PVR.h"
#import "CMDBDataManager.h"
#import "CMWatchReserveList.h"

@interface EpgSubViewController ()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;   //  네비게이션바 간격

@property (nonatomic, strong) IBOutlet UIView* pSubChannelView;     //  채널 로고 + 날짜 스크롤뷰
@property (nonatomic, strong) IBOutlet UIImageView* logoImageView;  //  채널 로고
@property (nonatomic, strong) CMDateScrollView* dateScrollView;     //  날짜 스크롤뷰
@property (nonatomic, strong) IBOutlet UITableView* pTableView;     //  방송 목록 테이블

@property (nonatomic, strong) NSMutableArray* dataArray;    //  방송 정보
@property (nonatomic, strong) NSMutableArray* todayNewDateArr;   // 오늘 날짜 데이터
@property (nonatomic, strong) NSMutableArray* scrollDateArray;  // 날짜 정보
@property (nonatomic, strong) NSMutableArray *recordingchannelArr;  // 녹화중인지 id 값 저장 2개까지 max
@property (nonatomic) int nScrollDateIndex;
@property (nonatomic, strong) NSMutableArray *pRecordReservListArr; // 녹화 예약 목록 리스트

@property (nonatomic, strong) NSMutableArray *pNowStateCheckArr;    // 현재 상태 저장 배열 key cellState, moreState, deleteState

@end

@implementation EpgSubViewController
@synthesize pListDataDic;
@synthesize delegate;

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topConstraint.constant = cmNavigationHeight;
    
    self.isUseNavigationBar = YES;
   
    self.dataArray = [@[] mutableCopy];
    self.todayNewDateArr = [@[] mutableCopy];
    self.recordingchannelArr = [@[] mutableCopy];
    self.pRecordReservListArr = [@[] mutableCopy];
    self.pNowStateCheckArr = [@[] mutableCopy];
    [self setViewInit];
    
    [self requestWithGetSetTopStatus];
}

#pragma mark - 화면 초기화

- (void)setViewInit
{
    self.nScrollDateIndex = 0;
    
    CGFloat posX = self.logoImageView.bounds.size.width;
    self.dateScrollView = [[CMDateScrollView alloc] initWithFrame:CGRectMake(posX, 0, [UIScreen mainScreen].bounds.size.width - posX, self.pSubChannelView.bounds.size.height)];
    self.dateScrollView.delegate = self;
    [self.pSubChannelView addSubview:self.dateScrollView];
    
    NSString *logoImageUrl = [NSString stringWithFormat:@"%@", [self.pListDataDic objectForKey:@"channelLogoImg"]];
    self.title = [NSString stringWithFormat:@"%@", [self.pListDataDic objectForKey:@"channelName"]];
    [self.logoImageView setImageWithURL:[NSURL URLWithString:logoImageUrl]];
    
    CMDBDataManager *manager = [CMDBDataManager sharedInstance];
    RLMArray *ramArr = [manager getFavorChannel];
    
    NSString *channelNumber = self.pListDataDic[@"channelNumber"];;
    
    BOOL isCheck = NO;
    for ( CMFavorChannelInfo *info in ramArr )
    {
        if ( [info.pChannelNumber isEqualToString:channelNumber] )
        {
            // 선호체널
            isCheck = YES;
        }
    }
    
    if ( isCheck == YES )
    {
        [self showFavoriteButton2:true];
    }
    else
    {
        [self showFavoriteButton2:false];
    }
}

- (IBAction)onBtnClick:(UIButton *)btn;
{
    switch ([btn tag]) {
        case EPG_SUP_VIEW_BTN_02:
        {
            // 하트 버튼
            
        }break;
    }
}

- (void)favoriteButton:(id)sender
{
    NSString *channelNumber = self.pListDataDic[@"channelNumber"];
    CMDBDataManager *manager = [CMDBDataManager sharedInstance];
    RLMArray *ramArr = [manager getFavorChannel];
    BOOL isCheck = NO;
    
    int nCount = 0;
    for ( CMFavorChannelInfo *info in ramArr )
    {
        if ( [info.pChannelNumber isEqualToString:channelNumber] )
        {
            isCheck = YES;
            [manager removeFavorChannel:nCount];
            [self showFavoriteButton2:false];
        }
        nCount++;
    }
    
    if ( isCheck == NO )
    {
        [manager setFavorChannel:self.pListDataDic];
        [self showFavoriteButton2:true];
    }

}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *pCellIn = @"EpgSubTableViewCell";
    
    EpgSubTableViewCell* cell = (EpgSubTableViewCell*)[tableView dequeueReusableCellWithIdentifier:pCellIn];
    
    if (cell == nil)
    {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"EpgSubTableViewCell" owner:nil options:nil];
        cell = [arr objectAtIndex:0];
    }
    
    cell.delegate1 = self;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary* data = self.todayNewDateArr[indexPath.row];
    
    NSMutableArray* array = [[self.pNowStateCheckArr objectAtIndex:indexPath.row] objectForKey:@"cellState"];
    [cell setData:data WithIndex:(int)indexPath.row ];
    [cell resetImageState:array];

    NSString *sMore = [NSString stringWithFormat:@"%@", [[self.pNowStateCheckArr objectAtIndex:indexPath.row] objectForKey:@"moreState"]];
    NSString *sDele = [NSString stringWithFormat:@"%@", [[self.pNowStateCheckArr objectAtIndex:indexPath.row] objectForKey:@"deleState"]];
    
    if (sMore.length > 0 && sDele.length > 0) {
        cell.swipeEnabled = YES;
        [cell configureCellForItem:@{@"More":sMore, @"Delete":sDele} WithItemCount:2];
    }
    else if (sMore.length > 0 && sDele.length == 0) {
        cell.swipeEnabled = YES;
        [cell configureCellForItem:@{@"More":sMore} WithItemCount:1];
    }
    else if (sMore.length == 0 && sDele.length > 0) {
        cell.swipeEnabled = YES;
        [cell configureCellForItem:@{@"Delete":sDele} WithItemCount:1];
    }
    else {
        cell.swipeEnabled = NO;
    }

    
    return cell;
}

- (NSString *)getWatchReserveIndex:(int)index
{
    NSString *sTilte = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:index] objectForKey:@"programTitle"]];
    NSString *sStartTime = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:index] objectForKey:@"programBroadcastingStartTime"]];
    NSString *sSeq = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:index] objectForKey:@"scheduleSeq"]];
    NSString *sProgramId = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:index] objectForKey:@"programId"]];
    NSString *sHd = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:index] objectForKey:@"programHD"]];
    
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
    
    NSString *sTitle = @"시청예약설정";
    if ( isCheck == YES )
        sTitle = @"시청예약취소";
    return sTitle;
}

- (CGFloat)getProgressTimerWithIndex:(int)nIndex
{
    CGFloat fCount = 0;
    NSString *sProgramBroadcastingStartTime = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:nIndex] objectForKey:@"programBroadcastingStartTime"]];
    NSString *sProgramBroadcastingEndTime = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:nIndex] objectForKey:@"programBroadcastingEndTime"]];
    
    NSArray *startArr = [sProgramBroadcastingStartTime componentsSeparatedByString:@" "];
    NSArray *startArr2 = [[startArr objectAtIndex:1] componentsSeparatedByString:@":"];
    
    NSArray *endArr = [sProgramBroadcastingEndTime componentsSeparatedByString:@" "];
    NSArray *endArr2 = [[endArr objectAtIndex:1] componentsSeparatedByString:@":"];
    
    NSString *sStart = [NSString stringWithFormat:@"%@:%@", [startArr2 objectAtIndex:0], [startArr2 objectAtIndex:1]];
    
    NSString *sEnd = [NSString stringWithFormat:@"%@:%@", [endArr2 objectAtIndex:0], [endArr2 objectAtIndex:1]];
    
    fCount = [[CMAppManager sharedInstance] getProgressViewBufferWithStartTime:sStart WithEndTime:sEnd];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Seoul"]];
    
    [dateFormatter setDateFormat:@"dd"];
    int nDay = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    
    NSArray *startArr3 = [[startArr objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSString *sStartDD = [NSString stringWithFormat:@"%@", [startArr3 objectAtIndex:2]];
    
    if ( nDay != [sStartDD intValue] )
    {
        fCount = 0;
    }
    
    return fCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 66;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.todayNewDateArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - 델리게이트
#pragma mark - EpgSubTableViewCellDelegate
- (void)EpgSubTableViewMoreBtn:(int)nIndex
{
    if ( [self getProgressTimerWithIndex:nIndex] > 0 )
    {
        // tv로 시청
        [self requestWithChannelControl];
    }
    else
    {
        // 시청 예약 체크
        if ( [[self getWatchReserveIndex:nIndex] isEqualToString:@"시청예약설정"] )
        {
            // 설정 해제
            CMDBDataManager *manager = [CMDBDataManager sharedInstance];
            [manager setWatchReserveList:[self.todayNewDateArr objectAtIndex:nIndex]];
            
            NSMutableArray* state = [self.pNowStateCheckArr objectAtIndex:nIndex][@"cellState"];
            [state addObject:@"시청예약"];
            [[self.pNowStateCheckArr objectAtIndex:nIndex] setObject:state forKey:@"cellState"];
            
            [[self.pNowStateCheckArr objectAtIndex:nIndex] setObject:@"시청예약취소" forKey:@"moreState"];
        }
        else
        {
            // 시청 예약 설정
            CMDBDataManager *manager = [CMDBDataManager sharedInstance];
            [manager removeWatchReserveList:[self.todayNewDateArr objectAtIndex:nIndex]];
            
            NSMutableArray* state = [self.pNowStateCheckArr objectAtIndex:nIndex][@"cellState"];
            for (NSString* value in state) {
                if ([value isEqualToString:@"시청예약"]) {
                    [state removeObject:value];
                    break;
                }
            }
            [[self.pNowStateCheckArr objectAtIndex:nIndex] setObject:state forKey:@"cellState"];
            [[self.pNowStateCheckArr objectAtIndex:nIndex] setObject:@"시청예약설정" forKey:@"moreState"];
        }
        
        [self.pTableView reloadData];
    }
}

- (void)EpgSubTableViewDeleteBtn:(int)nIndex
{
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [self.pListDataDic objectForKey:@"channelId"]];

    //  현재 방송중인 경우
    if ( [self getProgressTimerWithIndex:nIndex] > 0 )
    {
        BOOL isCheck = NO;
        for ( NSString *str in self.recordingchannelArr )
        {
            if ( [str isEqualToString:sChannelId] )
            {
                // 녹화중 -> 녹화중지 api 날린다.
                isCheck = YES;
            }
        }
        
        if ( isCheck == YES )
        {
            //  녹화중지
            [self requestWithSetRecordStopWithIndex:nIndex];
        }
        else
        {
            //  녹화요청
            [self requestWithSetRecordWithIndex:nIndex];
        }

    }
    else
    {
        // 시청예약인지 아닌지
        NSDictionary* item = self.todayNewDateArr[nIndex];
        NSString *sProgramBroadcastingStartTime = item[@"programBroadcastingStartTime"];
        
        //        NSString *sChannelId = [NSString stringWithFormat:@"%@", [self.pListDataDic objectForKey:@"channelId"]];
        
        BOOL isCheck = NO;
        for ( NSDictionary *dic in self.pRecordReservListArr )
        {
            NSString *sRecordStartTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"RecordStartTime"]];
            NSString *sChannelIdReserv = [NSString stringWithFormat:@"%@", [dic objectForKey:@"ChannelId"]];
            
            if ( [sRecordStartTime isEqualToString:sProgramBroadcastingStartTime] &&
                [sChannelId isEqualToString:sChannelIdReserv] )
            {
                // 녹화 예약중이다
                isCheck = YES;
                break;
            }
        }
        
        if ( isCheck == YES )
        {
            NSString* seriesId = item[@"seriesId"];
            // 녹화 예약중
            [self requestWithSetRecordCancelReserveWithReserveCancel:@"2" WithSeriesId:seriesId WithIndex:nIndex];
        }
        else
        {
            //  시리즈인 경우, 팝업 표출
            NSString* seriesId = item[@"seriesId"];
            
            //  단편
            if (seriesId == nil)
            {
                [self requstWithSetRecordReserveWithIndex:nIndex];
            }
            //  시리즈
            else
            {
                [SIAlertView alert:@"녹화예약확인" message:@"녹화예약을 하시겠습니까?"
                            cancel:@"취소"
                           buttons:@[@"시리즈예약", @"단편예약"]
                        completion:^(NSInteger buttonIndex, SIAlertView *alert) {

                            if ( buttonIndex == 1 )
                            {
                                [self requstWithSetRecordSeriesReserveWithSeries:seriesId WithIndex:nIndex];
                            }
                            else if ( buttonIndex == 2 )
                            {
                                [self requstWithSetRecordReserveWithIndex:nIndex];
                            }
                        }];
            }
        }
    }
}

#pragma mark - CMDateScrollViewDelegate

- (void)dateScrollView:(CMDateScrollView *)dateScrollView selectedIndex:(NSInteger)index
{
    self.nScrollDateIndex = (int)index;
    
    [self setListDataSplit];
    
    [self requestWithGetRecordReserveList];
}

#pragma mark - 전문
#pragma mark - 리모컨 상태 체크 전문
- (void)requestWithGetSetTopStatus
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary remoconGetSetTopStatusCompletion:^(NSArray *pairing, NSError *error) {
        
        DDLogError(@"리모컨 상태 체크 = [%@]", pairing);
        
        if ( [pairing count] == 0 )
            return;
        
        NSString *sRecordingchannel1 = [NSString stringWithFormat:@"%@", [[pairing objectAtIndex:0] objectForKey:@"recordingchannel1"]];
        NSString *sRecordingchannel2 = [NSString stringWithFormat:@"%@", [[pairing objectAtIndex:0] objectForKey:@"recordingchannel2"]];
        
        [self.recordingchannelArr removeAllObjects];
        
        [self.recordingchannelArr addObject:sRecordingchannel1];
        [self.recordingchannelArr addObject:sRecordingchannel2];
        
        [self requestWithChannelSchedule];
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 한 채널 편성 정보 전문
- (void)requestWithChannelSchedule
{
    CMAreaInfo* areaInfo = [[CMDBDataManager sharedInstance] currentAreaInfo];
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [self.pListDataDic objectForKey:@"channelId"]];
    NSURLSessionDataTask *tesk = [NSMutableDictionary epgGetChannelScheduleChannelId:sChannelId WithAreaCode:areaInfo.areaCode
    /*CNM_AREA_CODE*/ block:^(NSArray *gets, NSError *error) {
        
        DDLogError(@"한 채널 편성 정보 = [%@]", gets);
        
        [self.dataArray setArray:[[gets objectAtIndex:0] objectForKey:@"scheduleItem"]];
        
        [self setDateScroll];
        [self setListDataSplit];
        
        [self requestWithGetRecordReserveList];
        
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
        
        [self refreshCellState];
        
        [self.pTableView reloadData];
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 녹화예약설정 단일
- (void)requstWithSetRecordReserveWithIndex:(int)nIndex
{
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [self.pListDataDic objectForKey:@"channelId"]];
    NSString *sProgramBroadcastingStartTime = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:nIndex] objectForKey:@"programBroadcastingStartTime"]];    
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary epgSetRecordReserveWithChannelId:sChannelId WithStartTime:sProgramBroadcastingStartTime completion:^(NSArray *epgs, NSError *error) {
        
        DDLogError(@"녹화 예약 설정 단일 = [%@]", epgs);
        if ( [epgs count] == 0 )
            return;

        NSDictionary* epgItem = epgs[0];
        NSString* resultCode = epgItem[@"resultCode"];
        
        if ([[CMAppManager sharedInstance] checkSTBStateCode:resultCode]) {
            [self requestWithGetSetTopStatus];
//            [[self.pNowStateCheckArr objectAtIndex:nIndex] setObject:@"녹화예약중" forKey:@"cellState"];
//            [[self.pNowStateCheckArr objectAtIndex:nIndex] setObject:@"녹화예약취소" forKey:@"deleState"];
//            [self.pTableView reloadData];

        }
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 녹화예약설정 시리즈
- (void)requstWithSetRecordSeriesReserveWithSeries:(NSString *)series WithIndex:(int)nIndex
{
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [self.pListDataDic objectForKey:@"channelId"]];
    
    NSString *sProgramBroadcastingStartTime = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:nIndex] objectForKey:@"programBroadcastingStartTime"]];
    

    
    NSURLSessionDataTask *tesk = [NSMutableDictionary epgSetRecordSeriesReserveWithChannelId:sChannelId WithStartTime:sProgramBroadcastingStartTime WithSeriesId:series completion:^(NSArray *epgs, NSError *error) {
        
        DDLogError(@"녹화예약 설정 시리즈 = [%@]", epgs);
        
        if ( [epgs count] == 0 )
            return;
        
        NSString* resultCode = [[epgs objectAtIndex:0] objectForKey:@"resultCode"];
        
        if ([[CMAppManager sharedInstance] checkSTBStateCode:resultCode]) {
            NSMutableArray* state = [self.pNowStateCheckArr objectAtIndex:nIndex][@"cellState"];
            [state addObject:@"녹화예약중"];
            [[self.pNowStateCheckArr objectAtIndex:nIndex] setObject:state forKey:@"cellState"];
            [[self.pNowStateCheckArr objectAtIndex:nIndex] setObject:@"녹화예약취소" forKey:@"deleState"];
            [self.pTableView reloadData];
        }
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
    
}

#pragma mark - 녹화예약 취소
- (void)requestWithSetRecordCancelReserveWithReserveCancel:(NSString *)reserveCancel WithSeriesId:(NSString *)seriesId WithIndex:(int)nIndex
{
//    ReserveCancel = 1 (시리즈 전체 삭제) / ReserveCancel = 2 (단편 삭제)
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [self.pListDataDic objectForKey:@"channelId"]];
    NSString *sProgramBroadcastingStartTime = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:nIndex] objectForKey:@"programBroadcastingStartTime"]];
    
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary epgSetRecordCancelReserveWithChannelId:sChannelId WithStartTime:sProgramBroadcastingStartTime WithSeriesId:seriesId WithReserveCancel:reserveCancel completion:^(NSArray *epgs, NSError *error) {
        
        DDLogError(@"녹화에약취소 = [%@}", epgs);
        
        if ( [epgs count] == 0 )
            return;
        
        NSString* resultCode = [[epgs objectAtIndex:0] objectForKey:@"resultCode"];
        
        if ([[CMAppManager sharedInstance] checkSTBStateCode:resultCode]) {
//            NSMutableArray* state = [self.pNowStateCheckArr objectAtIndex:nIndex][@"cellState"];
//            for (NSString* value in state) {
//                if ([value isEqualToString:@"녹화예약중"]) {
//                    [state removeObject:value];
//                    break;
//                }
//            }
//            [state addObject:@"녹화예약설정"];
//            [[self.pNowStateCheckArr objectAtIndex:nIndex] setObject:state forKey:@"cellState"];
            [self requestWithGetSetTopStatus];
        }
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 즉시 녹화
- (void)requestWithSetRecordWithIndex:(int)index
{
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [self.pListDataDic objectForKey:@"channelId"]];
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary epgSetRecordWithChannelId:sChannelId completion:^(NSArray *epgs, NSError *error) {
        
        DDLogError(@"즉시 녹화 = [%@]", epgs);
        
        if ( [epgs count] == 0 )
            return;
        
        NSDictionary* epgItem = epgs[0];
        NSString* resultCode = epgItem[@"resultCode"];
        
        if ([[CMAppManager sharedInstance] checkSTBStateCode:resultCode]) {
            [self requestWithGetSetTopStatus];
//            [[self.pNowStateCheckArr objectAtIndex:index] setObject:@"녹화중" forKey:@"cellState"];
//            [[self.pNowStateCheckArr objectAtIndex:index] setObject:@"즉시 녹화 중지" forKey:@"deleState"];
//            [self.pTableView reloadData];
        }

    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 즉시 녹화 중지
- (void)requestWithSetRecordStopWithIndex:(int)index
{
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [self.pListDataDic objectForKey:@"channelId"]];
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary epgSetRecordStopWithChannelId:sChannelId completion:^(NSArray *epgs, NSError *error) {
        
        DDLogError(@"즉시 녹화 중지 = [%@]", epgs);
        
        if ( [epgs count]  ==  0 )
            return;
        
        if ( [[[epgs objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
        {
            [self requestWithGetSetTopStatus];
            
//            [[self.pNowStateCheckArr objectAtIndex:index] setObject:@"" forKey:@"cellState"];
//            [[self.pNowStateCheckArr objectAtIndex:index] setObject:@"즉시 녹화 중지" forKey:@"deleState"];
//            [self.pTableView reloadData];
        }
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 체널 변경 전문
- (void)requestWithChannelControl
{
//    NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:0] objectForKey:@"programId"]];
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [self.pListDataDic objectForKey:@"channelId"]];
    NSURLSessionDataTask *tesk = [NSMutableDictionary remoconSetRemoteChannelControlWithChannelId:sChannelId completion:^(NSArray *pairing, NSError *error) {
        
        DDLogError(@"pairing = [%@]", pairing);
        
        NSDictionary* item = pairing[0];
        NSString* resultCode = item[@"resultCode"];
        
        if ([[CMAppManager sharedInstance] checkSTBStateCode:resultCode]) {
            // 체널 변경 성공
        }
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}


- (void)setDateScroll
{
    self.scrollDateArray = [@[] mutableCopy];
    NSString *sStartTime = @"";
    NSString *sPrevStartTime = @"";
    int nCount = 0;
    for ( NSDictionary *dic in self.dataArray )
    {
        sStartTime = [NSDate stringFromDateString:dic[@"programBroadcastingStartTime"] beforeFormat:@"YYYY-MM-dd HH:mm:SS" afterFormat:@"MM.dd"];
        if ( nCount == 0 )
        {
            [self.scrollDateArray addObject:sStartTime];
        }
        else
        {
            sPrevStartTime = [NSDate stringFromDateString:self.dataArray[nCount - 1][@"programBroadcastingStartTime"] beforeFormat:@"YYYY-MM-dd HH:mm:SS" afterFormat:@"MM.dd"];
            if ( ![sPrevStartTime isEqualToString:sStartTime] )
            {
                [self.scrollDateArray addObject:sStartTime];
            }
        }
        
        nCount++;
    }
    
    [self.dateScrollView setDateArray:self.scrollDateArray];
    [self.dateScrollView setSelectedIndex:self.nScrollDateIndex];
}

/**
 *  선택된 날짜(_nScrollDateIndex) 기준으로 방송 목록(_dataArray)을 필터링해서 _todayNewDateArr, _pNowStateCheckArr에 저장한다.
 */
- (void)setListDataSplit
{
    NSString *sTwoDay = [NSString stringWithFormat:@"%@", [self.scrollDateArray objectAtIndex:self.nScrollDateIndex]];
    
    [self.todayNewDateArr removeAllObjects];
    [self.pNowStateCheckArr removeAllObjects];
    
    for ( NSDictionary *dic in self.dataArray )
    {
        NSString *sStartDate = [NSDate stringFromDateString:dic[@"programBroadcastingStartTime"] beforeFormat:@"YYYY-MM-dd HH:mm:SS" afterFormat:@"MM.dd"];
        if ( [sStartDate isEqualToString:sTwoDay] )
        {
            [self.todayNewDateArr addObject:dic];
            
            NSMutableDictionary *stateDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[@[] mutableCopy], @"cellState", @"", @"moreState", @"", @"deleState", nil];
            [self.pNowStateCheckArr addObject:stateDic];
        }
    }
}

- (void)backCommonAction
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate EpgSubViewWithTag:0];
}

#pragma mark - 시청예약 체크
- (BOOL)getWatchReserveIndex2:(int)index
{
    NSString *sTilte = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:index] objectForKey:@"programTitle"]];
    NSString *sStartTime = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:index] objectForKey:@"programBroadcastingStartTime"]];
    NSString *sSeq = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:index] objectForKey:@"scheduleSeq"]];
    NSString *sProgramId = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:index] objectForKey:@"programId"]];
    NSString *sHd = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:index] objectForKey:@"programHD"]];
    
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
//    // 체널 id 로 체크
//    NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:index] objectForKey:@"programId"]];
//    
//    BOOL isCheck = NO;
//    for ( NSString *str in self.recordingchannelArr )
//    {
//        if ( [str isEqualToString:sChannelId] )
//        {
//            isCheck = YES;
//        }
//    }
//    return isCheck;
    
    //현재시간정보
    /*NSString* strNow = [NSDate stringFromDate:[NSDate date] withFormat:@"YYYYMMddHHmmSS"];
    
    //채널가이드의 현재채널과 녹화예약시간
    NSString *sRecordStartTime = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:index] objectForKey:@"programBroadcastingStartTime"]];
    NSString *sRecordEndTime = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:index] objectForKey:@"programBroadcastingEndTime"]];
    sRecordStartTime = [NSDate stringFromDateString:sRecordStartTime beforeFormat:@"YYYY-MM-dd HH:mm:SS" afterFormat:@"YYYYMMddHHmmSS"];
    sRecordEndTime = [NSDate stringFromDateString:sRecordEndTime beforeFormat:@"YYYY-MM-dd HH:mm:SS" afterFormat:@"YYYYMMddHHmmSS"];
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [self.pListDataDic objectForKey:@"channelId"]];
    
    BOOL isCheck = NO;
    for ( NSDictionary *dic in self.pRecordReservListArr ) {
        NSString *sDicRecordStartTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"RecordStartTime"]];
        NSString *sDicRecordEndTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"RecordEndTime"]];
        sDicRecordStartTime = [NSDate stringFromDateString:sDicRecordStartTime beforeFormat:@"YYYY-MM-dd HH:mm:SS" afterFormat:@"YYYYMMddHHmmSS"];
        sDicRecordEndTime = [NSDate stringFromDateString:sDicRecordEndTime beforeFormat:@"YYYY-MM-dd HH:mm:SS" afterFormat:@"YYYYMMddHHmmSS"];
        NSString *sDicChannelId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"ChannelId"]];
        
        if ( [sRecordStartTime isEqualToString:sDicRecordStartTime] &&
            [sChannelId isEqualToString:sDicChannelId] )
        {
            double now = [strNow doubleValue];
            double start = [sRecordStartTime doubleValue];
            double end = [sRecordEndTime doubleValue];
            if (now >= start && now < end ) {
                isCheck = YES;
            }
            break;
        }
    }*/
    
    NSString* strNow = [NSDate stringFromDate:[NSDate date] withFormat:@"YYYYMMddHHmmSS"];
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [self.pListDataDic objectForKey:@"channelId"]];
    NSString *sRecordStartTime = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:index] objectForKey:@"programBroadcastingStartTime"]];
    NSString *sRecordEndTime = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:index] objectForKey:@"programBroadcastingEndTime"]];
    sRecordStartTime = [NSDate stringFromDateString:sRecordStartTime beforeFormat:@"YYYY-MM-dd HH:mm:SS" afterFormat:@"YYYYMMddHHmmSS"];
    sRecordEndTime = [NSDate stringFromDateString:sRecordEndTime beforeFormat:@"YYYY-MM-dd HH:mm:SS" afterFormat:@"YYYYMMddHHmmSS"];
    
    double now = [strNow doubleValue];
    double start = [sRecordStartTime doubleValue];
    double end = [sRecordEndTime doubleValue];
    BOOL isRecord = NO;
    if (now >= start && now < end )
    {
        for (NSString* recordingchannel in self.recordingchannelArr)
        {
            if ([sChannelId isEqualToString:recordingchannel])
            {
                isRecord = YES;
                break;
            }
        }
    }
    
    return isRecord;
}

#pragma mark - 녹화 예약 체크
- (BOOL)getRecordReservListIndex:(int)index
{
    NSString *sRecordStartTime = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:index] objectForKey:@"programBroadcastingStartTime"]];
//    NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:index] objectForKey:@"programId"]];
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [self.pListDataDic objectForKey:@"channelId"]];
    
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

- (void)refreshCellState
{
    for ( int i =0; i < [self.pNowStateCheckArr count]; i++ )
    {
        [self setCellStateIndex:i];
    }
}

- (void)setCellStateIndex:(int)index
{

    
    NSMutableArray* state = [@[] mutableCopy];
    if ( [self getWatchReserveIndex2:index] == YES )
    {
        [state addObject:@"시청예약"];
    }
    
    if ( [self getRecordReservListIndex:index] == YES )
    {
        [state addObject:@"녹화예약중"];
    }

    if ( [self getRecordingChannelIndex:index] == YES )
    {
        [state addObject:@"녹화중"];
    }
    
    [[self.pNowStateCheckArr objectAtIndex:index] setObject:state forKey:@"cellState"];
    
    
/*
 -       미연동, SMART : 현재방송(기능없음), 미래방송(시청예약설정/시청예약취소)
 -       HD : 현재방송(TV로 시청), 미래방송(시청예약설정/시청예약취소)
 -       PVR : 현재방송(즉시녹화/녹화중지, TV로 시청), 미래방송(녹화예약설정/녹화예약취소, 시청예약설정/시청예약취소
 */
    NSString* sKind = [[CMDBDataManager sharedInstance] getSetTopBoxKind];
    if (sKind.length == 0) {
        return;
    }
    else if ([sKind isEqualToString:@"SMART"]) {
        [[self.pNowStateCheckArr objectAtIndex:index] setObject:@"시청예약설정" forKey:@"moreState"];
        [[self.pNowStateCheckArr objectAtIndex:index] setObject:@"시청예약취소" forKey:@"deleState"];
        return;
    }
    
    NSString *sMore = @"";
    NSString *sDele = @"";
    if ( [self getProgressTimerWithIndex:index] > 0 )
    {
        // 현재 시간
        sMore = @"TV로 시청";
        
        if ([sKind isEqualToString:@"PVR"]) {
            if ( [self getRecordingChannelIndex:index] == YES )
            {
                // 녹화중이기 때문에 녹화중지로
                sDele = @"즉시 녹화 중지";
            }
            else
            {
                sDele = @"즉시 녹화";
            }
        }

    }
    else
    {
        if ( [self getWatchReserveIndex2:index] == YES )
        {
            // 시청 예약중이기 때문에 시청 예약 취소로
            sMore = @"시청예약취소";
        }
        else
        {
            // 시청 예약 취소이기 때문에 시청 예약중으로
            sMore = @"시청예약설정";
        }
        
        if ([sKind isEqualToString:@"PVR"]) {
            if ( [self getRecordReservListIndex:index] == YES )
            {
                // 녹화예약중이면 녹화예약취소로
                sDele = @"녹화예약취소";
            }
            else
            {
                // 녹화예약취소이면 녹화예약설정으로
                sDele = @"녹화예약설정";
            }
        }

    }
    
    [[self.pNowStateCheckArr objectAtIndex:index] setObject:sMore forKey:@"moreState"];
    [[self.pNowStateCheckArr objectAtIndex:index] setObject:sDele forKey:@"deleState"];
}

@end
