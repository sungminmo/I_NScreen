//
//  CMTextField.m
//  I_NScreen
//
//  Created by kimteaksoo on 2015. 9. 30..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMTextField.h"
#import "CMCustomNumberPadView.h"

@interface CMTextField ()

@property (nonatomic, assign) id<UITextFieldDelegate> textFieldDelegate;
@property (nonatomic, strong) UIButton* doneButton;

@end

@implementation CMTextField

#pragma mark - Life Cycle

- (id)init {
    if (self = [super init]) {
        [super setDelegate:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)awakeFromNib {

    [super setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public 

- (void)setType:(CMTextFieldType)type {
    _type = type;
    
    if (Secure_CMTextFieldType == type) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1.f;
        self.layer.cornerRadius = 4.0f;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [CMColor colorViolet].CGColor;
    }
}

- (void)changeColor:(UIColor*)color {
    self.layer.borderColor = color.CGColor;
    self.textColor = color;
}

- (void)resetColor {
    self.layer.borderColor = [CMColor colorViolet].CGColor;
    self.textColor = [CMColor colorViolet];
}

#pragma mark - Override

- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    self.textFieldDelegate = delegate;
}

#pragma mark - Event 
- (void)buttonWasTouchUpInside:(id)sender {
    
    [self textFieldShouldReturn:self];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([self.textFieldDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.textFieldDelegate textFieldShouldBeginEditing:textField];
    } else {
        return YES;
    }
}

- (void)addDoneButton {
    if (self.keyboardType == UIKeyboardTypeNumberPad) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f) {
            
            NSArray *listViews = [[NSBundle mainBundle] loadNibNamed:@"CMCustomNumberPadView" owner:nil options:nil];
            CMCustomNumberPadView *textFieldView = listViews[0];
            
            self.inputView = textFieldView;
            
            textFieldView.textField = self;
            textFieldView.doneBlock = ^void(UITextField* textField) {
                [self textFieldShouldReturn:textField];
            };
            
        } else {
            
            UIWindow* tempWindow;
            UIView* keyboard;
            
            if([[UIApplication sharedApplication] windows].count > 1){
                tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
            }else{
                return;
            }

            for(int i=0; i<[tempWindow.subviews count]; i++) {
                
                keyboard = [tempWindow.subviews objectAtIndex:i];
                
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
                    
                    if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES) {
                        self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        self.doneButton.tag = 999999;
                        self.doneButton.frame = CGRectMake(0, 163, 106, 53);
                        self.doneButton.adjustsImageWhenHighlighted = NO;
//                        [doneButton setBackgroundImage:[UIImage imageNamed:@"iphone_common_img_numkey_done_peace.png"] forState:UIControlStateNormal];
//                        [doneButton setBackgroundImage:[UIImage imageNamed:@"iphone_common_img_numkey_done_press.png"] forState:UIControlStateHighlighted];
                        [self.doneButton setTitle:@"DONE" forState:UIControlStateNormal];
                        [self.doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [self.doneButton addTarget:self action:@selector(buttonWasTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
                        [keyboard addSubview:self.doneButton];
                    } else if([[keyboard description] hasPrefix:@"<UIInputSetContainerView"] == YES){
                        self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        self.doneButton.tag = 999999;
                        self.doneButton.frame = CGRectMake(0,[[ UIScreen mainScreen] bounds ].size.height-53, 106, 53);
                        self.doneButton.adjustsImageWhenHighlighted = NO;
//                        [doneButton setBackgroundImage:[UIImage imageNamed:@"iphone_common_img_numkey_done_peace.png"] forState:UIControlStateNormal];
//                        [doneButton setBackgroundImage:[UIImage imageNamed:@"iphone_common_img_numkey_done_press.png"] forState:UIControlStateHighlighted];
                        [self.doneButton setTitle:@"DONE" forState:UIControlStateNormal];
                        [self.doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [self.doneButton addTarget:self action:@selector(buttonWasTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
                        
                        [keyboard addSubview:self.doneButton];
                    }
                }
                else {
                    if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES) {
                        self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        self.doneButton.tag = 999999;
                        self.doneButton.frame = CGRectMake(0, 163, 106, 53);
                        self.doneButton.adjustsImageWhenHighlighted = NO;
//                        [doneButton setBackgroundImage:[UIImage imageNamed:@"iphone_common_img_numkey_done_peace.png"] forState:UIControlStateNormal];
//                        [doneButton setBackgroundImage:[UIImage imageNamed:@"iphone_common_img_numkey_done_press.png"] forState:UIControlStateHighlighted];
                        [self.doneButton setTitle:@"DONE" forState:UIControlStateNormal];
                        [self.doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [self.doneButton addTarget:self action:@selector(buttonWasTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
                        
                        [keyboard addSubview:self.doneButton];
                    }
                }
            }
        }
    }
}

- (void)keyboardWillShow:(NSNotification*)notification {
    
    if ([self isFirstResponder] == false) {
        return;
    }
    
    UINavigationController* navigationController = (UINavigationController*)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    CGRect rootViewFrame = navigationController.view.frame;

    NSDictionary* keyboardInfo = [notification userInfo];
    CGRect keyboardFrame = [[keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    CGRect frame = [self.window convertRect:self.frame fromView:self.superview];
    
    CGFloat bottomPadding = 3;
    if (keyboardFrame.origin.y < frame.origin.y + bottomPadding) {
        
        CGFloat calcY;
        
        if ((CGRectGetMaxY(frame) <= keyboardFrame.origin.y) && (keyboardFrame.origin.y - CGRectGetMaxY(frame) < bottomPadding)) {
            calcY = bottomPadding - (keyboardFrame.origin.y - CGRectGetMaxY(frame));
        } else {
            calcY = CGRectGetMaxY(frame) - keyboardFrame.origin.y + bottomPadding;
        }
        
        rootViewFrame.origin.y -= calcY;
        [UIView animateWithDuration:.4 animations:^{
            navigationController.view.frame = rootViewFrame;
        }];
    }
}

- (void)keyboardWillHide:(NSNotification*)noti {
    
    UINavigationController* navigationController = (UINavigationController*)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    CGRect rootViewFrame = navigationController.view.frame;
    rootViewFrame.origin.y = 0;
    
    [UIView animateWithDuration:.4 animations:^{
        navigationController.view.frame = rootViewFrame;
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self addDoneButton];
    
    if ([self.textFieldDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.textFieldDelegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if ([self.textFieldDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.textFieldDelegate textFieldShouldEndEditing:textField];
    } else {
        return  YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [self.doneButton removeFromSuperview];
    self.doneButton = nil;
    
    if ([self.textFieldDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.textFieldDelegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([self.textFieldDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.textFieldDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    if ([self.textFieldDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [self.textFieldDelegate textFieldShouldClear:textField];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self resignFirstResponder];
    
    if ([self.textFieldDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.textFieldDelegate textFieldShouldReturn:textField];
    } else {
        return YES;
    }
}

@end

