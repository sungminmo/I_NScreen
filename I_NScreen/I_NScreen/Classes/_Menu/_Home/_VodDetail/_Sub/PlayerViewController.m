//
//  PlayerViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 30..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "PlayerViewController.h"
#import "WViPhoneAPI.h"
#import "NSMutableDictionary+DRM.h"
#import "UIAlertView+AFNetworking.h"
#import "CMDBDataManager.h"
#import "AppDelegate.h"

#define degreesToRadian(x)(M_PI*x/180.0)

@interface PlayerViewController ()
@property (nonatomic, strong) NSMutableDictionary *pDrmDic;
@end

@implementation PlayerViewController
@synthesize delegate;
@synthesize pFileNameStr;
@synthesize pStyleStr;
@synthesize pAssetId;
@synthesize pDate;
@synthesize pTitle;

static PlayerViewController *playerViewCtr;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 강제 회전 모드
-(void)SetDeviceOrientation:(UIInterfaceOrientation)orientation
{
    //가로보기 강제
    if(orientation==UIInterfaceOrientationPortrait)
    {
        orientation=UIInterfaceOrientationLandscapeLeft;
    }
    //세로보기 강제
    else if(orientation==UIInterfaceOrientationLandscapeLeft)
    {
        orientation=UIInterfaceOrientationPortrait;
    }
    
    
    int radian=0;
    CGRect viewFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration: 0.2];
    
    if(orientation==UIInterfaceOrientationLandscapeLeft
       || orientation==UIInterfaceOrientationLandscapeRight)
    {
        viewFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        
    }
    if(orientation==UIInterfaceOrientationPortrait)
    {
        radian=0;
    }
    else if(orientation==UIInterfaceOrientationPortraitUpsideDown)
    {
        radian=180;
    }
    else if(orientation==UIInterfaceOrientationLandscapeRight)
    {
        radian=90;
    }
    else if(orientation==UIInterfaceOrientationLandscapeLeft)
    {
        radian=270;
    }
    
    //뷰 회전 시키기
    CGAffineTransform transform =
    CGAffineTransformMakeRotation(degreesToRadian(radian));
    
    self.view.transform=transform;
    self.view.bounds=viewFrame;
    
    [UIView commitAnimations];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}


- (void)dealloc {
    WV_Stop();
    WV_Terminate();
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self SetDeviceOrientation:UIInterfaceOrientationPortrait];
    
    self.title = @"스트리밍";
    self.isUseNavigationBar = NO;
    
    self.pMoviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@""]];
    self.pMoviePlayer.view.frame = CGRectMake(0,0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    [self.pMoviePlayer setFullscreen:YES animated:YES];
    [self.pMoviePlayer setControlStyle:MPMovieControlStyleFullscreen];
    
    [self.view addSubview:self.pMoviePlayer.view];
    
    [self setViewInit];
}

#pragma mark - 초기화
#pragma mark - 화면 초기화
- (void)setViewInit
{
    // drm 초기화
    playerViewCtr = self;
    self.pDrmDic = [[NSMutableDictionary alloc] init];
 
    // Remove the movie player view controller from the "playback did finish" notification observers
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];
    
    // Register this class as an observer instead
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    
    [self requestWithDrm];
}


-(void)movieFinishedCallback:(NSNotification*)aNotification
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - back 버튼
- (void) actionBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - 전문
#pragma mark - drm 전문
- (void)requestWithDrm
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary drmApiWithAsset:self.pFileNameStr WithPlayStyle:self.pStyleStr completion:^(NSDictionary *drm, NSError *error) {
        
        NSLog(@"drm = [%@]", drm);
        
        [self.pDrmDic removeAllObjects];
        [self.pDrmDic setDictionary:drm];
        
        NSString* key = [[[CMAppManager sharedInstance] getKeychainPrivateTerminalKey] copy];
        NSString* assetId = [self.pAssetId copy];
        NSString* userData = [NSString stringWithFormat:@",user_id:%@,content_id:%@,device_key:%@,so_idx:10", key, assetId, key];
        
        NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [self.pDrmDic objectForKey:@"drmServerUri"], WVDRMServerKey,
                                    @"markanynhne", WVPortalKey,
                                    userData, WVCAUserDataKey,
                                    NULL];
        
        WV_Initialize(WViPhoneCallback, dictionary);
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

WViOsApiStatus WViPhoneCallback(WViOsApiEvent event, NSDictionary *attributes) {
    NSLog( @"callback %d %@ %@\n", event,
          NSStringFromWViOsApiEvent( event ), attributes );
    @autoreleasepool {
        SEL selector = 0;
        
        switch ( event ) {
            case WViOsApiEvent_SetCurrentBitrate:
                selector = NSSelectorFromString(@"HandleCurrentBitrate:");
                break;
            case WViOsApiEvent_Bitrates:
                selector = NSSelectorFromString(@"HandleBitrates:");
                break;
            case WViOsApiEvent_ChapterTitle:
                selector = NSSelectorFromString(@"HandleChapterTitle:");
                break;
            case WViOsApiEvent_ChapterImage:
                selector = NSSelectorFromString(@"HandleChapterImage:");
                break;
            case WViOsApiEvent_ChapterSetup:
                NSLog( @"WViOsApiEvent_ChapterSetup\n" );
                selector = NSSelectorFromString(@"HandleChapterSetup:");
                break;
            case WViOsApiEvent_InitializeFailed:
                NSLog(@"WViOsApiEvent_InitializeFailed:");
                break;
            case WViOsApiEvent_Initialized:
                // 초기화
                [playerViewCtr drmStart];
                break;
            default:
                break;
        }
        
    }
    return WViOsApiStatus_OK;
}

- (void)drmStart
{
    if ( [[self.pDrmDic objectForKey:@"contentUri"] length] == 0 )
    {
        [SIAlertView alert:@"VOD 시청 안내"
                   message:@"구매하신 VOD는 모바일용으로 준비 중에 있습니다.\n빠른 시일 내에 모바일에서 시청하실 수 있도록 조치하겠습니다.\n(본 VOD는 TV에서 시청 가능합니다.)"
                    button:@"확인"
                completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                    [self.navigationController popViewControllerAnimated:NO];
                }];
    }
    else
    {
        NSMutableString *responseUrl = [NSMutableString string];
        
        NSString *sContentUrl = [NSString stringWithFormat:@"%@", [self.pDrmDic objectForKey:@"contentUri"]];
        NSString *sNewContentUrl = [sContentUrl stringByReplacingOccurrencesOfString:@"widevine" withString:@"http"];

        WV_Play(sNewContentUrl, responseUrl, 0);
        
        
        if ( [responseUrl length] != 0 )
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.pTitle, @"title", self.pAssetId, @"assetId", [[CMAppManager sharedInstance] GetToday], @"date", nil];
            CMDBDataManager *manager = [CMDBDataManager sharedInstance];
            [manager setVodWatchList:dic];
            
            NSURL *url = [NSURL URLWithString:responseUrl];
            [self.pMoviePlayer setContentURL:url];
            
            [self.pMoviePlayer play];

        }
        else
        {
            [SIAlertView alert:@"VOD 시청 안내"
                       message:@"구매하신 VOD는 모바일용으로 준비 중에 있습니다.\n빠른 시일 내에 모바일에서 시청하실 수 있도록 조치하겠습니다.\n(본 VOD는 TV에서 시청 가능합니다.)"
                        button:@"확인"
                    completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                        [self.navigationController popViewControllerAnimated:NO];
                    }];
        }
    }
}

@end
