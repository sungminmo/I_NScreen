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
    
    [self setViewInit];
    
    [self requestWithGetSetTopStatus];
//    [self requestWithChannelSchedule];
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
    
//    NSMutableArray* dateArray = [@[] mutableCopy];
//    
//    for (int i = 0; i < 20; i++) {
//        [dateArray addObject:[NSString stringWithFormat:@"12월%02d일", i]];
//    }
//    
//    [self.dateScrollView setDateArray:dateArray];
    
    CMDBDataManager *manager = [CMDBDataManager sharedInstance];
    RLMArray *ramArr = [manager getFavorChannel];
    
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [self.pListDataDic objectForKey:@"channelId"]];
    
    BOOL isCheck = NO;
    for ( CMFavorChannelInfo *info in ramArr )
    {
        if ( [info.pChannelId isEqualToString:sChannelId] )
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
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [self.pListDataDic objectForKey:@"channelId"]];
    CMDBDataManager *manager = [CMDBDataManager sharedInstance];
    RLMArray *ramArr = [manager getFavorChannel];
    BOOL isCheck = NO;
    
    int nCount = 0;
    for ( CMFavorChannelInfo *info in ramArr )
    {
        if ( [info.pChannelId isEqualToString:sChannelId] )
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

#pragma mark - Privates

/**
 *  테스트용 데이터 셋팅, 추후 삭제.
 */
#warning TEST
- (void)setTestData {
    
    self.title = @"CH.05 KBS";
    
    [self.logoImageView setImageWithURL:[NSURL URLWithString:@"http://58.141.255.69:8080/logo/193.png"]];
    
    NSMutableArray* dateArray = [@[] mutableCopy];
    
    for (int i = 0; i < 20; i++) {
        [dateArray addObject:[NSString stringWithFormat:@"12월%02d일", i]];
    }
    
    [self.dateScrollView setDateArray:dateArray];
    
    for (int i = 0; i < 30; i++) {
        
        NSString* grade;
        if (i%3 == 1)       grade = @"19";
        else if (i%3 == 2)  grade = @"15";
        else                grade = @"모두";

        [self.dataArray addObject:@{@"title":@"뉴스파이터", @"time":@"15:00~16:00", @"grade":grade, @"hd":@"Y", @"progress":@(1)}];
    }
    
    [self.pTableView reloadData];
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
    [cell setData:data WithIndex:(int)indexPath.row];

    NSString *sMore = @"시청예약설정";
    NSString *sDelete = @"녹화 예약 설정";
    
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [self.pListDataDic objectForKey:@"channelId"]];

    if ( [self getProgressTimerWithIndex:(int)indexPath.row] > 0 )
    {
        // 오늘 지금 시간
        sMore = @"TV로 시청";
        sDelete = @"즉시 녹화";
        for ( NSString *str in self.recordingchannelArr )
        {
            if ( [str isEqualToString:sChannelId] )
            {
                sDelete = @"즉시 녹화 중지";
            }
        }
    }
    else
    {
        // 방영예정중
        // 시청예약설정, 녹화예약설정
        
        NSString *sProgramBroadcastingStartTime = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:indexPath.row] objectForKey:@"programBroadcastingStartTime"]];
        
//        NSString *sChannelId = [NSString stringWithFormat:@"%@", [self.pListDataDic objectForKey:@"channelId"]];
        
        for ( NSDictionary *dic in self.pRecordReservListArr )
        {
            NSString *sRecordStartTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"RecordStartTime"]];
            NSString *sChannelIdReserv = [NSString stringWithFormat:@"%@", [dic objectForKey:@"ChannelId"]];
            
            if ( [sRecordStartTime isEqualToString:sProgramBroadcastingStartTime] &&
                [sChannelId isEqualToString:sChannelIdReserv] )
            {
                // 녹화예약취소
                sDelete = @"녹화예약취소";
            }
        }
    }
    
    [cell configureCellForItem:@{@"More":sMore, @"Delete":sDelete} WithItemCount:2];
    
    return cell;
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
//    if ( nIndex == 0 )
//    {
//        // tv 로 시청 전문
//        if ( [self getProgressTimerWithIndex:nIndex] > 0 )
//        {
//            // tv로 시청
//            [self requestWithChannelControl];
//        }
//        else
//        {
//            // 모르겠다
//        }
//
//        
////        [self requestWithChannelControl];
//    }
//    else
//    {
//        
//    }
    
   
}

