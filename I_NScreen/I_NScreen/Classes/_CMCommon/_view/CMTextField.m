//
//  CMTextField.m
//  I_NScreen
//
//  Created by kimteaksoo on 2015. 9. 30..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMTextField.h"

@interface CMTextField ()

@property (nonatomic, assign) id<UITextFieldDelegate> textFieldDelegate;

@end

@implementation CMTextField

#pragma mark - Life Cycle

- (void)awakeFromNib {

    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 1.f;
    self.layer.cornerRadius = 4.0f;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [CMColor colorViolet].CGColor;
    
    [super setDelegate:self];
}

#pragma mark - Override

- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    self.textFieldDelegate = delegate;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    self.layer.borderColor = [UIColor redColor].CGColor;
    
    if ([self.textFieldDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.textFieldDelegate textFieldShouldBeginEditing:textField];
    } else {
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if ([self.textFieldDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.textFieldDelegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    self.layer.borderColor = [CMColor colorViolet].CGColor;
    
    if ([self.textFieldDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.textFieldDelegate textFieldShouldEndEditing:textField];
    } else {
        return  YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.layer.borderColor = [CMColor colorViolet].CGColor;
    
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
    
    if ([self.textFieldDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.textFieldDelegate textFieldShouldReturn:textField];
    } else {
        return YES;
    }
}

@end
