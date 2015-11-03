//
//  CMDateScrollView.h
//  aaaaaaa
//
//  Created by kimts on 2015. 10. 31..
//  Copyright © 2015년 kimteaksoo. All rights reserved.
//

/**
 *  채널가이드>상세보기 화면 상단에 날짜 표출 스크롤뷰
 */

#import <UIKit/UIKit.h>

/**
 *  CMDateScrollView에서 표출될 날짜 항목을 나타낼 뷰
 */
@interface CMDateItemView : UIView

@property (nonatomic, assign) BOOL selection;

@end

@protocol CMDateScrollViewDelegate;

/**
 *  날짜 표출 스크롤뷰
 */
@interface CMDateScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) id<CMDateScrollViewDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;

/**
 *  날짜정보를 표출한다.
 *
 *  @param dateArray 표출된 날짜 정보 목록
 */
- (void)setDateArray:(NSArray*)dateArray;
@end


@protocol CMDateScrollViewDelegate <NSObject>

@optional
/**
 *  선택된 날짜의 인덱스를 넘겨준다.
 *
 *  @param dateScrollView CMDateScrollView
 *  @param index          선택된 날짜 항목의 인덱스
 */
- (void)dateScrollView:(CMDateScrollView*)dateScrollView selectedIndex:(NSInteger)index;

@end