//
//  TestPageViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 29..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "TestPageViewController.h"
//#import "WViPhoneAPI.h"

@interface TestPageViewController ()
@property (nonatomic, strong)NSDictionary *pDic;
@end

@implementation TestPageViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTagInit];
    
    self.pDic = [[NSDictionary alloc] init];
}

- (void)setTagInit
{
    self.pBackBtn.tag = TEST_PAGE_VIEW_BTN_01;
    self.pInitBtn.tag = TEST_PAGE_VIEW_BTN_02;
    self.pPlayBtn.tag = TEST_PAGE_VIEW_BTN_03;
}

- (IBAction)onBtnClicked:(UIButton *)btn
{
    switch ([btn tag]) {
        case TEST_PAGE_VIEW_BTN_01:
        {
            // back
            [self.navigationController popViewControllerAnimated:YES];
        }break;
        case TEST_PAGE_VIEW_BTN_02:
        {
            // init
            
//            NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                        @"http://proxy.video.toast.com/widevine/drm/dls.do", WVDRMServerKey,
//                                        @"markanynhne", WVPortalKey,
//                                        @",user_id:myjulyyi,content_id:M0431531LFO259395100|www.hchoice.co.kr,device_key:648a16b50911464aaf92801c4ea88b31,so_idx:10", WVCAUserDataKey,
//                                        NULL];
//            
            
//          NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                      @"http://proxy.video.toast.com/widevine/drm/dls.do", WVDRMServerKey,
//                                      @"sess4321", WVSessionIdKey,
//                                      @"cli0123", WVClientIdKey,
//                                      @"markanynhne", WVPortalKey,
//                                      @"XXXuser-dataXXX", WVCAUserDataKey,
//                                      @"XXXclientipXXX", WVClientIPKey,
//                                      @"http://kir03fcpg174.widevine.net/widevine/cypherpc/cgi-bin/Heartbeat.cgi",
//                                      WVHeartbeatUrlKey,
//                                      @"5", WVHeartbeatPeriodKey,
////                                      ((nativeAdapting_ == YES)?@"1":@"0"),
////                                      WVPlayerDrivenAdaptationKey,
////                                      @"0", WVUseJSONKey,
////                                      @"0", WVUseEncryptedLoopback,
//                                      NULL];
            
//            WV_Initialize(WViPhoneCallback, dictionary);
        }break;
        case TEST_PAGE_VIEW_BTN_03:
        {
            // play
//            NSMutableString *responseUrl = [NSMutableString string];
//            
//            WV_Play(@"http://cjhv.video.toast.com/aaaaaa/5268a42c-5bfe-46ac-b8f0-9c094ee5327b.wvm", responseUrl, 0);
//            
//            NSLog(@"data = [%@]", responseUrl);
        }break;
    }
}

//WViOsApiStatus WViPhoneCallback(WViOsApiEvent event, NSDictionary *attributes) {
//    NSLog( @"callback %d %@ %@\n", event,
//          NSStringFromWViOsApiEvent( event ), attributes );
////    @autoreleasepool {
////        SEL selector = 0;
////        
////        switch ( event ) {
////            case WViOsApiEvent_SetCurrentBitrate:
////                selector = NSSelectorFromString(@"HandleCurrentBitrate:");
////                break;
////            case WViOsApiEvent_Bitrates:
////                selector = NSSelectorFromString(@"HandleBitrates:");
////                break;
////            case WViOsApiEvent_ChapterTitle:
////                selector = NSSelectorFromString(@"HandleChapterTitle:");
////                break;
////            case WViOsApiEvent_ChapterImage:
////                selector = NSSelectorFromString(@"HandleChapterImage:");
////                break;
////            case WViOsApiEvent_ChapterSetup:
////                NSLog( @"WViOsApiEvent_ChapterSetup\n" );
////                selector = NSSelectorFromString(@"HandleChapterSetup:");
////                break;
////            default:
////                break;
////        }
////        if (selector) {
////            [attributes retain];
////            [s_iPhonePlayer performSelectorOnMainThread:selector
////                                             withObject:attributes waitUntilDone:NO];
////        }
////        [s_iPhonePlayer.appDelegate_.debugNotes_
////         insertString:[NSString stringWithFormat:@"callback %d %@ %@\n", event,
////                       NSStringFromWViOsApiEvent( event ), attributes] atIndex: 0];
////        if (s_iPhonePlayer.appDelegate_.debugLogs_ != nil) {
////            [s_iPhonePlayer
////             performSelectorOnMainThread:NSSelectorFromString(@"updateLogs")
////             withObject:nil
////             waitUntilDone:NO];
////        }
////    }
//    
//    
//    
//    return WViOsApiStatus_OK;
//}



@end
