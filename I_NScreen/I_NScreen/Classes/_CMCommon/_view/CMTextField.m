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

@end

@implementation CMTextField

#pragma mark - Life Cycle

- (void)awakeFromNib {

    [super setDelegate:self];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([self.textFieldDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.textFieldDelegate textFieldShouldBeginEditing:textField];
    } else {
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f)
    {
        if(self.keyboardType == UIKeyboardTypeNumberPad)
        {
            NSArray *listViews = [[NSBundle mainBundle] loadNibNamed:@"CMCustomNumberPadView" owner:nil options:nil];
            CMCustomNumberPadView *textFieldView = listViews[0];
            
            self.inputView = textFieldView;
            
            textFieldView.textField = self;
            textFieldView.doneBlock = ^void(UITextField* textField) {
                [self textFieldShouldReturn:textField];
            };
        }
    }
    
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

