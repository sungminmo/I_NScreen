//
//  RemoconMainViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "RemoconMainViewController.h"
#import "NSMutableDictionary+REMOCON.h"
#import "UIAlertView+AFNetworking.h"

@interface RemoconMainViewController ()

@property (nonatomic, weak) IBOutlet UIButton *pBackBtn;        // back 버튼
@property (nonatomic, weak) IBOutlet UIButton *pPowerBtn;       // 전원 버튼
@property (nonatomic, weak) IBOutlet UIButton *pChannelBtn;     // 채널 버튼
@property (nonatomic, weak) IBOutlet UIButton *pVolumeDownBtn;  // 볼륨 다운 버튼
@property (nonatomic, weak) IBOutlet UIButton *pVoluumeUpBtn;   // 볼륨 업 버튼
@property (nonatomic, weak) IBOutlet UITableView *pTableView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (strong, nonatomic) IBOutlet UILabel *channelLabel;

@end

@implementation RemoconMainViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.isUseNavigationBar = YES;
    self.topConstraint.constant = cmNavigationHeight;
    self.title = @"리모컨";
    
    [self setTagInit];
    [self setViewInit];
    
#warning TEST
    //  test
    [self setChannelNumber:@"15번"];
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

#pragma mark - Private 

- (void)setChannelNumber:(NSString*)channel {
    NSString* fixedText = @"현재시청채널 :";
    NSString* desc = [NSString stringWithFormat:@"%@ %@", fixedText, channel];
    self.channelLabel.text = desc;
    
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.channelLabel.attributedText];
    NSRange range = NSMakeRange(fixedText.length, channel.length + 1);
    [attributedText addAttributes:@{NSForegroundColorAttributeName : [CMColor colorViolet]} range:range];
    
    self.channelLabel.attributedText = attributedText;
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
//            [SIAlertView alert:@"채널변경" message:@"데이터 방송 시청 중에는\n채널이 변경되지 않습니다."];
            [self requestWithSetRemoteWithPower:@"ON"];
        }break;
        case REMOCON_MAIN_VIEW_BTN_03:
        {
            // 채널 버튼
            
        }break;
        case REMOCON_MAIN_VIEW_BTN_04:
        {
            // 볼륨 다운 버튼
            [self requestWithSetRemoteWithVolume:@"DOWN"];
        }break;
        case REMOCON_MAIN_VIEW_BTN_05:
        {
            // 볼륨 업 버튼
            [self requestWithSetRemoteWithVolume:@"UP"];
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
        DDLogError(@"delete");
    }
}

#pragma mark - 전문
#pragma mark - 볼룸 조절 전문 리스트 UP, DOWN
- (void)requestWithSetRemoteWithVolume:(NSString *)volume
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary remoconSetRemoteVolumeControlVolume:volume completion:^(NSArray *pvr, NSError *error) {
        
        DDLogError(@"볼륨 조절 = [%@]", pvr);
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 셋탑 전원 전문 리스트 ON, OFF
- (void)requestWithSetRemoteWithPower:(NSString *)power
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary remoconSetRemotoePowerControlPower:power completion:^(NSArray *pvr, NSError *error) {
        
        DDLogError(@"셋탑 전원 전문 = [%@]", pvr);
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

@end
