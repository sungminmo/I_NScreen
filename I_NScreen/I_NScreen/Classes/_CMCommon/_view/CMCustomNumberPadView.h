//
//  IKTextFieldInputView.h
//  HanhwaIphone
//
//  Created by Rickseong on 2015. 8. 10..
//
//

#import <UIKit/UIKit.h>
#import "CMTextField.h"

typedef void (^DoneBlock) (UITextField* textField);

@interface CMCustomNumberPadView : UIView

@property UITextField *textField;
@property (nonatomic, copy) DoneBlock doneBlock;

@end
