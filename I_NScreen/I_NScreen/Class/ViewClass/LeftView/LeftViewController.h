//
//  LeftViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 8. 27..
//  Copyright (c) 2015년 JUNG KIL BAE. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftViewControllerDelegate;

@interface LeftViewController : UIViewController

@property (nonatomic, assign) id <LeftViewControllerDelegate>delegate;

- (IBAction)onCloseBtnClick:(id)sender;

- (void)onCloseCollback;

@end

@protocol LeftViewControllerDelegate <NSObject>

@optional
- (void)onCloseCompletionReflash;

@end