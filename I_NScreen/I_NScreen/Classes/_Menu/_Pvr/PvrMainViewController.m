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

@interface PvrMainViewController ()

@property (nonatomic, strong) NSMutableArray *pListArr;         // 녹화물
@property (nonatomic, strong) NSMutableArray *pReservListArr;   // 예약 녹화

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
    
    self.title = @"녹화관리";
    
    self.isUseNavigationBar = YES;

    [self setTagInit];
    [self setViewInit];
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
//    self.isListCheck = NO;
//    self.isReservCheck = NO;
    self.isTabCheck = NO;
    self.pListArr = [[NSMutableArray alloc] init];
    self.pReservListArr = [[NSMutableArray alloc] init];
    // 초기 예약 녹화 리스트
    
    [self setInfoWithCount:-1];
    [self requestWithGetSetTopStatus];
}

#pragma mark - Private

/**
 *  검색된 목록 수를 표시한다.
 *
 *  @param count 목록수, 0보다 작은 경우 메세지를 표출하지 않는다.
 */
- (void)setInfoWithCount:(NSInteger)count {
    
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
    switch (btn.tag) {
        case PVR_MAIN_VIEW_BTN_02:
        {
            // 녹화 예약 관리
            self.isTabCheck = NO;
            [self.pReservationBtn setBackgroundImage:[UIImage imageNamed:@"2btn_select.png"] forState:UIControlStateNormal];
            [self.pListBtn setBackgroundImage:[UIImage imageNamed:@"2btn_normal.png"] forState:UIControlStateNormal];
            
            [self.pReservationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.pListBtn setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            
//            [self requestWithRecordReservelist];
            [self requestWithGetSetTopStatus];
        }break;
        case PVR_MAIN_VIEW_BTN_03:
        {
            // 녹화물 목록
            self.isTabCheck = YES;
            [self.pReservationBtn setBackgroundImage:[UIImage imageNamed:@"2btn_normal.png"] forState:UIControlStateNormal];
            [self.pListBtn setBackgroundImage:[UIImage imageNamed:@"2btn_select.png"] forState:UIControlStateNormal];
            
            [self.pReservationBtn setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [self requestWithRecordList];
//            [self requestWithGetSetTopStatus];
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
    
    if ( self.isTabCheck == YES )
        [pCell setListDataList:[self.pListArr objectAtIndex:indexPath.row] WithIndex:(int)indexPath.row];
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
    if ( self.isTabCheck == YES )
    {
        // 녹화물 목록
        NSString *sSeriesId = [NSString stringWithFormat:@"%@", [[self.pListArr objectAtIndex:indexPath.row] objectForKey:@"SeriesId"]];
        
        if ( ![sSeriesId isEqualToString:@"NULL"] )
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
    else
    {
        // 녹화예약관리
        PvrSubViewController *pViewController = [[PvrSubViewController alloc] initWithNibName:@"PvrSubViewController" bundle:nil];
        pViewController.delegate = self;
        pViewController.pSeriesIdStr = [[self.pReservListArr objectAtIndex:indexPath.row] objectForKey:@"SeriesId"];
        pViewController.pTitleStr = [[self.pReservListArr objectAtIndex:indexPath.row] objectForKey:@"ProgramName"];
        pViewController.isTapCheck = NO;
        [self.navigationController pushViewController:pViewController animated:YES];

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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( self.isTabCheck == YES )
    {
        // 녹화물 목록
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
    else
    {
        // 녹화예약관리
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
        
        if ( self.isTabCheck == YES )
        {
            // 녹화물 목록
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
        else
        {
            // 녹화 예약 목록
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
            
            if ( isCheck == NO )
            {
                // 녹화예약취소
                [self requestWithSetRecordCancelReserveWithIndex:(int)indexPath.row];
            }
            else
            {
                // 녹화중지
                
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
    
    if ( self.isTabCheck == YES )
    {
        // 녹화물 목록
        text = @"삭제";
    }
    else
    {
        // 녹화예약관리
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
        
        if ( [sResultCode isEqualToString:@"100"] )
        {
            if ( [pvr count] == 0 )
                return ;
            
            [self.pReservListArr removeAllObjects];
            
            if ( [[[pvr objectAtIndex:0] objectForKey:@"Reserve_Item"] isKindOfClass:[NSDictionary class]] )
            {
                [self.pReservListArr addObject:[[pvr objectAtIndex:0] objectForKey:@"Reserve_Item"]];
            }
            else
            {
                [self.pReservListArr setArray:[[pvr objectAtIndex:0] objectForKey:@"Reserve_Item"]];
            }
            
            int nTotalCount = (int)[self.pReservListArr count];
            [self setInfoWithCount:nTotalCount];
            
            [self.pTableView reloadData];

        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 녹화 목록 리스트
- (void)requestWithRecordList
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary pvrGetrecordlistCompletion:^(NSArray *pvr, NSError *error) {
        
        DDLogError(@"녹화 목록 리스트 = [%@]", pvr);
        
        
        NSString *sResultCode = [[pvr objectAtIndex:0] objectForKey:@"resultCode"];
        
        if ( [sResultCode isEqualToString:@"100"] )
        {
            if ( [pvr count] == 0 )
                return ;
            [self.pListArr removeAllObjects];
            
            if ( [[[pvr objectAtIndex:0] objectForKey:@"Reserve_Item"] isKindOfClass:[NSDictionary class]] )
            {
                [self.pListArr addObject:[[pvr objectAtIndex:0] objectForKey:@"Record_Item"]];
            }
            else
            {
                [self.pListArr setArray:[[pvr objectAtIndex:0] objectForKey:@"Record_Item"]];
            }
            
            int nTotalCount = (int)[self.pListArr count];
            [self setInfoWithCount:nTotalCount];
            [self.pTableView reloadData];
        }
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

        [self.pPvringListArr removeAllObjects];
        [self.pPvringListArr addObject:sRecordingchannel1];
        [self.pPvringListArr addObject:sRecordingchannel2];
        
//        [self requestWithRecordList];
        [self requestWithRecordReservelist];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
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
        
        if ( [[[pvr objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
        {
            // 성공시 로컬 데이터 삭제후 리플래시
            [self.pListArr removeObjectAtIndex:index];
            [self.pTableView reloadData];
        }
    }];
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 녹화예약취소
- (void)requestWithSetRecordCancelReserveWithIndex:(int)index
{
     NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.pReservListArr objectAtIndex:index] objectForKey:@"ChannelId"]];
    NSString *sRecordStartTime = [NSString stringWithFormat:@"%@", [[self.pReservListArr objectAtIndex:index] objectForKey:@"RecordStartTime"]];
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary epgSetRecordCancelReserveWithChannelId:sChannelId WithStartTime:sRecordStartTime WithSeriesId:@"" WithReserveCancel:@"" completion:^(NSArray *epgs, NSError *error) {
        
        DDLogError(@"녹화 예약 취소 = [%@]", epgs);
        
        if ( [epgs count] == 0 )
            return;
        
        if ( [[[epgs objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
            
        {
            // 성공시 로컬 데이터 삭제후 리플래시
            [self.pReservListArr removeObjectAtIndex:index];
            [self.pTableView reloadData];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 델리게이트
- (void)PvrSubViewWithTap:(BOOL)isTap
{
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
