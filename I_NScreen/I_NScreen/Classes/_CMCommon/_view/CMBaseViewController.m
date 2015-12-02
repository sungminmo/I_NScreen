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
        if (self.viewControllers.count > 2)
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
@property (nonatomic, unsafe_unretained) BOOL isLoadWillAppear;
@property (strong, nonatomic) UIBarButtonItem* favoriteButton;
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
    
    if (self.isLoadWillAppear && [self.navigationController.viewControllers count] > 1) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
        [self.navigationController.interactivePopGestureRecognizer addTarget:self action:@selector(actionForGesture:)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isLoadWillAppear = YES;
    if (self.isUseNavigationBar) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)setupLayout {
    self.navigationController.navigationBar.alpha = 1.0;
    self.navigationController.navigationBar.opaque = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    // 네비게이션바 백버튼.
    self.navigationItem.hidesBackButton = YES;
    
    [self loadCustomBackButton];
}

- (void)loadCustomBackButton {
    float h_padding = (cmNavigationHeight - 44)/2 - 10;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setBackgroundVerticalPositionAdjustment:-h_padding forBarMetrics:UIBarMetricsDefault];
    
    UIImage* image = [UIImage imageNamed:@"back.png"];//9*18
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(actionBackButton:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showFavoriteButton:(BOOL)isShow {
    
    if (isShow) {
        
        if (self.favoriteButton == nil) {
            
            self.favoriteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ch_unpick.png"] style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(favoriteButton:)];
            [self.navigationItem setRightBarButtonItems:@[self.favoriteButton]];
        }
    } else {
        
        [self.navigationItem setRightBarButtonItems:@[]];
        self.favoriteButton = nil;
    }
}

- (void)showFavoriteButton2:(BOOL)isShow {
    
    if (isShow) {
        
        if (self.favoriteButton == nil) {
            
            self.favoriteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ch_pick.png"] style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(favoriteButton:)];
            [self.navigationItem setRightBarButtonItems:@[self.favoriteButton]];
        }
        else
        {
            [self.favoriteButton setImage:[UIImage imageNamed:@"ch_pick.png"]];
        }
    } else {
        
        if ( self.favoriteButton == nil )
        {
            self.favoriteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ch_unpick.png"] style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(favoriteButton:)];
            [self.navigationItem setRightBarButtonItems:@[self.favoriteButton]];
        }
        else
        {
            [self.favoriteButton setImage:[UIImage imageNamed:@"ch_unpick.png"]];
        }

    }
}

- (void)setFavoriteButtonToSelectionState:(BOOL)selected {
    if (self.favoriteButton == nil) {
        return;
    }
    
    NSString* fileName;
    if (selected) {
        fileName = @"ch_pick.png";
    } else {
        fileName = @"ch_unpick.png";
    }
    
    self.favoriteButton.image = [UIImage imageNamed:fileName];
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

- (void)favoriteButton:(id)sender {
}

+ (void)actionGuide:(NSInteger)buttonTag {
    NSString* title = @"";
    NSString* message = @"";
    
    switch (buttonTag) {
        case 100 : {
            title = @"지역설정 이란?";
            message = @"\n지역 별로 채널 가이드에 표시되는 채널 번호가\n동일하지 않는 경우가 있습니다.\n\n보다 원활한 서비스 이용을 위해 꼭\n지역 설정을 해주세요.\n\n\n";
            break;
        }
        case 101 : {
            title = @"구매인증 비밀번호 관리 란?";
            message = @"\n고객 님께서 셋탑박스 연동과 함께 설정하신\n인증번호를 변경하는 서비스 입니다.\n개인정보 보호와 콘텐트 이용관련 보안유지를\n위해 주기 별로 간단한 인증 후\n기존 인증번호를 변경해주세요.\n\n\n";
            break;
        }
        case 102 : {
            title = @"성인검색 제한 설정이란?";
            message = @"\n성인 검색 제한 설정을 해제하시면 콘텐트\n검색 시 검색 결과에 성인 콘텐트가 보여지지 않습니다.\n\n설정해제를 선택하실 경우 성인 콘텐트를\n포함한 모든 콘텐트가 검색 결과에 보여집니다.\n\n\n";
            break;
        }
        case 103 : {
            title = @"성인인증이란?";
            message = @"\n성인 콘텐트를 시청하거나 성인 콘텐트 검색 제한을 해제하기 위해서는 성인인증이 필요합니다.\n\n간단한 절차를 통해 최초 1회 성인인증을 하시면, 이후부터는 성인인증 없이 성인 콘텐트를 보실 수 있습니다.\n\n\n";
        }
    }
    
    [SIAlertView alert:title message:message button:nil];
}

#pragma makr - XIB를 사용하는 테이블뷰 재사용
- (UITableViewCell *)cellWithTableView:(UITableView *)tableView cellIdentifier:(NSString *)cellIdentifier nibName:(NSString *)nibName {
    [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:cellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    return cell;
}

@end
