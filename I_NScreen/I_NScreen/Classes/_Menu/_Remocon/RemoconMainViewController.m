//
//  RemoconMainViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "RemoconMainViewController.h"

@interface RemoconMainViewController ()

@end

@implementation RemoconMainViewController

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
    self.pBackBtn.tag = REMOCON_MAIN_VIEW_BTN_01;
    self.pPowerBtn.tag = REMOCON_MAIN_VIEW_BTN_02;
    self.pChannelBtn.tag = REMOCON_MAIN_VIEW_BTN_03;
    self.pVolumeDownBtn.tag = REMOCON_MAIN_VIEW_BTN_04;
    self.pVoluumeUpBtn.tag = REMOCON_MAIN_VIEW_BTN_05;
}

#pragma mark - 화면 초기화
- (void)setViewInit
{
    // 화면 해상도 대응
    if ( [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_6_PLUS] )
    {
        self.pPowerBtn.frame = CGRectMake(14, 0, 142, 46);
        self.pChannelBtn.frame = CGRectMake(168, 0, 230, 46);
        self.pVolumeDownBtn.frame = CGRectMake(14, 20, 178, 76);
        self.pVoluumeUpBtn.frame = CGRectMake(222, 20, 178, 76);
    }
    else if ( [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_6] )
    {
        self.pPowerBtn.frame = CGRectMake(15, 0, 128, 40);
        self.pChannelBtn.frame = CGRectMake(150, 0, 208, 40);
        self.pVolumeDownBtn.frame = CGRectMake(14, 20, 142, 60);
        self.pVoluumeUpBtn.frame = CGRectMake(164, 20, 142, 60);
    }
    else
    {
        self.pPowerBtn.frame = CGRectMake(15, 0, 128, 40);
        self.pChannelBtn.frame = CGRectMake(128, 0, 177, 35);
        self.pVolumeDownBtn.frame = CGRectMake(14, 20, 154, 64);
        self.pVoluumeUpBtn.frame = CGRectMake(205, 20, 154, 64);
    }
}

#pragma mark - 액션 이벤트
#pragma mark - 버튼 클릭 이벤트
- (IBAction)onBtnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case REMOCON_MAIN_VIEW_BTN_01:
        {
            // back
            [self.navigationController popViewControllerAnimated:YES];
            
        }break;
        case REMOCON_MAIN_VIEW_BTN_02:
        {
            // 전원 버튼
            
            [SIAlertView alert:@"채널변경" message:@"데이터 방송 시청 중에는\n채널이 변경되지 않습니다."];
        }break;
        case REMOCON_MAIN_VIEW_BTN_03:
        {
            // 채널 버튼
            
        }break;
        case REMOCON_MAIN_VIEW_BTN_04:
        {
            // 볼륨 다운 버튼
            
        }break;
        case REMOCON_MAIN_VIEW_BTN_05:
        {
            // 볼륨 업 버튼
            
        }break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *pCellIn = @"RemoconMainTableViewCellIn";
    
    RemoconMainTableViewCell *pCell = (RemoconMainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:pCellIn];
    
    if (pCell == nil)
    {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"RemoconMainTableViewCell" owner:nil options:nil];
        pCell = [arr objectAtIndex:0];
    }
    
    [pCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [pCell setListData:nil WithIndex:(int)indexPath.row];
    
    return pCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 24;
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
        NSLog(@"delete");
    }
}

@end
