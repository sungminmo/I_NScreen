//
//  CMAdultAuthViewController.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 11. 1..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMAdultAuthViewController.h"

@interface CMAdultAuthViewController () <UIWebViewDelegate>
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *topConstraint;
@property (nonatomic, weak) IBOutlet UIWebView* webView;
@property (nonatomic, unsafe_unretained) BOOL isWorking;

@end

@implementation CMAdultAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"성인인증";
    self.isUseNavigationBar = YES;
    self.topConstraint.constant = cmNavigationHeight;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://58.141.255.80/CheckPlusSafe_ASP/checkplus_main.asp"]]];
    self.isWorking = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIWebViewDelegate 
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL* url = request.URL;
    DDLogInfo(@"%@", url.absoluteString);
    
/*
 
 2015-11-08 16:42:23:532 I_NScreen[4483:84625] http://58.141.255.80/CheckPlusSafe_ASP/checkplus_main.asp
 2015-11-08 16:42:23:583 I_NScreen[4483:84625] https://nice.checkplus.co.kr/CheckPlusSafeModel/checkplus.cb
 2015-11-08 16:42:23:675 I_NScreen[4483:84625] https://nice.checkplus.co.kr/CheckPlusSafeModel/checkplus.cb?m=auth_mobile_main
 2015-11-08 16:42:25:526 I_NScreen[4483:84625] https://nice.checkplus.co.kr/CheckPlusSafeModel/checkplus.cb
 2015-11-08 16:42:25:652 I_NScreen[4483:84625] about:blank
 2015-11-08 16:42:25:654 I_NScreen[4483:84625] about:blank
 2015-11-08 16:42:52:965 I_NScreen[4483:84625] https://nice.checkplus.co.kr/Captcha/checkplus.cb
 2015-11-08 16:42:52:990 I_NScreen[4483:84625] https://nice.checkplus.co.kr/CheckPlusSafeModel/checkplus.cb
 2015-11-08 16:43:05:434 I_NScreen[4483:84625] https://nice.checkplus.co.kr/CheckPlusSafeModel/checkplus.cb
 2015-11-08 16:43:05:595 I_NScreen[4483:84625] https://nice.checkplus.co.kr/CheckPlusSafeModel/checkplus.cb?m=checkplusSerivce_resultSend
 2015-11-08 16:43:05:616 I_NScreen[4483:84625] http://58.141.255.80/CheckPlusSafe_ASP/checkplus_success.asp
 
 
 cnm_app://adult_auth?result=Y (성공)
 cnm_app://adult_auth?result=N (실패)
 
 */
    
    if ([url.absoluteString isEqualToString:@"about:blank"]) {
        return NO;
    }
    

    if ([url.absoluteString rangeOfString:@"checkplus_success"].location != NSNotFound) {
        [self performSelector:@selector(handleOpenUrlForAdultCertSuccess) withObject:nil afterDelay:1];
        return YES;
    }
    //실패시 재시도 하게 되어 있음으로 그냥 유지하자...
    
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self handleOpenUrlForAdultCertSuccess];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
}

#pragma mark - 
- (void)handleOpenUrlForAdultCertSuccess {
    if (self.isWorking == NO) {
        return;
    }
    [self backCommonAction];
    self.isWorking = NO;
    NSURL *url = [NSURL URLWithString:@"cnmapp://adult_auth?result=Y"];
    [[UIApplication sharedApplication] openURL:url];
}

@end
