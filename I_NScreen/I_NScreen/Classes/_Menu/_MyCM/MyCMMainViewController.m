//
//  MyCMMainViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 16..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "MyCMMainViewController.h"
#import "NSMutableDictionary+MyC_M.h"
#import "UIAlertView+AFNetworking.h"

@interface MyCMMainViewController ()
@property (nonatomic, strong) NSMutableArray *pValidPurchaseLogListMoblieArr;   // vod 찜 목록 모바일 구매 목록
@property (nonatomic, strong) NSMutableArray *pValidPurchaseLogListTvArr;       // vod 찜 목록 tv 구매 목록
@property (nonatomic, strong) NSMutableArray *pWishListArr;
@property (nonatomic) int nTapTag;
@property (nonatomic) int nSubTabTag;

@end

@implementation MyCMMainViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTagInit];
    [self setViewInit];
    
    // 구매목록 전문
    [self requestWithGetValidPurchaseLogList];
}

#pragma mark - 초기화
#pragma mark - 화면 태그값 초기화
- (void)setTagInit
{
    self.pBackBtn.tag = MY_CM_MAIN_VIEW_BTN_01;
    self.pTapBtn01.tag = MY_CM_MAIN_VIEW_BTN_02;
    self.pTapBtn02.tag = MY_CM_MAIN_VIEW_BTN_03;
    self.pTapBtn03.tag = MY_CM_MAIN_VIEW_BTN_04;
    
    self.pSubTabBtn01.tag = MY_CM_MAIN_VIEW_BTN_05;
    self.pSubTabBtn02.tag = MY_CM_MAIN_VIEW_BTN_06;
}

#pragma mark - 화면 초기화
- (void)setViewInit
{
    self.pValidPurchaseLogListMoblieArr = [[NSMutableArray alloc] init];
    self.pValidPurchaseLogListTvArr = [[NSMutableArray alloc] init];
    self.pWishListArr = [[NSMutableArray alloc] init];
    self.nTapTag = MY_CM_MAIN_VIEW_BTN_02;
    self.nSubTabTag = 0;
}

