//
//  CMBaseViewController.h
//  I_NScreen
//
//  Created by 조백근 on 2015. 9. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMNavigationController : UINavigationController
@end

@interface CMBaseViewController : UIViewController

@property (nonatomic, unsafe_unretained) BOOL isUseNavigationBar;

/**
 *  백버튼 이벤트를 기술한다.
 *
 *  @param sender 버튼객체 
 */
- (void)actionBackButton:(id)sender;

/**
 *  인터렉션 팝제스쳐 처리 이벤트
 *
 *  @param recognizer 팝제스쳐 
 */
- (void)actionForGesture:(UISwipeGestureRecognizer *)recognizer;

/**
 *  뷰컨트롤러 팝 이벤트 시 처리할 로직을 기술하는 메소드
 */
- (void)backCommonAction;

/**
 *  커스텀 테이블뷰셀의 xib 로드.
 *
 *  @param tableView      테이블뷰.
 *  @param cellIdentifier 셀식별자.
 *  @param nibName        xib 이름.
 *
 *  @return UITableViewCell.
 */
- (UITableViewCell *)cellWithTableView:(UITableView *)tableView cellIdentifier:(NSString *)cellIdentifier nibName:(NSString *)nibName;

/**
 *  물음표 버튼에 대응해서 가이드 알림창을 호출한다.
 *
 *  @param buttonTag 태그 
 */
+ (void)actionGuide:(NSInteger)buttonTag;

@end
