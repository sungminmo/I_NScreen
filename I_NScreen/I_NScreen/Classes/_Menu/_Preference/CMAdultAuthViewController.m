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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIWebViewDelegate 
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {

}


@end
