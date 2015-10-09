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
    }
    return self;
}



- (void)defaultSetting {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

    [ud setAppType:CMAppTypePhone];
    [ud setRestrictType:CMContentsRestrictedTypeAdult];
    
    [ud synchronize];
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

@end
