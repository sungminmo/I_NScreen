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

@interface PvrSubViewController ()

@property (nonatomic, weak) IBOutlet UITableView *pTableView;
@property (strong, nonatomic) IBOutlet UIView *titleView;   //  커스텀 타이틀뷰
@property (strong, nonatomic) IBOutlet UILabel* titleLabel; //  제목 라벨
@property (strong, nonatomic) IBOutlet UIImageView *seriesImageView;    //  타이틀에 시리즈 이미지
@property (nonatomic, strong) NSMutableArray *pSeriesListArr;

@end

@implementation PvrSubViewController
@synthesize pSeriesIdStr;
@synthesize pTitleStr;

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
    [self requestWithGetRecordListSeries];
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
    
    [pCell setListData:[self.pSeriesListArr objectAtIndex:indexPath.row] WithIndex:(int)indexPath.row];
    
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
    int nCount = (int)[self.pSeriesListArr count];
    
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
        [SIAlertView alert:@"녹화물 삭제확인" message:@"녹화물을 삭제하시겠습니까?"
                    cancel:@"취소"
                   buttons:@[@"단편삭제", @"시리즈 전체삭제"]
                completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                    
                    if ( buttonIndex == 1 )
                    {
                        // 단편삭제
                        [self requestWithSetRecordDeleWithIndex:(int)indexPath.row];
                    }
                    else if ( buttonIndex == 2 )
                    {
                        // 시리즈 전체 삭제
                        [self requestWithSetRecordSeriesDeleWithIndex:(int)indexPath.row];
                    }
                    
                }];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return @"삭제";
}

#pragma mark - 전문
#pragma mark - 녹화물 시리즈 전문
- (void)requestWithGetRecordListSeries
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary pvrGetrecordListWithSeriesId:self.pSeriesIdStr completion:^(NSArray *pvr, NSError *error) {
        
        DDLogError(@"녹화물 시리즈 전문 = [%@]", pvr);
        if ( [pvr count] == 0 )
            return;
        
        [self.pSeriesListArr removeAllObjects];
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
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
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
        
        if ( [[[pvr objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
        {
            // 성공시 로컬 데이터 삭제후 리플래시
            [self.pSeriesListArr removeObjectAtIndex:index];
            [self.pTableView reloadData];
        }
    }];
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
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
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

@end
