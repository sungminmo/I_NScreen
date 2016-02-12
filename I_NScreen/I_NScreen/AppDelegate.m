//
//  AppDelegate.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 8. 12..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "AppDelegate.h"
#import "CMBaseViewController.h"
#import "RootViewController.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "UINavigationBar+CustomHeight.h"
//#import "DDLog.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
//yyyyMMddHHmm

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 쿠키 설정.
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    int cacheSizeMemory = 8 * 1024 * 1024; // 8MB
    int cacheSizeDisk = 32 * 1024 * 1024;  // 32MB
    cacheSizeDisk = 0;
    cacheSizeMemory = 0;
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:URLCache];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    // CocoaLumberjack: 로깅.
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    
    // 앱 실행시 keychain uuid 가 없으면 생성
    [[CMAppManager sharedInstance] setKeychainUniqueUuid];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    RootViewController *pViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    pViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.m_pNaviCon = [[CMNavigationController alloc] initWithRootViewController:pViewController];
    self.m_pNaviCon.navigationBarHidden = YES;
    self.window.rootViewController = self.m_pNaviCon;
    [self.window makeKeyAndVisible];
    
    
    [self settingCommonApperance];//공통 디자인을 세팅한다.
    
    
    
    UILocalNotification *notif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notif != nil)
    {
        // 노티 온 데이터 디비에서 삭제
        [[CMAppManager sharedInstance] notiBuyListRegist:notif.userInfo WithSetRemove:NO];
        
        [SIAlertView alert:notif.alertAction message:notif.alertBody button:@"확인"];
    }
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
    if (!url) {
        return NO;
    }
    
    DDLogInfo(@"url recieved: %@", url);
    DDLogInfo(@"scheme: %@", [url scheme]);
    DDLogInfo(@"query string: %@", [url query]);
    DDLogInfo(@"host: %@", [url host]);
    DDLogInfo(@"url path: %@", [url path]);
    NSDictionary *dict = [NSString parseQueryString:[url query]];
    DDLogInfo(@"query dict: %@", dict);
    
    if ([[url host] isEqualToString:@"adult_auth"]) {//성인인증 정보처리 
        [[NSNotificationCenter defaultCenter] postNotificationName:CNMHandleOpenURLNotification object:[dict copy]];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    [self application:app openURL:url sourceApplication:nil annotation:nil];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)settingCommonApperance {
    //네비게이션
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version >= 8.0){
        [[UINavigationBar appearance] setTranslucent:NO];
    }
    [[UINavigationBar appearance] setBackgroundColor:[CMColor colorViolet]];
    [[UINavigationBar appearance] setBarTintColor:[CMColor colorViolet]];
    self.m_pNaviCon.navigationBar.height = cmNavigationHeight - 20;
    
    // 네비게이션바 타이틀 커스텀폰트, 컬러 설정.
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    
//    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//    [style setAlignment:NSTextAlignmentCenter];
//    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *dict = @{
                           NSForegroundColorAttributeName:[UIColor whiteColor],
                           NSFontAttributeName:[UIFont boldSystemFontOfSize:22],
//                           NSParagraphStyleAttributeName: [style copy],
                           NSShadowAttributeName : shadow.copy
                           };
    [[UINavigationBar appearance] setTitleTextAttributes:dict];
    
    float h_padding = (cmNavigationHeight - 44)/2 - 10;
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:-h_padding forBarMetrics:UIBarMetricsDefault];
    
    
    //얼럿뷰
    [[SIAlertView appearance] setMessageFont:[UIFont systemFontOfSize:13]];
    [[SIAlertView appearance] setTitleColor:[CMColor colorViolet]];
    [[SIAlertView appearance] setMessageColor:[UIColor blackColor]];
    [[SIAlertView appearance] setCornerRadius:0];
    [[SIAlertView appearance] setShadowRadius:0];
    [[SIAlertView appearance] setViewBackgroundColor:[CMColor colorWhite]];
    [[SIAlertView appearance] setButtonColor:[CMColor colorWhite]];
    [[SIAlertView appearance] setCancelButtonColor:[CMColor colorWhite]];
    [[SIAlertView appearance] setBackgroundStyle:SIAlertViewBackgroundStyleSolid];

    UIImage* clImage = [UIImage imageWithColor:[CMColor colorLightViolet] withAlpha:1 withSize:CGSizeMake(30, 12)];
    UIImage* okImage = [UIImage imageWithColor:[CMColor colorGray] withAlpha:1 withSize:CGSizeMake(30, 12)];
    
    UIImage* clImage_s = [UIImage imageWithColor:[CMColor colorViolet] withAlpha:1 withSize:CGSizeMake(30, 12)];
    UIImage* okImage_s = [UIImage imageWithColor:[CMColor colorHighlightedGray] withAlpha:1 withSize:CGSizeMake(30, 12)];
    
    [[SIAlertView appearance] setDefaultButtonImage:[okImage resizableImageWithCapInsets:UIEdgeInsetsMake(15,5,14,6)] forState:UIControlStateNormal];
    [[SIAlertView appearance] setDefaultButtonImage:[okImage_s resizableImageWithCapInsets:UIEdgeInsetsMake(15,5,14,6)] forState:UIControlStateHighlighted];
    [[SIAlertView appearance] setCancelButtonImage:[clImage resizableImageWithCapInsets:UIEdgeInsetsMake(15,5,14,6)] forState:UIControlStateNormal];
    [[SIAlertView appearance] setCancelButtonImage:[clImage_s resizableImageWithCapInsets:UIEdgeInsetsMake(15,5,14,6)] forState:UIControlStateHighlighted];
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // 노티 온 데이터 디비에서 삭제
    [[CMAppManager sharedInstance] notiBuyListRegist:notification.userInfo WithSetRemove:NO];
    
    [SIAlertView alert:notification.alertAction message:notification.alertBody button:@"확인"];
}

#pragma mark - orientation
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    CMNavigationController* navigation = (CMNavigationController*)self.window.rootViewController;
    NSString* className = NSStringFromClass([navigation.viewControllers.lastObject class]);
    if ([className isEqualToString:@"PlayerViewController"]) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

@end
