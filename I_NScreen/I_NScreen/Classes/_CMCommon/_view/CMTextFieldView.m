//
//  CMTextFieldView.m
//  I_NScreen
//
//  Created by kimts on 2015. 10. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMTextFieldView.h"
#import "CMCustomNumberPadView.h"

static int tag_button_delete = 21001;//삭제버튼 태그
static int tag_button_done = 849404;

@interface CMTextFieldView () <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView* backgroundImageView;
@property (nonatomic, strong) UIButton* doneButton;

@end

@implementation CMTextFieldView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        //1. data
        self.placeHolder = @"";
        
        //2. subviews
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.backgroundImageView];
        
        self.inputField = [[UITextField alloc] initWithFrame:self.bounds];
        self.inputField.delegate = self;
        self.inputField.font = [UIFont systemFontOfSize:15];
        self.inputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:self.inputField];
        
        self.fieldLeftView = [[UIView alloc] initWithFrame:CGRectZero];
        self.fieldRightView = [[UIView alloc] initWithFrame:CGRectZero];
        self.inputField.leftView = self.fieldLeftView;
        self.inputField.rightView = self.fieldRightView;
        
        //3. default setting
        self.fieldState = CMTextFieldControlStateNormal;
        self.fieldType = CMTextFieldTypeDefault;
        self.fieldKeypad = CMTextFieldKeypadDefault;
        self.limitType = CMTextFieldLimitTypeNone;
        self.isCheckMaxInput = NO;
        _maxInput = 0;
        self.inputDelegate = nil;
        
        //4. 초성검색을 위한 이벤트 등록
        [self.inputField addTarget:self action:@selector(textMessageChanged:) forControlEvents:UIControlEventEditingChanged];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    if (CGRectEqualToRect(self.frame, frame)) {
        return;
    }
    [super setFrame:frame];
    [self clearSubLayers];
    self.backgroundImageView.frame = self.bounds;
    self.inputField.frame = self.bounds;
    self.fieldState = CMTextFieldControlStateNormal;
}

