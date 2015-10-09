//
//  CMTextField.h
//  I_NScreen
//
//  Created by kimtaeksoo on 2015. 9. 30..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    Normal_CMTextFieldType,
    Secure_CMTextFieldType
}CMTextFieldType;

@interface CMTextField : UITextField <UITextFieldDelegate>

@property (nonatomic, assign) CMTextFieldType type;

- (void)changeColor:(UIColor*)color;
- (void)resetColor;

@end
