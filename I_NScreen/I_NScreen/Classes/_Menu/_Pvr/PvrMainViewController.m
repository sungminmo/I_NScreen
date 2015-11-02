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

@property (nonatomic, weak) IBOutlet UIButton *pReservationBtn; // 녹화 예약 관리 버튼
@property (nonatomic, weak) IBOutlet UIButton *pListBtn;        // 녹화물 목록 버튼
@property (nonatomic, weak) IBOutlet UITableView *pTableView;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (strong, nonatomic) NSMutableArray* dataArray;

- (IBAction)onBtnClick:(UIButton *)btn;

@end

@implementation PvrMainViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.topConstraint.constant = cmNavigationHeight;
    
    self.title = @"녹화관리";
    
    self.isUseNavigationBar = YES;
    
    self.dataArray = [@[] mutableCopy];

    [self setTagInit];
    [self setViewInit];
    
#warning TESt
    [self setTestData];
    
    [self setInfoWithCount:self.dataArray.count];
    [self.pTableView reloadData];
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
    // 초기 예약 녹화 리스트
//    [self requestWithRecordList];
    [self requestWithRecordReservelist];
}

#pragma mark - Private

/**
 *  test용 데이터 셋팅
 */
- (void)setTestData {
    
    for (int i = 0; i < 20; i++) {
        
        NSString* series = i%2 == 0 ? @"Y":@"N";
        NSString* title = [NSString stringWithFormat:@"뉴스파이터 %d", i];
        NSString* rec  = i%2 == 0 ? @"Y":@"N";
        
        [self.dataArray addObject:@{@"date":@"10.10 (금)", @"time":@"11:11", @"series":series, @"title":title, @"rec":rec, @"rate":@(0.5)}];
    }
}
/**
 *  검색된 목록 수를 표시한다.
 *
 *  @param count 목록수, 0보다 작은 경우 메세지를 표출하지 않는다.
 */
- (void)setInfoWithCount:(NSInteger)count {
    
    if (count < 0) {
        self.infoLabel.text = @"";
    } else {
        self.infoLabel.text = [NSString stringWithFormat:@"총 %ld개의 녹화예약 콘텐트가 있습니다.", (long)count];
    }
}

#pragma mark - Event
- (IBAction)onBtnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case PVR_MAIN_VIEW_BTN_02:
        {
            // 녹화 예약 관리
            [self.pReservationBtn setBackgroundImage:[UIImage imageNamed:@"2btn_select.png"] forState:UIControlStateNormal];
            [self.pListBtn setBackgroundImage:[UIImage imageNamed:@"2btn_normal.png"] forState:UIControlStateNormal];
            
            [self.pReservationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.pListBtn setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            
            
        }break;
        case PVR_MAIN_VIEW_BTN_03:
        {
            // 녹화물 목록
            [self.pReservationBtn setBackgroundImage:[UIImage imageNamed:@"2btn_normal.png"] forState:UIControlStateNormal];
            [self.pListBtn setBackgroundImage:[UIImage imageNamed:@"2btn_select.png"] forState:UIControlStateNormal];
            
            [self.pReservationBtn setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
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
    
    NSDictionary* data = self.dataArray[indexPath.row];
    [pCell setListData:data WithIndex:(int)indexPath.row];
    
    return pCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PvrSubViewController *pViewController = [[PvrSubViewController alloc] initWithNibName:@"PvrSubViewController" bundle:nil];
    [self.navigationController pushViewController:pViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* data = self.dataArray[indexPath.row];
    NSString* rec = data[@"rec"];
    
    CGFloat height;
    if ([rec isEqualToString:@"Y"]) {
        height = 90;
    } else {
        height = 66;
    }
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DDLogError(@"delete");
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* text;

    NSDictionary* data = self.dataArray[indexPath.row];
    
    NSString* rec = data[@"rec"];
    if ([rec isEqualToString:@"Y"]) {
        
        text = @"녹화중지";
    } else {
        
        text = @"삭제";
    }

    return text;
}

#pragma mark - 전문
#pragma mark - 예약 녹화물 리스트
- (void)requestWithRecordReservelist
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary pvrGetrecordReservelistCompletion:^(NSArray *pvr, NSError *error) {
       
        DDLogError(@"예약 녹화물 리스트 = [%@]", pvr);
        
        if ( [pvr count] == 0 )
            return ;
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 녹화 목록 리스트
- (void)requestWithRecordList
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary pvrGetrecordlistCompletion:^(NSArray *pvr, NSError *error) {
        
        DDLogError(@"녹화 목록 리스트 = [%@]", pvr);
        
        if ( [pvr count] == 0 )
            return;
        
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}



@end
