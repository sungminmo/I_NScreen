//
//  CMTextFieldView.h
//  I_NScreen
//
//  Created by kimts on 2015. 10. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CMTextFieldControlState) {//텍스트 필드 상태
    CMTextFieldControlStateNormal = 0,//정상
    CMTextFieldControlStateActive,//활성화(포커스)
    CMTextFieldControlStateDisable, //비활성화(입력받지 않음)
    CMTextFieldControlStateError //입력값 에러
};

typedef NS_ENUM(NSInteger, CMTextFieldType) {//텍스트 필드 유형
    CMTextFieldTypeDefault = 0,//기본필드
    CMTextFieldTypePassword, //암호필드
    CMTextFieldTypeButton//버튼
};

typedef NS_ENUM(NSInteger, CMTextFieldKeypad) {//텍스트 필드 유형
    CMTextFieldKeypadDefault = 0, //기본
    CMTextFieldKeypadNum//숫자
};

typedef NS_ENUM(NSInteger, CMTextFieldLimitType) {//키패드 입력값 제한
    CMTextFieldLimitTypeNone = 0,//제한없음
    CMTextFieldLimitTypeOnlyNum,//숫자만
    CMTextFieldLimitTypeNotHangul//한글입력금지
};

static CGFloat fTextFieldPadding = 11.f;

@class CMTextField;

@interface CMTextFieldView : UIView

@property (nonatomic, strong) UITextField* inputField;
@property (nonatomic, strong) NSString* placeHolder;
@property (nonatomic, assign) id inputDelegate;
@property (nonatomic, strong) UIButton* deleteButton;

@property (nonatomic, copy) void (^inputTouchBlock)(void);//(void (^)(void))block

@property (nonatomic, unsafe_unretained) CMTextFieldControlState fieldState;//default : HMInputFieldControlStateNormal
@property (nonatomic, unsafe_unretained) CMTextFieldType fieldType;//default : HMInputFieldTypeDefault
@property (nonatomic, unsafe_unretained) CMTextFieldKeypad fieldKeypad;//default : HMInputFieldKeypadDefault
@property (nonatomic, unsafe_unretained) CMTextFieldLimitType limitType;//default : HMInputFieldLimitTypeNone

/**
 *  텍스트 필드 좌측 텍스트 시작 위치 세팅
 *
 *  @param margin 마진
 */
- (void)settingLeftMargin:(CGFloat)margin;

/**
 *  플레이스홀더를 세팅한다.
 *
 *  @param holder 텍스트
 */
- (void)settingInputFieldHolder:(NSString*)holder;

/**
 *  텍스트 필드 초기화
 */
- (void)clearTextField;

/**
 *  이벤트 처리를 위한 함수 (당 클래스를 사용하는 부모클래스에서 해당 메소드를 기술하면 된다.)
 *
 *  @param textField 텍스트필드
 */
- (void)textMessageChanged:(UITextField* )textField;

/**
 *  이벤트 처리를 위한 함수 (당 클래스를 사용하는 부모클래스에서 해당 메소드를 기술하면 된다. delegate메소드와 동일)
 *
 *  @param textField 텍스트필드
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

/**
 *  텍스트필드 포커스 해제
 */
- (void)resignFirstResponder;

#pragma mark - input value check
@property (nonatomic, unsafe_unretained) BOOL isCheckMaxInput;//맥스랭스 체크할 지 여부, maxInput을 세팅하면 자동으로 YES로 변경
@property (nonatomic, unsafe_unretained) NSInteger maxInput;//기본값 0 (0이면 isCheckMaxInput 값이 NO)

@end
