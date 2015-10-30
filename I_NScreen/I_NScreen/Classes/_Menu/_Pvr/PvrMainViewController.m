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

@interface PvrMainViewController ()
@property (nonatomic, strong) NSMutableArray *pListArr;         // 녹화물
@property (nonatomic, strong) NSMutableArray *pReservListArr;   // 예약 녹화
@end

@implementation PvrMainViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTagInit];
    [self setViewInit];
}

#pragma mark - 초기화
#pragma mark - 화면 태그값 초기화
- (void)setTagInit
{
    self.pBackBtn.tag = PVR_MAIN_VIEW_BTN_01;
    self.pReservationBtn.tag = PVR_MAIN_VIEW_BTN_02;
    self.pListBtn.tag = PVR_MAIN_VIEW_BTN_03;
}

#pragma mark - 화면 초기화
-(void)setViewInit
{
    self.isListCheck = NO;
    self.isReservCheck = NO;
    self.isTabCheck = NO;
    self.pListArr = [[NSMutableArray alloc] init];
    self.pReservListArr = [[NSMutableArray alloc] init];
    // 초기 예약 녹화 리스트
    
//    [self requestWithRecordList];
    [self requestWithRecordReservelist];
}

#pragma mark - 액션 이벤트
#pragma mark - 버튼 클릭 이벤트
- (IBAction)onBtnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case PVR_MAIN_VIEW_BTN_01:
        {
            // back
            [self.navigationController popViewControllerAnimated:YES];
            
        }break;
        case PVR_MAIN_VIEW_BTN_02:
        {
            // 녹화 예약 관리
            self.isTabCheck = NO;
            [self.pReservationBtn setBackgroundImage:[UIImage imageNamed:@"2btn_select.png"] forState:UIControlStateNormal];
            [self.pListBtn setBackgroundImage:[UIImage imageNamed:@"2btn_normal.png"] forState:UIControlStateNormal];
            
            [self.pReservationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.pListBtn setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            
            [self requestWithRecordReservelist];
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
        }break;
    }
}

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
        [pCell setListData:[self.pListArr objectAtIndex:indexPath.row] WithIndex:(int)indexPath.row];
    else
        [pCell setListData:[self.pReservListArr objectAtIndex:indexPath.row] WithIndex:(int)indexPath.row];
    
    return pCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PvrSubViewController *pViewController = [[PvrSubViewController alloc] initWithNibName:@"PvrSubViewController" bundle:nil];
    [self.navigationController pushViewController:pViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.isTabCheck == YES )
        return (int)[self.pListArr count];
    else
        return (int)[self.pReservListArr count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
            self.isReservCheck = NO;
   
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
            self.pListComentLbl.text = [NSString stringWithFormat:@"총 %d개의 녹화 예약 콘텐츠가 있습니다.", nTotalCount];
            
            [self.pTableView reloadData];

        }
        else
        {
            // 한번만 더 테움
            if ( self.isReservCheck == NO )
            {
                [self requestWithRecordReservelist];
                
                self.isReservCheck = YES;
            }
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
            self.isListCheck = NO;
            
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
            self.pListComentLbl.text = [NSString stringWithFormat:@"총 %d개의 녹화물 목록 콘텐츠가 있습니다.", nTotalCount];
            [self.pTableView reloadData];
        }
        else
        {
            // 한번만 더 테움
            if ( self.isListCheck == NO )
            {
                [self requestWithRecordReservelist];
                
                self.isListCheck = YES;
            }
        }
        
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}



@end
