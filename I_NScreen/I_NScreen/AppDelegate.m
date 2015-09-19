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
    self.m_pNaviCon = [[CMNavigationController alloc] initWithRootViewController:pViewController];
    self.m_pNaviCon.navigationBarHidden = YES;
    self.window.rootViewController = self.m_pNaviCon;
    [self.window makeKeyAndVisible];
    
    
    [self settingCommonApperance];//공통 디자인을 세팅한다. 
    
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
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"7b5aa3"]];
    self.m_pNaviCon.navigationBar.height = 93;
}


@end
