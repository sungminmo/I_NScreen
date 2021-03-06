//
//  PvrMainViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "PvrMainViewController.h"
#import "NSMutableDictionary+PVR.h"
#import "UIAlertView+AFNetworking.h"
#import "NSMutableDictionary+REMOCON.h"
#import "NSMutableDictionary+EPG.h"
#import "CMAppManager.h"

@interface PvrMainViewController ()

@property (nonatomic, strong) NSMutableArray *pListArr;         // 녹화물
@property (nonatomic, strong) NSMutableArray *pReservListArr;   // 예약 녹화
@property (nonatomic, strong) NSMutableArray *pSeriesReservDetailArr;   // 예약녹화 시리즈 이면서 상세 데이터

@property (nonatomic, weak) IBOutlet UIButton *pReservationBtn; // 녹화 예약 관리 버튼
@property (nonatomic, weak) IBOutlet UIButton *pListBtn;        // 녹화물 목록 버튼
@property (nonatomic, weak) IBOutlet UITableView *pTableView;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

//@property (nonatomic) BOOL isReservCheck;     // 초기 no, 한번 에러 나면 yes 로 바꿔주고 한번더 전문태움
//@property (nonatomic) BOOL isListCheck;         // 상동
@property (nonatomic) BOOL isTabCheck;          // 초기 no 이면 녹화 예약관리, yes 면 녹화물 목록
@property (nonatomic, strong) NSMutableArray *pPvringListArr;  // 녹화중 목록 리스트

- (IBAction)onBtnClick:(UIButton *)btn;

@end

@implementation PvrMainViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.topConstraint.constant = cmNavigationHeight;
    
    self.title = @"녹화";
    
    self.isUseNavigationBar = YES;
    
    [self setTagInit];
    [self setViewInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}


#pragma mark - 초기화
#pragma mark - 화면 태그값 초기화
- (void)setTagInit
{
    self.pReservationBtn.tag = PVR_MAIN_VIEW_BTN_02;
    self.pListBtn.tag = PVR_MAIN_VIEW_BTN_03;
}

#pragma mark - 화면 초기화
-(void)setViewInit
{
    if (self.pListArr) {
        [self.pListArr removeAllObjects];
        [self.pReservListArr removeAllObjects];
        [self.pSeriesReservDetailArr removeAllObjects];
    } else {
        self.pListArr = [[NSMutableArray alloc] init];
        self.pReservListArr = [[NSMutableArray alloc] init];
        self.pSeriesReservDetailArr = [[NSMutableArray alloc] init];
    }

    [self.pTableView reloadData];
    // 초기 예약 녹화 리스트
    
    [self setInfoWithCount:-1];
//    [self requestWithGetSetTopStatus];//미사용 2015.12.07 - AOS소스보고 미사용으로 맞춤
    [self requestWithRecordReservelist];
}

- (void)resetData
{
    [self.pListArr removeAllObjects];
    [self.pReservListArr removeAllObjects];
    [self.pSeriesReservDetailArr removeAllObjects];
    
    [self.pTableView reloadData];
}

#pragma mark - Private

/**
 *  검색된 목록 수를 표시한다.
 *
 *  @param count 목록수, 0보다 작은 경우 메세지를 표출하지 않는다.
 */
- (void)setInfoWithCount:(NSInteger)count {
    
    if (count < 0) {
        count = 0;
    }
    
    if ( self.isTabCheck == YES )
    {
        // 녹화물 목록
        self.infoLabel.text = [NSString stringWithFormat:@"총 %ld개의 녹화물 콘텐츠가 있습니다.", (long)count];
    }
    else
    {
        // 녹화예약관리
        self.infoLabel.text = [NSString stringWithFormat:@"총 %ld개의 녹화예약 콘텐츠가 있습니다.", (long)count];
    }
}

