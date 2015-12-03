//
//  SIAlertView.h
//  SIAlertView
//
//  Created by Kevin Cao on 13-4-29.
//  Copyright (c) 2013年 Sumi Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>



/*
 - (IBAction)alert2:(id)sender
 {
 SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Title2" andMessage:@"Message2"];
 [alertView addButtonWithTitle:@"Cancel"
 type:SIAlertViewButtonTypeCancel
 handler:^(SIAlertView *alertView) {
 NSLog(@"Cancel Clicked");
 }];
 [alertView addButtonWithTitle:@"OK"
 type:SIAlertViewButtonTypeDefault
 handler:^(SIAlertView *alertView) {
 NSLog(@"OK Clicked");
 
 [self alert3:nil];
 [self alert3:nil];
 }];
 alertView.titleColor = [UIColor blueColor];
 alertView.cornerRadius = 10;
 alertView.buttonFont = [UIFont boldSystemFontOfSize:15];
 alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
 
 alertView.willShowHandler = ^(SIAlertView *alertView) {
 NSLog(@"%@, willShowHandler2", alertView);
 };
 alertView.didShowHandler = ^(SIAlertView *alertView) {
 NSLog(@"%@, didShowHandler2", alertView);
 };
 alertView.willDismissHandler = ^(SIAlertView *alertView) {
 NSLog(@"%@, willDismissHandler2", alertView);
 };
 alertView.didDismissHandler = ^(SIAlertView *alertView) {
 NSLog(@"%@, didDismissHandler2", alertView);
 };
 
 [alertView show];
 }
 
 */


extern NSString *const SIAlertViewWillShowNotification;
extern NSString *const SIAlertViewDidShowNotification;
extern NSString *const SIAlertViewWillDismissNotification;
extern NSString *const SIAlertViewDidDismissNotification;

extern NSString *const SIAlertViewFieldChangeSign;

typedef NS_ENUM(NSInteger, SIAlertViewButtonType) {
    SIAlertViewButtonTypeDefault = 0,
    SIAlertViewButtonTypeDestructive,
    SIAlertViewButtonTypeCancel
};

typedef NS_ENUM(NSInteger, SIAlertViewBackgroundStyle) {
    SIAlertViewBackgroundStyleGradient = 0,
    SIAlertViewBackgroundStyleSolid,
};

typedef NS_ENUM(NSInteger, SIAlertViewButtonsListStyle) {
    SIAlertViewButtonsListStyleNormal = 0,
    SIAlertViewButtonsListStyleRows
};

typedef NS_ENUM(NSInteger, SIAlertViewTransitionStyle) {
    SIAlertViewTransitionStyleSlideFromBottom = 0,
    SIAlertViewTransitionStyleSlideFromTop,
    SIAlertViewTransitionStyleFade,
    SIAlertViewTransitionStyleBounce,
    SIAlertViewTransitionStyleDropDown
};

typedef NS_ENUM(NSInteger, SIAlertViewTextFieldPosition) {
    SIAlertViewTextFieldPositionNone = 0,
    SIAlertViewTextFieldPositionTop,
    SIAlertViewTextFieldPositionMiddle,
    SIAlertViewTextFieldPositionBottom
};

@class CMTextFieldView;
@class CMTextField;
@class SIAlertView;
typedef void(^SIAlertViewHandler)(SIAlertView *alertView);
typedef void(^SIAlertViewConfirmHandler)(NSInteger buttonIndex, SIAlertView* alert);
typedef void(^SIAlertViewTextFieldHandler)(NSInteger buttonIndex, SIAlertView* alert);
@interface SIAlertView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSAttributedString *attributeMessage;

@property (nonatomic, strong) CMTextFieldView* fieldView;

@property (nonatomic, assign) SIAlertViewTransitionStyle transitionStyle; // default is SIAlertViewTransitionStyleSlideFromBottom
@property (nonatomic, assign) SIAlertViewBackgroundStyle backgroundStyle; // default is SIAlertViewBackgroundStyleGradient
@property (nonatomic, assign) SIAlertViewButtonsListStyle buttonsListStyle; // default is SIAlertViewButtonsListStyleNormal
@property (nonatomic, assign) SIAlertViewTextFieldPosition textFieldPosition; // default is SIAlertViewTextFieldPositionNone

@property (nonatomic, copy) SIAlertViewHandler willShowHandler;
@property (nonatomic, copy) SIAlertViewHandler didShowHandler;
@property (nonatomic, copy) SIAlertViewHandler willDismissHandler;
@property (nonatomic, copy) SIAlertViewHandler didDismissHandler;

@property (nonatomic, readonly, getter = isVisible) BOOL visible;

@property (nonatomic, readonly, getter = isParallaxEffectEnabled) BOOL enabledParallaxEffect;

@property (nonatomic, strong) UIColor *viewBackgroundColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *titleColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *messageColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *titleFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *messageFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *buttonFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *buttonColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *cancelButtonColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *destructiveButtonColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat cornerRadius NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default is 2.0
@property (nonatomic, assign) CGFloat shadowRadius NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default is 8.0

