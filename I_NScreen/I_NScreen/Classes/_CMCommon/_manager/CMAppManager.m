//
//  CMAppManager.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 8. 18..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "CMAppManager.h"
#import "LeftMenuViewController.h"

@implementation CMAppManager

+ (CMAppManager *)sharedInstance {
    static CMAppManager *sharedInstanced = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstanced = [[self alloc] init];
    });
    return sharedInstanced;
}

- (id)init {
    if (self = [super init]) {
        
        self.isFirst = [self isFirstLoading];
        if (self.isFirst) {
            [self defaultSetting];
        }

    }
    return self;
}

- (void)defaultSetting {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setAppType:CMAppTypePhone];
    [ud setRestrictType:CMContentsRestrictedTypeAdult];
    [ud synchronize];
}

- (BOOL)isFirstLoading {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL isFirst = [ud boolForKey:@"CMFirstApplicationLoading"];
    
    if (!isFirst) {
        [ud setBool:YES forKey:@"CMFirstApplicationLoading"];
    }
    
    return !isFirst;
}

#pragma mark -
- (void)onLeftMenuListOpen:(id)control;
{
    LeftMenuViewController *pViewController = [[LeftMenuViewController alloc] initWithNibName:@"LeftMenuViewController" bundle:nil];
    pViewController.delegate = control;
    
    [control addChildViewController:pViewController];
    [pViewController didMoveToParentViewController:control];
    [[control view] addSubview:pViewController.view];
    
    pViewController.view.frame = CGRectMake(-[control view].frame.size.width, 0, [control view].frame.size.width, [control view].frame.size.height);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    pViewController.view.frame = CGRectMake(0, 0, [control view].frame.size.width, [control view].frame.size.height);
    [UIView commitAnimations];

}

- (void)onLeftMenuListClose:(id)control;
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         [control view].frame = CGRectMake(-[control view].frame.size.width, 0, [control view].frame.size.width, [control view].frame.size.height);
                     } completion:^(BOOL finished) {
                         [[control view] removeFromSuperview];
                         [control willMoveToParentViewController:nil];
                         [control removeFromParentViewController];
                         
                         if ( [control respondsToSelector:@selector(onLeftMenuCloseComplet)])
                         {
                             [control onLeftMenuCloseComplet];
                         }
                     }];

}

#pragma mark - 디바이스 체크
- (NSString *)getDeviceCheck
{
    int nHeight = [UIScreen mainScreen].bounds.size.height;

    NSString *sVersion;
    
    if ( nHeight >= 736 )
    {
        // 6+
        sVersion = [NSString stringWithFormat:@"%@", IPHONE_RESOLUTION_6_PLUS];
    }
    else if ( nHeight < 736 && nHeight >= 667 )
    {
        // 6
        sVersion = [NSString stringWithFormat:@"%@", IPHONE_RESOLUTION_6];
    }
    else if ( nHeight < 667 && nHeight >= 568 )
    {
        // 5
        sVersion = [NSString stringWithFormat:@"%@", IPHONE_RESOLUTION_5];
    }
    else
    {
        // 4
        sVersion = [NSString stringWithFormat:@"%@", IPHONE_RESOLUTION_ELSE];
    }
    
    return sVersion;
}

@end
