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

@end

@implementation EpgSubViewController
@synthesize pListDataDic;

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topConstraint.constant = cmNavigationHeight;
    
    self.isUseNavigationBar = YES;
   
    [self showFavoriteButton:true];
    
    self.dataArray = [@[] mutableCopy];
    self.todayNewDateArr = [@[] mutableCopy];
    self.recordingchannelArr = [@[] mutableCopy];
    
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

#pragma mark - Event

/**
 *  Override
 *  네비게이션바 즐겨찾기 버튼 이벤트 함수
 */
- (void)favoriteButton:(id)sender {
    
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
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:indexPath.row] objectForKey:@"channelId"]];
    if ( self.nScrollDateIndex == 0 && indexPath.row == 0 )
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
        // 모르겠다
    }
    
    [cell configureCellForItem:@{@"More":sMore, @"Delete":sDelete} WithItemCount:2];
    
    return cell;
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
    if ( nIndex == 0 )
    {
        // tv 로 시청 전문 날림
        [self requestWithChannelControl];
    }
}

- (void)EpgSubTableViewDeleteBtn:(int)nIndex
{
    
}

#pragma mark - CMDateScrollViewDelegate

- (void)dateScrollView:(CMDateScrollView *)dateScrollView selectedIndex:(NSInteger)index {
    NSLog(@"dateScrollView : %ld", (long)index);
    self.nScrollDateIndex = (int)index;
    
    [self setListDataSplit];
    [self.pTableView reloadData];
}


#pragma mark - 전문
#pragma mark - 한 채널 편성 정보 전문
- (void)requestWithChannelSchedule
{
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [self.pListDataDic objectForKey:@"channelId"]];
    NSURLSessionDataTask *tesk = [NSMutableDictionary epgGetChannelScheduleChannelId:sChannelId WithAreaCode:CNM_AREA_CODE block:^(NSArray *gets, NSError *error) {
        
        DDLogError(@"한 채널 편성 정보 = [%@]", gets);
        
        [self.dataArray setArray:[[gets objectAtIndex:0] objectForKey:@"scheduleItem"]];
        
        [self setDateScroll];
        [self setListDataSplit];
        [self.pTableView reloadData];
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
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.todayNewDateArr objectAtIndex:0] objectForKey:@"channelId"]];
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
        sStartTime = [NSString stringWithFormat:@"%@", [[CMAppManager sharedInstance] getSplitScrollWithDateStr:[dic objectForKey:@"programBroadcastingStartTime"]]];
        
        if ( nCount == 0 )
        {
            [self.scrollDateArray addObject:sStartTime];
        }
        else
        {
            sPrevStartTime = [NSString stringWithFormat:@"%@",[[CMAppManager sharedInstance] getSplitScrollWithDateStr: [[self.dataArray objectAtIndex:nCount - 1] objectForKey:@"programBroadcastingStartTime"]]];

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
        NSString *sStartDate = [NSString stringWithFormat:@"%@", [[CMAppManager sharedInstance] getSplitScrollWithDateStr:[dic objectForKey:@"programBroadcastingStartTime"]]];
        
        if ( [sStartDate isEqualToString:sTwoDay] )
        {
            [self.todayNewDateArr addObject:dic];
        }
    }
    
    
}

@end