- (void)setDefaultButtonImage:(UIImage *)defaultButtonImage forState:(UIControlState)state NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
- (void)setCancelButtonImage:(UIImage *)cancelButtonImage forState:(UIControlState)state NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
- (void)setDestructiveButtonImage:(UIImage *)destructiveButtonImage forState:(UIControlState)state NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;

- (id)initWithTitle:(NSString *)title andMessage:(NSString *)message;
- (id)initWithTitle:(NSString *)title andAttributeMessage:(NSAttributedString *)message;

- (void)addButtonWithTitle:(NSString *)title type:(SIAlertViewButtonType)type handler:(SIAlertViewHandler)handler;

- (void)show;
- (void)dismissAnimated:(BOOL)animated;

@end

@interface SIAlertView(Simple)

/*
 [사용법입니다.]
 
 [SIAlertView alert:@"모바일 알림" message:@"상세설정화면입니다."];
 [SIAlertView alert:@"모바일 알림" message:@"상세설정화면입니다." button:@"취소"];
 [SIAlertView alert:@"모바일 알림" message:@"상세설정화면입니다." button:@"ok" completion:^(NSInteger buttonIndex, SIAlertView *alert) {
 }];
 [SIAlertView alert:@"모바일 알림" message:@"상세설정화면입니다." cancel:@"취소" buttons:@[@"확인"] completion:^(NSInteger buttonIndex, SIAlertView *alert) {
 DDLogDebug(@"alert index : %ld", buttonIndex);
 }];
 
 [SIAlertView alert:@"모바일 알림" message:@"상세설정화면입니다.\n굵은글씨입니다." containBoldText:@"굵은글씨입니다."];
 [SIAlertView alert:@"모바일 알림" message:@"굵은글씨입니다.\n상세설정화면입니다." containBoldText:@"굵은글씨입니다." button:@"취소"];
 [SIAlertView alert:@"모바일 알림" message:@"굵은글씨입니다.\n상세설정화면입니다." containBoldText:@"굵은글씨입니다." button:@"ok" completion:^(NSInteger buttonIndex, SIAlertView *alert) {
 }];
 [SIAlertView alert:@"모바일 알림" message:@"상세설정화면입니다.\n굵은글씨입니다." containBoldText:@"굵은글씨입니다." cancel:@"취소" buttons:@[@"확인"] completion:^(NSInteger buttonIndex, SIAlertView *alert) {
 DDLogDebug(@"alert index : %ld", buttonIndex);
 }];
 */

+ (void)alert:(NSString*)title message:(NSString*)message;
+ (void)alert:(NSString*)title message:(NSString*)message button:(NSString*)text;
+ (void)alert:(NSString*)title message:(NSString*)message completion:(SIAlertViewConfirmHandler)completion;
+ (void)alert:(NSString*)title message:(NSString*)message button:(NSString*)text completion:(SIAlertViewConfirmHandler)completion;
+ (void)alert:(NSString*)title message:(NSString*)message cancel:(NSString*)cancel buttons:(NSArray*)buttons completion:(SIAlertViewConfirmHandler)completion;
+ (void)alert:(NSString*)title message:(NSString*)message containBoldText:(NSString*)boldText;
+ (void)alert:(NSString*)title message:(NSString*)message containBoldText:(NSString*)boldText button:(NSString*)text;
+ (void)alert:(NSString*)title message:(NSString*)message containBoldText:(NSString*)boldText completion:(SIAlertViewConfirmHandler)completion;
+ (void)alert:(NSString*)title message:(NSString*)message containBoldText:(NSString*)boldText button:(NSString*)text completion:(SIAlertViewConfirmHandler)completion;
+ (void)alert:(NSString*)title message:(NSString*)message containBoldText:(NSString*)boldText cancel:(NSString*)cancel buttons:(NSArray*)buttons completion:(SIAlertViewConfirmHandler)completion;

/**
 *  텍스트필드 알림창
 *
 *  @param title      타이틀
 *  @param message    메세지
 *  @param boldText   굵은글씨
 *  @param holder     텍스트필드 플레이스 홀더
 *  @param value      텍스트필드 세팅값
 *  @param position   텍스트필드 위치
 *  @param maxLength  텍스트필드 유효성값
 *  @param cancel     취소버튼 타이틀
 *  @param buttons    버튼 타이틀 목록
 *  @param completion 완료 후 처리 핸들러
 *
 *              position 이 SIAlertViewTextFieldPositionMiddle 인 경우 message에 텍스트 필드 높이 확보를 위한
 *                  대체텍스트(SIAlertViewFieldChangeSign - "##FIELD##")가 반드시 포함되어야 한다.
 *
 *              그리고 해당 텍스트 필드 알림창은 최대 메세지를 5라인 이상 입력할 수 없음. 
 *
 */
+ (void)alert:(NSString*)title message:(NSString*)message containBoldText:(NSString*)boldText textHoloder:(NSString*)holder textValue:(NSString*)value textPosition:(SIAlertViewTextFieldPosition)position textLength:(NSInteger)maxLength cancel:(NSString*)cancel buttons:(NSArray*)buttons completion:(SIAlertViewConfirmHandler)completion;

@end

@interface SIAlertView(AFNetworking)
+ (void)showAlertViewForTaskWithErrorOnCompletion:(NSURLSessionTask *)task delegate:(id)delegate;
@end

