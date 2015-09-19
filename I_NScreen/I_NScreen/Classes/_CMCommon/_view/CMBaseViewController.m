//
//  CMBaseViewController.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 9. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMBaseViewController.h"
#import "UINavigationBar+CustomHeight.h"



@implementation CMNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.enabled = YES;
        self.interactivePopGestureRecognizer.delegate = nil;
        [self.interactivePopGestureRecognizer addTarget:self action:@selector(actionForGesture:)];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)] &&
        gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (void)actionForGesture:(UISwipeGestureRecognizer *)recognizer {
    if (self.topViewController != nil)//skip modal
    {
        return;
    }
    
    if (recognizer.view != nil && recognizer.state == UIGestureRecognizerStateEnded )
    {
        if (self.viewControllers.count > 1)
        {
            UIViewController *controller = self.viewControllers[self.viewControllers.count - 1];
            if ([controller isKindOfClass:NSClassFromString(@"CMBaseViewController")])
            {
                if ([controller respondsToSelector:@selector(actionForGesture:)])
                {
                    [(CMBaseViewController *)controller actionForGesture:(UISwipeGestureRecognizer*)recognizer];
                }
            }
        }
    }
}

@end


@interface CMBaseViewController ()

@end

@implementation CMBaseViewController

- (id)init{
    self = [super init];
    if(self){
    }
    return self;
}

- (void)viewDidLoad {
    [self setupLayout];
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self.navigationController.interactivePopGestureRecognizer addTarget:self action:@selector(actionForGesture:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isUseNavigationBar) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)setupLayout {
    // 네비게이션바 타이틀 커스텀폰트, 컬러 설정.
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *dict = @{
                           NSFontAttributeName:[UIFont systemFontOfSize:26],
                           NSForegroundColorAttributeName:[UIColor whiteColor],
                           NSParagraphStyleAttributeName:style,
                           NSShadowAttributeName : shadow
                           };
    [[UINavigationBar appearance] setTitleTextAttributes:dict];
    
    // 네비게이션바 백버튼.
    self.navigationItem.hidesBackButton = YES;
    
    [self loadCustomBackButton];
}

- (void)loadCustomBackButton {
    float h_padding = (93 - 44)/2;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setBackgroundVerticalPositionAdjustment:-h_padding forBarMetrics:UIBarMetricsDefault];
    
    UIImage* image = [UIImage imageNamed:@"back.png"];//9*18
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(actionBackButton:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - event
- (void)actionBackButton:(id)sender {
    [self backCommonAction];
}

- (void)actionForGesture:(UISwipeGestureRecognizer *)recognizer {
    [self backCommonAction];
}

- (void)backCommonAction {
    //TODO: 팝이벤트가 발생하기 전에 처리할 로직을 기술한다.
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