- (void)EpgSubTableViewDeleteBtn:(int)nIndex
{
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [self.pListDataDic objectForKey:@"channelId"]];

    if ( [self getProgressTimerWithIndex:nIndex] > 0 )
    {
        // 시청중
        BOOL isCheck = NO;
        for ( NSString *str in self.recordingchannelArr )
        {
            if ( [str isEqualToString:sChannelId] )
            {
                isCheck = YES;
                // 녹화중 -> 녹화중지 api 날린다.
            }
        }
        
        if ( isCheck == YES )
        {
            [self requestWithSetRecordStop];
        }
        else
        {
            [self requestWithSetRecord];
        }

    }
    else
    {
        // 시청예약인지 아닌지
        NSString *sSeries = [NSString stringWithFormat:@"%@", [[self.pRecordReservListArr objectAtIndex:nIndex] objectForKey:@"SeriesId"]];
    
        
        NSString *sProgramBroadcastingStartTime = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:nIndex] objectForKey:@"programBroadcastingStartTime"]];
        
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
            }
        }
        
        if ( isCheck == YES )
        {
            // 녹화 예약중
            if ( [sSeries isEqualToString:@"NULL"] )
            {
                // 단일
                [self requestWithSetRecordCancelReserveWithReserveCancel:@"2" WithSeriesId:0 WithIndex:nIndex];
            }
            else
            {
                // 시리즈
                [self requestWithSetRecordCancelReserveWithReserveCancel:@"1" WithSeriesId:sSeries WithIndex:nIndex];
            }

        }
        else
        {
            // 녹화 미예약
            if ( [sSeries isEqualToString:@"NULL"] )
            {
                // 단일
                [self requstWithSetRecordReserveWithIndex:nIndex];
            }
            else
            {
                // 시리즈
                [self requstWithSetRecordSeriesReserveWithSeries:sSeries WithIndex:nIndex];
            }

        }
    }
}

#pragma mark - CMDateScrollViewDelegate

- (void)dateScrollView:(CMDateScrollView *)dateScrollView selectedIndex:(NSInteger)index {
    NSLog(@"dateScrollView : %ld", (long)index);
    self.nScrollDateIndex = (int)index;
    
    [self setListDataSplit];
    [self.pTableView reloadData];
}


