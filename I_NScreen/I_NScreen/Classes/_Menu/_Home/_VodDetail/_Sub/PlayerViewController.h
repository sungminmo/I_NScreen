//
//  PlayerViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 30..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CMBaseViewController.h"

@protocol PlayerViewDelegate;

@interface PlayerViewController : CMBaseViewController

@property (nonatomic, weak) id <PlayerViewDelegate>delegate;

@property (readwrite, retain) MPMoviePlayerController *pMoviePlayer;
@property (nonatomic, strong) NSString *pFileNameStr;
@property (nonatomic, strong) NSString *pStyleStr;  // play, preview

@end

@protocol PlayerViewDelegate <NSObject>

@optional
//- (void) PlayerViewDrmInit;

@end