#pragma mark - 액션 이벤트
#pragma mark - 버튼 클릭 이벤트
- (IBAction)onBtnClick:(UIButton *)btn
{
    self.nTapTag = (int)[btn tag];
    switch (btn.tag) {
        case MY_CM_MAIN_VIEW_BTN_01:
        {
            // back
            [self.navigationController popViewControllerAnimated:YES];
            
        }break;
        case MY_CM_MAIN_VIEW_BTN_02:
        {
            self.pSubView01.hidden = NO;
            self.pSubView02.hidden = YES;
            // vod 구매목록
            [self.pTapBtn01 setBackgroundImage:[UIImage imageNamed:@"3btn_select.png"] forState:UIControlStateNormal];
            [self.pTapBtn02 setBackgroundImage:[UIImage imageNamed:@"3btn_normal.png"] forState:UIControlStateNormal];
            [self.pTapBtn03 setBackgroundImage:[UIImage imageNamed:@"3btn_normal.png"] forState:UIControlStateNormal];
            
            [self.pTapBtn01 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.pTapBtn02 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pTapBtn03 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            
            [self requestWithGetValidPurchaseLogList];
        }break;
        case MY_CM_MAIN_VIEW_BTN_03:
        {
            self.pSubView01.hidden = YES;
            self.pSubView02.hidden = NO;
            // vod 시청목록
            [self.pTapBtn01 setBackgroundImage:[UIImage imageNamed:@"3btn_normal.png"] forState:UIControlStateNormal];
            [self.pTapBtn02 setBackgroundImage:[UIImage imageNamed:@"3btn_select.png"] forState:UIControlStateNormal];
            [self.pTapBtn03 setBackgroundImage:[UIImage imageNamed:@"3btn_normal.png"] forState:UIControlStateNormal];
            
            [self.pTapBtn01 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pTapBtn02 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.pTapBtn03 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];

        }break;
        case MY_CM_MAIN_VIEW_BTN_04:
        {
            self.pSubView01.hidden = YES;
            self.pSubView02.hidden = NO;
            // vod 찜목록
            [self.pTapBtn01 setBackgroundImage:[UIImage imageNamed:@"3btn_normal.png"] forState:UIControlStateNormal];
            [self.pTapBtn02 setBackgroundImage:[UIImage imageNamed:@"3btn_normal.png"] forState:UIControlStateNormal];
            [self.pTapBtn03 setBackgroundImage:[UIImage imageNamed:@"3btn_select.png"] forState:UIControlStateNormal];
            
            [self.pTapBtn01 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pTapBtn02 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pTapBtn03 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [self requestWithGetWishList];
            
        }break;
        case MY_CM_MAIN_VIEW_BTN_05:
        {
            // 모바일 구매목록
            self.nSubTabTag = 0;
            self.nTapTag = MY_CM_MAIN_VIEW_BTN_02;
            [self.pSubTabBtn01 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pSubTabBtn02 setTitleColor:[UIColor colorWithRed:138.0f/255.0f green:140.0f/255.0f blue:142.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            
            self.pLeftLineView.frame = CGRectMake(self.pLeftLineView.frame.origin.x, 39, self.pLeftLineView.frame.size.width, 2);
            self.pRightLineView.frame = CGRectMake(self.pRightLineView.frame.origin.x, 40, self.pRightLineView.frame.size.width, 1);
            
            int nTotal = (int)[self.pValidPurchaseLogListMoblieArr count];
            self.pTotalExplanLbl01.text = [NSString stringWithFormat:@"총 %d개의 모바일 VOD 구매목록이 있습니다.", nTotal];
            
            [self.pSubTableView01 reloadData];
        }break;
        case MY_CM_MAIN_VIEW_BTN_06:
        {
            // tv 구매목록
            self.nSubTabTag = 1;
            self.nTapTag = MY_CM_MAIN_VIEW_BTN_02;
            [self.pSubTabBtn01 setTitleColor:[UIColor colorWithRed:138.0f/255.0f green:140.0f/255.0f blue:142.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pSubTabBtn02 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            
            self.pLeftLineView.frame = CGRectMake(self.pLeftLineView.frame.origin.x, 40, self.pLeftLineView.frame.size.width, 1);
            self.pRightLineView.frame = CGRectMake(self.pRightLineView.frame.origin.x, 39, self.pRightLineView.frame.size.width, 2);
            
            int nTotal = (int)[self.pValidPurchaseLogListTvArr count];
            self.pTotalExplanLbl01.text = [NSString stringWithFormat:@"총 %d개의 TV VOD 구매목록이 있습니다.", nTotal];

            [self.pSubTableView01 reloadData];
        }break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *pCellIn = @"MyCMZimListTableViewCell";
    
    MyCMZimListTableViewCell *pCell = (MyCMZimListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:pCellIn];
    
    if (pCell == nil)
    {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MyCMZimListTableViewCell" owner:nil options:nil];
        pCell = [arr objectAtIndex:0];
    }
    
    [pCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if ( self.nTapTag == MY_CM_MAIN_VIEW_BTN_02 )
    {
        // 구매 목록
        if ( self.nSubTabTag == 0 )
        {
            // 모바일 구매목록
            [pCell setListData:[self.pValidPurchaseLogListMoblieArr objectAtIndex:indexPath.row] WithIndex:(int)indexPath.row];
        }
        else
        {
            // tv 수매목록
            [pCell setListData:[self.pValidPurchaseLogListTvArr objectAtIndex:indexPath.row] WithIndex:(int)indexPath.row];
        }
    }
    else if ( self.nTapTag == MY_CM_MAIN_VIEW_BTN_03 )
    {
        // 시청목록
        [pCell setListData:nil WithIndex:(int)indexPath.row];
    }
    else
    {
        // 찜목록
        [pCell setListData:[self.pWishListArr objectAtIndex:indexPath.row] WithIndex:(int)indexPath.row];
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
    int nSection = 0;
    
    if ( self.nTapTag == MY_CM_MAIN_VIEW_BTN_02 )
    {
        if ( self.nSubTabTag == 0 )
        {
            // 모바일 구매목록
            nSection = (int)[self.pValidPurchaseLogListMoblieArr count];
        }
        else
        {
            // tv 구매목록
            nSection = (int)[self.pValidPurchaseLogListTvArr count];
        }
    }
    else if ( self.nTapTag == MY_CM_MAIN_VIEW_BTN_03 )
    {
        // vod 시청목록
    }
    else if ( self.nTapTag == MY_CM_MAIN_VIEW_BTN_04 )
    {
        // vod 찜목록
        nSection = (int)[self.pWishListArr count];
    }

    return nSection;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        DDLogError(@"delete");
//    }
//}

#pragma mark - 전문
#pragma mark - 구매목록
- (void)requestWithGetValidPurchaseLogList
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary myCmGetValidPurchaseLogListCompletion:^(NSArray *myCm, NSError *error) {
        
        DDLogError(@"구매목록 = [%@]", myCm);
        
        [self.pValidPurchaseLogListMoblieArr removeAllObjects];
        [self.pValidPurchaseLogListTvArr removeAllObjects];
//        [self.pValidPurchaseLogListArr setArray:[[[myCm objectAtIndex:0] objectForKey:@"purchaseLogList"] objectForKey:@"purchaseLog"]];
        
        for ( NSDictionary *dic in [[[myCm objectAtIndex:0] objectForKey:@"purchaseLogList"] objectForKey:@"purchaseLog"] )
        {
            NSString *sPurchaseDeviceType = [NSString stringWithFormat:@"%@", [dic objectForKey:@"purchaseDeviceType"]];
            
            if ( [sPurchaseDeviceType isEqualToString:@"1"] )
            {
                // 모바일구매
                [self.pValidPurchaseLogListMoblieArr addObject:dic];
            }
            else
            {
                // tv 구매
                [self.pValidPurchaseLogListTvArr addObject:dic];
            }
        }
        
        if ( self.nSubTabTag == 0 )
        {
            // 모바일 구매목록
            int nTotal = (int)[self.pValidPurchaseLogListMoblieArr count];
            self.pTotalExplanLbl01.text = [NSString stringWithFormat:@"총 %d개의 모바일 VOD 구매목록이 있습니다.", nTotal];
        }
        else
        {
            // tv 구매목록
            int nTotal = (int)[self.pValidPurchaseLogListTvArr count];
            self.pTotalExplanLbl01.text = [NSString stringWithFormat:@"총 %d개의 TV VOD 구매목록이 있습니다.", nTotal];
        }
        
        [self.pSubTableView01 reloadData];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 찜목록
- (void)requestWithGetWishList
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary myCmGetWishListCompletion:^(NSArray *myCm, NSError *error) {
        
        DDLogError(@"찜목록 = [%@]", myCm);
        // 타이틀이 안내려옴 패치해서 보자
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}


@end