#pragma mark - Event
- (IBAction)onBtnClick:(UIButton *)btn
{
    //탭버튼 이벤트 방어코드 추가
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    switch (btn.tag) {
        case PVR_MAIN_VIEW_BTN_02:
        {
            //탭버튼 이벤트 방어코드 추가
            [self.pListArr removeAllObjects];
            [self setInfoWithCount:0];
            [self.pTableView reloadData];
            
            // 녹화 예약 관리
            self.isTabCheck = NO;
            [self.pReservationBtn setBackgroundImage:[UIImage imageNamed:@"2btn_select.png"] forState:UIControlStateNormal];
            [self.pListBtn setBackgroundImage:[UIImage imageNamed:@"2btn_normal.png"] forState:UIControlStateNormal];
            
            [self.pReservationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.pListBtn setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            
            [self requestWithGetSetTopStatus];
        }break;
        case PVR_MAIN_VIEW_BTN_03:
        {
            //탭버튼 이벤트 방어코드 추가
            [self.pReservListArr removeAllObjects];
            [self.pSeriesReservDetailArr removeAllObjects];
            [self setInfoWithCount:0];
            [self.pTableView reloadData];
            
            // 녹화물 목록
            self.isTabCheck = YES;
            [self.pReservationBtn setBackgroundImage:[UIImage imageNamed:@"2btn_normal.png"] forState:UIControlStateNormal];
            [self.pListBtn setBackgroundImage:[UIImage imageNamed:@"2btn_select.png"] forState:UIControlStateNormal];
            
            [self.pReservationBtn setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [self requestWithRecordList];
        }break;
    }
}

/**
 *  Override
 *  즐겨찾기 버튼 이벤트
 */
- (void)favoriteButton:(id)sender {
    
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *pCellIn = @"PvrMainTableViewCellIn";
    
    PvrMainTableViewCell *pCell = (PvrMainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:pCellIn];
    
    if (pCell == nil)
    {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PvrMainTableViewCell" owner:nil options:nil];
        pCell = [arr objectAtIndex:0];
    }
    
    [pCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //  녹화물 목록
    if ( self.isTabCheck == YES )
    {
        [pCell setListDataList:[self.pListArr objectAtIndex:indexPath.row] WithIndex:(int)indexPath.row];
    }
    //  녹화 예약 목록
    else
    {
        BOOL isCheck = NO;
        NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.pReservListArr objectAtIndex:indexPath.row] objectForKey:@"ChannelId"]];
        for ( NSString *str in self.pPvringListArr )
        {
            if ( [str isEqualToString:sChannelId] )
            {
//                sDelete = @"즉시 녹화 중지";
                isCheck = YES;
            }
        }
        [pCell setListDataReservation:[self.pReservListArr objectAtIndex:indexPath.row] WithIndex:(int)indexPath.row WithRecordCheck:isCheck];
        
    }
    
    return pCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 녹화물 목록
    if ( self.isTabCheck == YES )
    {
        NSString *sSeriesId = [NSString stringWithFormat:@"%@", [[self.pListArr objectAtIndex:indexPath.row] objectForKey:@"SeriesId"]];
        
        if ([sSeriesId isEqualToString:@"NULL"] == false)
        {
            // 시리즈
            PvrSubViewController *pViewController = [[PvrSubViewController alloc] initWithNibName:@"PvrSubViewController" bundle:nil];
            pViewController.delegate = self;
            pViewController.pSeriesIdStr = [[self.pListArr objectAtIndex:indexPath.row] objectForKey:@"SeriesId"];
            pViewController.pTitleStr = [[self.pListArr objectAtIndex:indexPath.row] objectForKey:@"ProgramName"];
            pViewController.isTapCheck = YES;
            [self.navigationController pushViewController:pViewController animated:YES];

        }
    }
    // 녹화예약관리
    else
    {
        NSString* seriesId = ((NSDictionary*)self.pReservListArr[indexPath.row])[@"SeriesId"];
        
        if ([seriesId isEqualToString:@"NULL"] == NO) {
            
            NSDictionary* item = self.pReservListArr[indexPath.row];
            NSString* seiresId = item[@"SeriesId"];
            NSString* title = item[@"ProgramName"];
            NSMutableArray* filteredArray = [[self.pSeriesReservDetailArr filteredArrayUsingPredicate:
                                              [NSPredicate predicateWithFormat:@"SeriesId == %@", seiresId]] mutableCopy];
            
            PvrSubViewController *pViewController = [[PvrSubViewController alloc] initWithNibName:@"PvrSubViewController" bundle:nil];
            pViewController.delegate = self;
            pViewController.pSeriesIdStr = seiresId;
            pViewController.pTitleStr = title;
            pViewController.isTapCheck = NO;
            pViewController.pSeriesReserveListArr = filteredArray;
            
            [self.navigationController pushViewController:pViewController animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 66;
 
    if ( self.isTabCheck == YES )
    {
        // 녹화물 목록
        NSString *sSeriesId = [NSString stringWithFormat:@"%@", [[self.pListArr objectAtIndex:indexPath.row] objectForKey:@"SeriesId"]];
        
        if ( [sSeriesId isEqualToString:@"NULL"] )
        {
            // 단편
            height = 90;
        }
        else
        {
            // 시리즈
            height = 66;
        }
    }
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.isTabCheck == YES )
        return (int)[self.pListArr count];
    else
        return (int)[self.pReservListArr count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 녹화물 목록
    if ( self.isTabCheck == YES )
    {
        NSString *sSeriesId = [NSString stringWithFormat:@"%@", [[self.pListArr objectAtIndex:indexPath.row] objectForKey:@"SeriesId"]];
        
        if ( [sSeriesId isEqualToString:@"NULL"] )
        {
            // 단편
            return YES;
        }
        else
        {
            // 시리즈
            return NO;
        }
    }
    // 녹화예약관리
    else
    {
        NSString *sSeriesId = [NSString stringWithFormat:@"%@", [[self.pReservListArr objectAtIndex:indexPath.row] objectForKey:@"SeriesId"]];
        
        if ( [sSeriesId isEqualToString:@"NULL"] )
        {
            // 단편
            return YES;
        }
        else
        {
            // 시리즈
            return NO;
        }
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DDLogError(@"delete");
        
        // 녹화물 목록
        if ( self.isTabCheck == YES )
        {
            [SIAlertView alert:@"녹화물 삭제" message:@"녹화물을 삭제 하시겠습니까?"
                        cancel:@"아니오"
                       buttons:@[@"예"]
                    completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                        
                        if ( buttonIndex == 1 )
                        {
                            [self requestWithSetRecordDeleWithIndex:(int)indexPath.row];
                        }
                        
                    }];
        }
        // 녹화 예약 목록
        else
        {
            BOOL isCheck = NO;
            NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.pReservListArr objectAtIndex:indexPath.row] objectForKey:@"ChannelId"]];
            for ( NSString *str in self.pPvringListArr )
            {
                if ( [str isEqualToString:sChannelId] )
                {
                    isCheck = YES;
//                    text = @"녹화 중지";
                }
            }
            
            // 녹화예약취소
            if ( isCheck == NO )
            {
                NSDictionary* reservItem = self.pReservListArr[indexPath.row];
                NSString* seriesId = reservItem[@"SeriesId"];
                
                //  메인화면에서는 단편만 녹화예약취소 가능
                if ([seriesId isEqualToString:@"NULL"]) {
                    NSString* message = [NSString stringWithFormat:@"%@\n\n녹화예약을 삭제하시겠습니까?", reservItem[@"ProgramName"]];
                    
                    [SIAlertView alert:@"녹화예약취소확인" message:message
                                cancel:@"취소"
                               buttons:@[@"확인"]
                            completion:^(NSInteger buttonIndex, SIAlertView *alert){
                                
                                if ( buttonIndex == 1 )
                                {
                                    [self requestWithSetRecordCancelReserveWithIndex:(int)indexPath.row reserveCancel:@"2"];
                                }
                            }];
                }
            }
            // 녹화중지
            else
            {
                
            }
        }
        
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{

//#warning TEST
    //  녹화중일 경우, 높이 90, 아닌 경우 66
//    BOOL rec = indexPath.row%2; //  녹화중 여부 테스트 값
    NSString* text = @"";
    
    // 녹화물 목록
    if ( self.isTabCheck == YES )
    {
        text = @"삭제";
    }
    // 녹화예약관리
    else
    {
        text = @"녹화예약취소";
        NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.pReservListArr objectAtIndex:indexPath.row] objectForKey:@"ChannelId"]];
        for ( NSString *str in self.pPvringListArr )
        {
            if ( [str isEqualToString:sChannelId] )
            {
                text = @"녹화 중지";
            }
        }

    }

    return text;
}