- (void)clearSubLayers {
    CALayer* layer = self.layer;
    NSArray* subLayers = layer.sublayers;
    for (NSInteger i = subLayers.count - 1; i >= 0 ; i--) {
        CALayer* subLayer = subLayers[i];
        if ([subLayer.name isEqualToString:@"outerLine"]) {
            [subLayer removeFromSuperlayer];
        }
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)setMaxInput:(NSInteger)maxInput {
    _maxInput = maxInput;
    if (_maxInput > 0) {
        self.isCheckMaxInput = YES;
    }
}

- (UIImage*)createBackgrroundImageWithFieldState:(CMTextFieldControlState)fieldState {
    
    NSString* imageName;
    switch ((NSInteger)_fieldState) {
        case CMTextFieldControlStateNormal: {
            imageName = @"pwbox.png";
        }
            break;
        case CMTextFieldControlStateActive: {
            imageName = @"pwbox.png";
        }
            break;
        case CMTextFieldControlStateDisable: {
            imageName = @"pwbox.png";
        }
            break;
        case CMTextFieldControlStateError: {
            imageName = @"pwbox_error.png";
        }
            break;
    }
    
    UIImage* image = [[UIImage imageNamed:@"pwbox.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 50, 10, 50)];
    
    return image;
}

- (void)setFieldState:(CMTextFieldControlState)fieldState {
    
    _fieldState = fieldState;
    
    [self clearSubLayers];
    
    self.inputField.enabled = YES;
    switch ((NSInteger)_fieldState) {
        case CMTextFieldControlStateNormal : {//정상
            
            if (self.deleteButton != nil) {
                self.deleteButton.hidden = YES;
            }
            break;
        }
        case CMTextFieldControlStateActive : {//활성화(포커스)
            break;
        }
        case CMTextFieldControlStateDisable : {//비활성화(입력받지 않음)
            self.inputField.enabled = NO;
            break;
        }
        case CMTextFieldControlStateError : {//입력값 에러
            break;
        }
    }
    
    [self.backgroundImageView setImage:[self createBackgrroundImageWithFieldState:fieldState]];
}

- (void)setFieldType:(CMTextFieldType)fieldType {
    _fieldType = fieldType;
    
    switch ((NSInteger)_fieldState) {
        case CMTextFieldTypeDefault : {//기본필드
            break;
        }
        case CMTextFieldTypePassword : {//암호필드
            self.inputField.secureTextEntry = YES;
            break;
        }
        case CMTextFieldTypeButton : {//버튼
            break;
        }
    }//end switch
}

- (void)setFieldKeypad:(CMTextFieldKeypad)fieldKeypad {
    _fieldKeypad = fieldKeypad;
    
    switch ((NSInteger)_fieldKeypad) {
        case CMTextFieldKeypadDefault : {
            self.inputField.keyboardType = UIKeyboardTypeDefault;
            self.inputField.returnKeyType = UIReturnKeyDone;
            break;
        }
        case CMTextFieldKeypadNum : {
            self.inputField.keyboardType = UIKeyboardTypeNumberPad;
            self.inputField.returnKeyType = UIReturnKeyDone;
            break;
        }
    }//end switch
}

#pragma mark - UI
- (void)layoutSubviews {
    [super layoutSubviews];
    self.inputField.frame = self.bounds;
    self.fieldState = _fieldState;
}

#pragma mark - inputField setting
- (void)settingLeftMargin:(CGFloat)margin {
    CGRect frame = CGRectMake(0, 0, margin, self.bounds.size.height);
    self.inputField.leftView.frame = frame;
    [self.inputField setLeftViewMode:UITextFieldViewModeAlways];
}

- (void)settingTextAlignment:(NSTextAlignment)textAlignment {
    
    self.inputField.textAlignment = textAlignment;
    
    if (textAlignment == NSTextAlignmentCenter) {
        self.inputField.leftView.frame = CGRectZero;
        self.inputField.rightView.frame = CGRectZero;
    }
}

- (void)settingInputFieldHolder:(NSString*)holder {
    //    self.inputField.placeholder = holder;
    
    UIFont *font = [UIFont systemFontOfSize:13];
    CGSize inputSize = [holder sizeWithAttributes: @{NSFontAttributeName: self.inputField.font}];
    CGSize holderSize = [holder sizeWithAttributes: @{NSFontAttributeName: font}];
    CGFloat multiple = (inputSize.height/holderSize.height) - 0.15;//수직정렬
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentLeft];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    [style setLineHeightMultiple:multiple];
    
    NSDictionary *attribute = @{
                                NSFontAttributeName:font,
                                NSForegroundColorAttributeName:[CMColor colorPlaceHolderColor],
                                NSParagraphStyleAttributeName:style
                                }; // Added line
    
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithString:holder attributes:attribute];
    self.inputField.attributedPlaceholder = attributeText;
}

#pragma mark - Private

- (void)clearTextField {
    self.inputField.text = @"";//텍스트 필드 초기화
    [self textMessageChanged:self.inputField];//텍스트 필드 변경사항 전파
    if (_fieldState != CMTextFieldControlStateNormal) {
        self.fieldState = CMTextFieldControlStateNormal;//상태값 변경
    }
    else {
        self.deleteButton.hidden = YES;//삭제버튼 숨김
    }
}

- (void)addDoneButton {
    if (self.inputField.keyboardType == UIKeyboardTypeNumberPad) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f) {
            
            NSArray *listViews = [[NSBundle mainBundle] loadNibNamed:@"CMCustomNumberPadView" owner:nil options:nil];
            CMCustomNumberPadView *textFieldView = listViews[0];
            
            self.inputField.inputView = textFieldView;
            
            textFieldView.textField = self.inputField;
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
                        self.doneButton.tag = tag_button_done;
                        self.doneButton.frame = CGRectMake(0, 163, 106, 53);
                        self.doneButton.adjustsImageWhenHighlighted = NO;
                        [self.doneButton setTitle:@"DONE" forState:UIControlStateNormal];
                        [self.doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [self.doneButton addTarget:self action:@selector(buttonWasTouchUpInside:withEvent:) forControlEvents:UIControlEventTouchUpInside];
                        [keyboard addSubview:self.doneButton];
                    } else if([[keyboard description] hasPrefix:@"<UIInputSetContainerView"] == YES){
                        self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        self.doneButton.tag = tag_button_done;
                        self.doneButton.frame = CGRectMake(0,[[ UIScreen mainScreen] bounds ].size.height-53, 106, 53);
                        self.doneButton.adjustsImageWhenHighlighted = NO;
                        [self.doneButton setTitle:@"DONE" forState:UIControlStateNormal];
                        [self.doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [self.doneButton addTarget:self action:@selector(buttonWasTouchUpInside:withEvent:) forControlEvents:UIControlEventTouchUpInside];
                        
                        [keyboard addSubview:self.doneButton];
                    }
                }
                else {
                    if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES) {
                        self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        self.doneButton.tag = tag_button_done;
                        self.doneButton.frame = CGRectMake(0, 163, 106, 53);
                        self.doneButton.adjustsImageWhenHighlighted = NO;
                        [self.doneButton setTitle:@"DONE" forState:UIControlStateNormal];
                        [self.doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [self.doneButton addTarget:self action:@selector(buttonWasTouchUpInside:withEvent:) forControlEvents:UIControlEventTouchUpInside];
                        
                        [keyboard addSubview:self.doneButton];
                    }
                }
            }
        }
    }
}

#pragma mark - EVENT
- (void)buttonWasTouchUpInside:(id)sender withEvent:(UIEvent*)event {
    if (![sender isKindOfClass:[UIView class]]) {
        return;
    }
    
    //switch 문에서 에러가 발생해서 if로 바꿈..
    NSInteger tag = [(UIButton*)sender tag];
    if (tag == tag_button_delete) {
        
        [self clearTextField];
    } else if (tag == tag_button_done) {
        
        [self textFieldShouldReturn:self.inputField];
    }
}

