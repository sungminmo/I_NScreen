//
//  CMTextFieldView.h
//  I_NScreen
//
//  Created by 조백근 on 2015. 10. 12..
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
@property (nonatomic, strong) CMTextField* inputField;
@end