#pragma mark - 전문
#pragma mark - 예약 녹화물 리스트

- (void)requestWithRecordReservelist
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary pvrGetrecordReservelistCompletion:^(NSArray *pvr, NSError *error) {
       
        DDLogError(@"예약 녹화물 리스트 = [%@]", pvr);
        
        NSString *sResultCode = [[pvr objectAtIndex:0] objectForKey:@"resultCode"];
        
        if ([[CMAppManager sharedInstance] checkSTBStateCode:sResultCode])
        {
            if ( [pvr count] == 0 )
                return;
            
            [self.pReservListArr removeAllObjects];
            [self.pSeriesReservDetailArr removeAllObjects];
            
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            
            if ( [[[pvr objectAtIndex:0] objectForKey:@"Reserve_Item"] isKindOfClass:[NSDictionary class]] )
            {
                [arr addObject:[[pvr objectAtIndex:0] objectForKey:@"Reserve_Item"]];
            }
            else
            {
                [arr setArray:[[pvr objectAtIndex:0] objectForKey:@"Reserve_Item"]];
            }
            
            [self.pReservListArr setArray:arr];
            
            
            for ( NSDictionary *dic in arr )
            {
                NSString *sSeriesId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"SeriesId"]];
                NSString *sRecordingType = [NSString stringWithFormat:@"%@", [dic objectForKey:@"RecordingType"]];
                
                if ( ![sSeriesId isEqualToString:@"NULL"] &&
                    [sRecordingType isEqualToString:@"0"] )
                {
                    // 삭제
                    [self.pReservListArr removeObject:dic];
                }
                
                if ( ![sSeriesId isEqualToString:@"NULL"] &&
                    [sRecordingType isEqualToString:@"0"] )
                {
                    [self.pSeriesReservDetailArr addObject:dic];
                }
            }
            
            NSInteger nTotalCount;
            if (self.isTabCheck)
            {
                nTotalCount = self.pListArr.count;
            } else
            {
                nTotalCount = self.pReservListArr.count;
            }

            [self setInfoWithCount:nTotalCount];
            
            [self.pTableView reloadData];
        }
        else {
            [self.pReservListArr removeAllObjects];
            [self.pSeriesReservDetailArr removeAllObjects];
            [self setInfoWithCount:0];
            [self.pTableView reloadData];
        }
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 녹화 목록 리스트
- (void)requestWithRecordList
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary pvrGetrecordlistCompletion:^(NSArray *pvr, NSError *error) {
        
        DDLogError(@"녹화 목록 리스트 = [%@]", pvr);
        
        
        NSString *sResultCode = [[pvr objectAtIndex:0] objectForKey:@"resultCode"];
        
        if ([[CMAppManager sharedInstance] checkSTBStateCode:sResultCode])
        {
            if ( [pvr count] == 0 )
                return ;
            [self.pListArr removeAllObjects];
            
            NSArray* recordItems;
            if ( [[[pvr objectAtIndex:0] objectForKey:@"Reserve_Item"] isKindOfClass:[NSDictionary class]] )
            {
                recordItems = @[[[pvr objectAtIndex:0] objectForKey:@"Record_Item"]];
            }
            else
            {
                recordItems = [NSArray arrayWithArray:[[pvr objectAtIndex:0] objectForKey:@"Record_Item"]];
            }
            
            NSMutableDictionary* seriesIds = [@{} mutableCopy];
            for (NSDictionary* recordItem in recordItems) {
                NSString* seriesId = recordItem[@"SeriesId"];
                
                if ([seriesId isEqualToString:@"NULL"])
                {
                    [self.pListArr addObject:recordItem];
                }
                else if (seriesIds[seriesId])
                {
                    break;
                }
                else
                {
                    [seriesIds setObject:@"" forKey:seriesId];
                    [self.pListArr addObject:recordItem];
                }
            }
            
            int nTotalCount = (int)[self.pListArr count];
            [self setInfoWithCount:nTotalCount];
            [self.pTableView reloadData];
        }
        else {
            [self.pListArr removeAllObjects];
            [self setInfoWithCount:0];
            [self.pTableView reloadData];
        }
        
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
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

        [self.pPvringListArr removeAllObjects];
        [self.pPvringListArr addObject:sRecordingchannel1];
        [self.pPvringListArr addObject:sRecordingchannel2];
        
        [self requestWithRecordReservelist];
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 녹화물 목록 삭제
- (void)requestWithSetRecordDeleWithIndex:(int)index
{
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.pListArr objectAtIndex:index] objectForKey:@"ChannelId"]];
    NSString *sRecordStartTime = [NSString stringWithFormat:@"%@", [[self.pListArr objectAtIndex:index] objectForKey:@"RecordStartTime"]];
    NSString *sRecordId = [NSString stringWithFormat:@"%@", [[self.pListArr objectAtIndex:index] objectForKey:@"RecordId"]];
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary pvrSetRecordDeleWithChannelId:sChannelId WithStartTime:sRecordStartTime WithRecordId:sRecordId completion:^(NSArray *pvr, NSError *error) {
        
        DDLogError(@"녹화물 목록 삭제 = [%@]", pvr);
        if ( [pvr count] == 0 )
            return;
        
        NSString* resultCode = [[pvr objectAtIndex:0] objectForKey:@"resultCode"];
        if ([[CMAppManager sharedInstance] checkSTBStateCode:resultCode])
        {
            // 성공시 로컬 데이터 삭제후 리플래시
            [self.pListArr removeObjectAtIndex:index];
            [self.pTableView reloadData];
        }
    }];
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 녹화예약취소