#pragma mark - DELEGATE
#pragma mark - UITextField Event
- (void)textMessageChanged:(UITextField* )textField {
    
    /**
     *  ios8 이하 버전에서 한글 입력시 초성 자음 입력 후 모음을 입력할 때
     *      초성 자음과 모음을 조합하는 과정에서 조합시 ""으로 변경되면서
     *        이벤트가 동작하는 문제가 발생하여 이 경우 대처하기 위한 조건 추가함.
     *
     *          _fieldState == HMInputFieldControlStateActivate 는 해당 이벤트가 동작하기 전
     *              shouldChangeCharactersInRange: 딜리게이트 메소드를 타는데 이때는 입력된 정보가 정확히 있기 때문에
     *              이때 입력값에 따라 _fieldState를 재설정 하는 로직을 기술하였고, 이를 신뢰하여서 해당 정보로 한번더 체크해서 이슈 처리
     */
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version < 8.0){
        if (_fieldState == CMTextFieldControlStateActive && textField.text.length == 0 ) {
            return;
        }
    }
    
    if (self.inputDelegate != nil && [self.inputDelegate respondsToSelector:@selector(textMessageChanged:)]) {
        return [self.inputDelegate textMessageChanged:textField];
    }
}

- (void)resignFirstResponder {
    
    if (_fieldState != CMTextFieldControlStateNormal) {
        self.fieldState = CMTextFieldControlStateNormal;
    }
    
    [self.inputField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    //버튼 유형이면 패스
    if (self.fieldType == CMTextFieldTypeButton) {
        if (self.inputTouchBlock != nil) {
            self.inputTouchBlock();
        }
        return NO;
    }
    
    //버튼 유형이 아니고, 상태가 액티브가 아니면 액티브로 변경
    if (_fieldState != CMTextFieldControlStateActive) {
        self.fieldState = CMTextFieldControlStateActive;
    }
    
    //입력된 값이 있고 딜리트 버튼을 세팅하면 딜리트 버튼 표시
    NSString* input = [textField.text trim];
    if (input.length > 0 && self.deleteButton != nil) {
        self.deleteButton.hidden = NO;
    }
    
    if (self.inputDelegate != nil && [self.inputDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.inputDelegate textFieldShouldBeginEditing:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.inputDelegate != nil && [self.inputDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.inputDelegate textFieldShouldEndEditing:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //버튼 유형이 아니고, 상태가 디폴트가 아니면 디폴트로
    if (_fieldState != CMTextFieldControlStateNormal) {
        self.fieldState = CMTextFieldControlStateNormal;
    }
    
    if (self.inputDelegate != nil && [self.inputDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.inputDelegate textFieldShouldReturn:textField];
    }
    
    return [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *inputText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (inputText.length == 0) {
        self.deleteButton.hidden = YES;
        if (_fieldState != CMTextFieldControlStateNormal) {
            self.fieldState = CMTextFieldControlStateNormal;
        }
    } else {
        self.deleteButton.hidden = NO;
        if (_fieldState != CMTextFieldControlStateActive) {
            self.fieldState = CMTextFieldControlStateActive;
        }
    }
    
    if (self.inputDelegate != nil && [self.inputDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.inputDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    //제한조건 1. 길이체크
    if (self.isCheckMaxInput && range.location >= self.maxInput) {
        return NO;
    }
    
    //제한조건 2. 입력값 유효성 체크
    if (self.limitType != CMTextFieldLimitTypeNone) {
        inputText = [inputText trim];
        switch ((NSInteger)self.limitType) {
            case CMTextFieldLimitTypeNotHangul : {
                if ([NSString isContainKorean:inputText] == YES) {
                    return NO;
                }
                break;
            }
            case CMTextFieldLimitTypeOnlyNum : {
                if ([NSString isDigitOnly:inputText] == NO) {
                    return NO;
                }
                break;
            }
        }//end switch
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self addDoneButton];
    
    if (self.inputDelegate != nil && [self.inputDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        [self.inputDelegate textFieldShouldEndEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [_doneButton removeFromSuperview];
    _doneButton = nil;
    
    if (self.inputDelegate != nil && [self.inputDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.inputDelegate textFieldDidEndEditing:textField];
        return;
    }
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (self.inputDelegate != nil && [self.inputDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [self.inputDelegate textFieldShouldClear:textField];;
    }
    return YES;
}

- (void)keyboardWillShow:(NSNotification*)notification {
    
    /*if ([self isFirstResponder] == false) {
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
     }*/
}

- (void)keyboardWillHide:(NSNotification*)noti {
    
    /*UINavigationController* navigationController = (UINavigationController*)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
     CGRect rootViewFrame = navigationController.view.frame;
     rootViewFrame.origin.y = 0;
     
     [UIView animateWithDuration:.4 animations:^{
     navigationController.view.frame = rootViewFrame;
     }];*/
}

@end