#pragma mark - 전문
#pragma mark - 녹화예약설정 단일
- (void)requstWithSetRecordReserveWithIndex:(int)nIndex
{
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [self.pListDataDic objectForKey:@"channelId"]];
    NSString *sProgramBroadcastingStartTime = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:nIndex] objectForKey:@"programBroadcastingStartTime"]];    
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary epgSetRecordReserveWithChannelId:sChannelId WithStartTime:sProgramBroadcastingStartTime completion:^(NSArray *epgs, NSError *error) {
        
        DDLogError(@"녹화 예약 설정 단일 = [%@]", epgs);
        if ( [epgs count] == 0 )
            return;
        
        if ( [[[epgs objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
        {
            [self requestWithGetSetTopStatus];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
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
        
        if ( [[[epgs objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
        {
            [self requestWithGetSetTopStatus];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
    
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
        
        if ( [[[epgs objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
        {
            [self requestWithGetSetTopStatus];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 즉시 녹화
- (void)requestWithSetRecord
{
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [self.pListDataDic objectForKey:@"channelId"]];
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary epgSetRecordWithChannelId:sChannelId completion:^(NSArray *epgs, NSError *error) {
        
        DDLogError(@"즉시 녹화 = [%@]", epgs);
        
        if ( [epgs count] == 0 )
            return;
        
        if ( [[[epgs objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
        {
            [self requestWithGetSetTopStatus];
        }
        else if ( [[[epgs objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"003"] )
        {
            
            [SIAlertView alert:@"즉시녹화" message:@"셋탑박스의 저장공간이 부족합니다. 녹화물 목록을 확인해주세요."
                        cancel:nil
                       buttons:@[@"확인"]
                    completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                        
                    }];
        }
        else if ( [[[epgs objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"009"] )
        {
            
            [SIAlertView alert:@"즉시녹화" message:@"고객님의 셋탑박스에서 제공되지 않는 채널입니다."
                        cancel:nil
                       buttons:@[@"확인"]
                    completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                        
                    }];
        }
        else if ( [[[epgs objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"010"] )
        {
            
            [SIAlertView alert:@"즉시녹화" message:@"셋탑박스에서 동시화면 기능을 사용중인 경우 즉시 녹화가 불가능합니다."
                        cancel:nil
                       buttons:@[@"확인"]
                    completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                        
                    }];
        }
        else if ( [[[epgs objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"011"] )
        {
            
            [SIAlertView alert:@"즉시녹화" message:@"고객님의 셋탑박스 설정에 의한 시청제한으로 녹화가 불가합니다. 셋탑박스 설정을 확인해주세요."
                        cancel:nil
                       buttons:@[@"확인"]
                    completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                        
                    }];
        }
        else if ( [[[epgs objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"014"] )
        {
            
            [SIAlertView alert:@"즉시녹화" message:@"셋탑박스의 뒷 전원이 꺼져있거나, 통신이 고르지 못해 녹화가 불가합니다. 셋탑박스의 상태를 확인해주세요."
                        cancel:nil
                       buttons:@[@"확인"]
                    completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                        
                    }];
        }
        
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 즉시 녹화 중지
- (void)requestWithSetRecordStop
{
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [self.pListDataDic objectForKey:@"channelId"]];
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary epgSetRecordStopWithChannelId:sChannelId completion:^(NSArray *epgs, NSError *error) {
        
        DDLogError(@"즉시 녹화 중지 = [%@]", epgs);
        
        if ( [epgs count]  ==  0 )
            return;
        
        if ( [[[epgs objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
        {
            [self requestWithGetSetTopStatus];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
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
        
       [self.pTableView reloadData];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 한 채널 편성 정보 전문
- (void)requestWithChannelSchedule
{
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [self.pListDataDic objectForKey:@"channelId"]];
    NSURLSessionDataTask *tesk = [NSMutableDictionary epgGetChannelScheduleChannelId:sChannelId WithAreaCode:CNM_AREA_CODE block:^(NSArray *gets, NSError *error) {
        
        DDLogError(@"한 채널 편성 정보 = [%@]", gets);
        
        [self.dataArray setArray:[[gets objectAtIndex:0] objectForKey:@"scheduleItem"]];
        
        [self setDateScroll];
        [self setListDataSplit];
        
        [self requestWithGetRecordReserveList];
 
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

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
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 체널 변경 전문
- (void)requestWithChannelControl
{
//    NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:0] objectForKey:@"programId"]];
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [self.pListDataDic objectForKey:@"channelId"]];
    NSURLSessionDataTask *tesk = [NSMutableDictionary remoconSetRemoteChannelControlWithChannelId:sChannelId completion:^(NSArray *pairing, NSError *error) {
        
        DDLogError(@"pairing = [%@]", pairing);
        
        if ( [[[pairing objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
        {
            // 체널 변경 성공
            
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
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
}

- (void)setListDataSplit
{
    NSString *sTwoDay = [NSString stringWithFormat:@"%@", [self.scrollDateArray objectAtIndex:self.nScrollDateIndex]];
    
    [self.todayNewDateArr removeAllObjects];
    
    for ( NSDictionary *dic in self.dataArray )
    {
        NSString *sStartDate = [NSDate stringFromDateString:dic[@"programBroadcastingStartTime"] beforeFormat:@"YYYY-MM-dd HH:mm:SS" afterFormat:@"MM.dd"];
        if ( [sStartDate isEqualToString:sTwoDay] )
        {
            [self.todayNewDateArr addObject:dic];
        }
    }
    
    
}

- (void)backCommonAction
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate EpgSubViewWithTag:0];
}

@end