/**
 *  녹화예약취소
 *  @param index    리스트 인덱스
 *  @param reserveCancel    단편 - @"2", 시리즈 - 전체:@"2" / 단편:@"1"
 */
- (void)requestWithSetRecordCancelReserveWithIndex:(int)index reserveCancel:(NSString*)reserveCancel
{
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.pReservListArr objectAtIndex:index] objectForKey:@"ChannelId"]];
    NSString *sRecordStartTime = [NSString stringWithFormat:@"%@", [[self.pReservListArr objectAtIndex:index] objectForKey:@"RecordStartTime"]];
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary epgSetRecordCancelReserveWithChannelId:sChannelId WithStartTime:sRecordStartTime WithSeriesId:@"" WithReserveCancel:reserveCancel completion:^(NSArray *epgs, NSError *error) {
        
        DDLogError(@"녹화 예약 취소 = [%@]", epgs);
        
        if ( [epgs count] == 0 )
            return;
        
        NSString* resultCode = [[epgs objectAtIndex:0] objectForKey:@"resultCode"];
        
        if ([[CMAppManager sharedInstance] checkSTBStateCode:resultCode])
        {
            // 성공시 로컬 데이터 삭제후 리플래시
            [self.pReservListArr removeObjectAtIndex:index];
            [self.pTableView reloadData];
        }
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 델리게이트
- (void)PvrSubViewWithTap:(BOOL)isTap
{
    [self resetData];
    
    if ( isTap == YES )
    {
        // 녹화물 목록
        self.isTabCheck = YES;
        [self requestWithRecordList];
    }
    else
    {
        // 녹화예약관리
        self.isTabCheck = NO;
        [self requestWithGetSetTopStatus];
    }
}

@end
