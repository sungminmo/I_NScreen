//
//  UISegmentedControl+Accessibility.m
//  STVN
//
//  Created by 조백근 on 2015. 1. 9..
//
//

#import "UISegmentedControl+Accessibility.h"

@implementation UISegmentedControl (Accessibility)

- (void)customAccessibilityLabel {
    //UISegmentedControl API의 index와 서브뷰가 서로 반대편에서 각각 시작됨.
    NSEnumerator *subviews = self.subviews.reverseObjectEnumerator;
    NSInteger idx = 0;
    for (UIView *view in subviews) {
        NSString *title = [self titleForSegmentAtIndex:idx];
        [view setAccessibilityLabel:title];
        if (self.enabled) {
            [view setAccessibilityHint:@""];
        } else {
            [view setAccessibilityHint:@"사용할 수 없음."];
        }
        if (idx == [self selectedSegmentIndex]) {
            [view setAccessibilityValue:@", 버튼, 선택됨"];
        } else {
            [view setAccessibilityValue:@", 버튼"];
        }
        [view setAccessibilityTraits:UIAccessibilityTraitNone];
        idx++;
    }
}

@end
