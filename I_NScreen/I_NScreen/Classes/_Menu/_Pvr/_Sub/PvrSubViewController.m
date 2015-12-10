//
//  PvrSubViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "PvrSubViewController.h"
#import "NSMutableDictionary+PVR.h"
#import "UIAlertView+AFNetworking.h"
#import "NSMutableDictionary+EPG.h"

@interface PvrSubViewController ()

@property (nonatomic, weak) IBOutlet UITableView *pTableView;
@property (strong, nonatomic) IBOutlet UIView *titleView;   //  커스텀 타이틀뷰
@property (strong, nonatomic) IBOutlet UILabel* titleLabel; //  제목 라벨
@property (strong, nonatomic) IBOutlet UIImageView *seriesImageView;    //  타이틀에 시리즈 이미지
@property (nonatomic, strong) NSMutableArray *pSeriesListArr;

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
    self.titleLabel.text = self.pTitleStr;
    self.pSeriesListArr = [[NSMutableArray alloc] init];
    
    //  녹화물 목록
    if ( self.isTapCheck == YES )
    {
        [self requestWithGetRecordListSeries];
    }
    //  녹화예약관리
    else
    {
        [self.pTableView reloadData];
    }
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
    
    if ( self.isTapCheck == YES )
    {
        [pCell setListData:[self.pSeriesListArr objectAtIndex:indexPath.row] WithIndex:(int)indexPath.row];
    }
    else
    {
        [pCell setListData:[self.pSeriesReserveListArr objectAtIndex:indexPath.row] WithIndex:(int)indexPath.row];
    }
    
    
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
    int nCount = 0;
    if ( self.isTapCheck == YES )
    {
        nCount = (int)[self.pSeriesListArr count];
    }
    else
    {
        nCount = (int)[self.pSeriesReserveListArr count];
    }
    
    return nCount;
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
        if ( self.isTapCheck == YES )
        {
            [SIAlertView alert:@"녹화물 삭제확인" message:@"녹화물을 삭제하시겠습니까?"
                        cancel:@"취소"
                       buttons:@[@"삭제"]
                    completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                        
                        if ( buttonIndex == 1 )
                        {
                            // 단편삭제
                            [self requestWithSetRecordDeleWithIndex:(int)indexPath.row];
                        }
                    }];
        }
        else
        {
            //  시리즈에 속한 목록이 하나만 있을경우, 시리즈 삭제를 진행한다.
            if (self.pSeriesReserveListArr.count == 1)
            {
                NSString *sSeriesId = [NSString stringWithFormat:@"%@", [[self.pSeriesReserveListArr objectAtIndex:indexPath.row] objectForKey:@"SeriesId"]];
                NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.pSeriesReserveListArr objectAtIndex:indexPath.row] objectForKey:@"ChannelId"]];
                NSString *sTime = [NSString stringWithFormat:@"%@", [[self.pSeriesReserveListArr objectAtIndex:indexPath.row] objectForKey:@"RecordStartTime"]];
                
                [self requestWithSetRecordCancelReserveWithReserveCancel:@"1" WithSeriesId:sSeriesId WithIndex:(int)indexPath.row WithChannelId:sChannelId WithTime:sTime];
            }
            else
            {
                [SIAlertView alert:@"녹화예약물 삭제확인" message:@"녹화예약물을 삭제하시겠습니까?"
                            cancel:@"취소"
                           buttons:@[@"단편예약삭제", @"시리즈예약삭제"]
                        completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                            
                            NSString *sSeriesId = [NSString stringWithFormat:@"%@", [[self.pSeriesReserveListArr objectAtIndex:indexPath.row] objectForKey:@"SeriesId"]];
                            NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.pSeriesReserveListArr objectAtIndex:indexPath.row] objectForKey:@"ChannelId"]];
                            NSString *sTime = [NSString stringWithFormat:@"%@", [[self.pSeriesReserveListArr objectAtIndex:indexPath.row] objectForKey:@"RecordStartTime"]];
                            
                            if ( buttonIndex == 1 )
                            {
                                // 단편삭제
                                [self requestWithSetRecordCancelReserveWithReserveCancel:@"2" WithSeriesId:sSeriesId WithIndex:(int)indexPath.row WithChannelId:sChannelId WithTime:sTime];
                            }
                            else if ( buttonIndex == 2 )
                            {
                                // 시리즈 전체 삭제
                                [self requestWithSetRecordCancelReserveWithReserveCancel:@"1" WithSeriesId:sSeriesId WithIndex:(int)indexPath.row WithChannelId:sChannelId WithTime:sTime];
                            }
                        }];
            }
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sTitle = @"";
    if ( self.isTapCheck == YES )
    {
        sTitle = @"삭제";
    }
    else
    {
        sTitle = @"녹화예약취소";
    }
    return sTitle;
}

