//
//  PlayerViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 30..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "PlayerViewController.h"
#import "WViPhoneAPI.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController
@synthesize pUrlStr;
@synthesize delegate;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"스트리밍";
    self.isUseNavigationBar = YES;
    
    
    if ( [self.pUrlStr length] != 0 )
    {
        NSURL *url = [NSURL URLWithString:self.pUrlStr];
        MPMoviePlayerController *mp = [[MPMoviePlayerController alloc]
                                       initWithContentURL:url];
        self.pMoviePlayer = mp;
        //                    [mp release];
        self.pMoviePlayer.view.frame = CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self.view addSubview:self.pMoviePlayer.view];

        [self.pMoviePlayer play];
    }
}

- (void) actionBackButton:(id)sender
{
    WV_Stop();
    WV_Terminate();
    
    [self.navigationController popViewControllerAnimated:NO];
    
    [self.delegate PlayerViewDrmInit];
}

@end
