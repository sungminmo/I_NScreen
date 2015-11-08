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
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:URLCache];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    // CocoaLumberjack: 로깅.
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    RootViewController *pViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    pViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.m_pNaviCon = [[CMNavigationController alloc] initWithRootViewController:pViewController];
    self.m_pNaviCon.navigationBarHidden = YES;
    self.window.rootViewController = self.m_pNaviCon;
    [self.window makeKeyAndVisible];
    
    
    [self settingCommonApperance];//공통 디자인을 세팅한다.
    
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
    [[UINavigationBar appearance] setBarTintColor:[CMColor colorViolet]];
    self.m_pNaviCon.navigationBar.height = cmNavigationHeight - 20;
    
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


@end