#pragma mark - 전문
#pragma mark - 녹화예약 시리즈 전문
- (void)requestWithGetRecordReservelistSeries
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary pvrGetrecordReservelistWithSeriesId:self.pSeriesIdStr completion:^(NSArray *pvr, NSError *error) {
        
        DDLogError(@"녹화예약 시리즈 = [%@]", pvr);
        
        if ( [pvr count] == 0 )
            return;
        
        [self.pSeriesReserveListArr removeAllObjects];
        
        NSString* resultCode = [[pvr objectAtIndex:0] objectForKey:@"resultCode"];
        
        if ([[CMAppManager sharedInstance] checkSTBStateCode:resultCode])
        {
            NSObject *itemObjet = [[pvr objectAtIndex:0] objectForKey:@"Reserve_Item"];
            
            if ( [itemObjet isKindOfClass:[NSDictionary class]] )
            {
                [self.pSeriesReserveListArr addObject:itemObjet];
            }
            else
            {
                [self.pSeriesReserveListArr setArray:(NSArray *)itemObjet];
            }
            
            [self.pTableView reloadData];
        }
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 녹화물 시리즈 전문
- (void)requestWithGetRecordListSeries
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary pvrGetrecordListWithSeriesId:self.pSeriesIdStr completion:^(NSArray *pvr, NSError *error) {
        
        DDLogError(@"녹화물 시리즈 전문 = [%@]", pvr);
        if ( [pvr count] == 0 )
            return;
        
        [self.pSeriesListArr removeAllObjects];
        
        NSString* resultCode = [[pvr objectAtIndex:0] objectForKey:@"resultCode"];
        if ([[CMAppManager sharedInstance] checkSTBStateCode:resultCode])
        {
            NSObject *itemObject = [[pvr objectAtIndex:0] objectForKey:@"Record_Item"];
            
            if ( [itemObject isKindOfClass:[NSDictionary class]] )
            {
                [self.pSeriesListArr addObject:(NSDictionary *)itemObject];
            }
            else
            {
                [self.pSeriesListArr setArray:(NSArray *)itemObject];
            }
            
            [self.pTableView reloadData];
        }
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 녹화물 단편 삭제
- (void)requestWithSetRecordDeleWithIndex:(int)index
{
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.pSeriesListArr objectAtIndex:index] objectForKey:@"ChannelId"]];
    NSString *sRecordStartTime = [NSString stringWithFormat:@"%@", [[self.pSeriesListArr objectAtIndex:index] objectForKey:@"RecordStartTime"]];
    NSString *sRecordId = [NSString stringWithFormat:@"%@", [[self.pSeriesListArr objectAtIndex:index] objectForKey:@"RecordId"]];
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary pvrSetRecordDeleWithChannelId:sChannelId WithStartTime:sRecordStartTime WithRecordId:sRecordId completion:^(NSArray *pvr, NSError *error) {
        
        DDLogError(@"녹화물 목록 삭제 = [%@]", pvr);
        if ( [pvr count] == 0 )
            return;
        
        NSString* resultCode = [[pvr objectAtIndex:0] objectForKey:@"resultCode"];
        if ([[CMAppManager sharedInstance] checkSTBStateCode:resultCode])
        {
            // 성공시 로컬 데이터 삭제후 리플래시
            [self.pSeriesListArr removeObjectAtIndex:index];
            [self.pTableView reloadData];
        }
    }];
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 시리즈 녹화목록 삭제
- (void)requestWithSetRecordSeriesDeleWithIndex:(int)index
{
    NSString *sRecordId = [NSString stringWithFormat:@"%@", [[self.pSeriesListArr objectAtIndex:index] objectForKey:@"RecordId"]];
    NSString *sSeriesId = [NSString stringWithFormat:@"%@", [[self.pSeriesListArr objectAtIndex:index] objectForKey:@"SeriesId"]];
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.pSeriesListArr objectAtIndex:index] objectForKey:@"ChannelId"]];
    NSString *sStartTime = [NSString stringWithFormat:@"%@", [[self.pSeriesListArr objectAtIndex:index] objectForKey:@"RecordStartTime"]];
    NSURLSessionDataTask *tesk = [NSMutableDictionary pvrSetRecordSeriesDeleWithRecordId:sRecordId WithSeriesId:sSeriesId WithChannelId:sChannelId WithStartTime:sStartTime completion:^(NSArray *pvr, NSError *error) {
        
        DDLogError(@"시리즈 녹화 목록 삭제 = [%@]", pvr);
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 녹화예약 취소

/**
 *  녹화예약 취소
 *
 *  @param reserveCancel 전체:@"2" / 단편:@"1"
 *  @param seriesId      시리즈 아이디
 *  @param nIndex        선택된 셀 인덱스
 *  @param channelId     채널 아이디
 *  @param time          녹화시작시간
 */
- (void)requestWithSetRecordCancelReserveWithReserveCancel:(NSString *)reserveCancel WithSeriesId:(NSString *)seriesId WithIndex:(int)nIndex WithChannelId:(NSString *)channelId WithTime:(NSString *)time
{
    //    ReserveCancel = 1 (시리즈 전체 삭제) / ReserveCancel = 2 (단편 삭제)
    NSURLSessionDataTask *tesk = [NSMutableDictionary epgSetRecordCancelReserveWithChannelId:channelId WithStartTime:time WithSeriesId:seriesId WithReserveCancel:reserveCancel completion:^(NSArray *epgs, NSError *error) {
        
        DDLogError(@"녹화에약취소 = [%@}", epgs);
        
        if ( [epgs count] == 0 )
            return;
        
        NSString* resultCode = [[epgs objectAtIndex:0] objectForKey:@"resultCode"];
        
        if ([[CMAppManager sharedInstance] checkSTBStateCode:resultCode])
        {
            //  시리즈 전체 삭제
            if ([reserveCancel isEqualToString:@"1"]) {
                [self backCommonAction];
            } else {
                [self.pSeriesReserveListArr removeObjectAtIndex:nIndex];
                [self.pTableView reloadData];
            }
        }
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

- (void)backCommonAction
{
    [self.delegate PvrSubViewWithTap:self.isTapCheck];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
