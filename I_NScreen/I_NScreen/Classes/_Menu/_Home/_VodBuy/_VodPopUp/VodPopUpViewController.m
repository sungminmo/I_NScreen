//
//  VodPopUpViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "VodPopUpViewController.h"
#import "UIAlertView+AFNetworking.h"
#import "NSMutableDictionary+Payment.h"
#import "CMDBDataManager.h"

@interface VodPopUpViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *lineView;

@end

@implementation VodPopUpViewController
@synthesize pBuyStr;
@synthesize pBuyDic;
@synthesize delegate;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self setViewInit];
    [self setViewTagInit];

    self.lineView.image = [UIImage imageWithColor:[UIColor lightGrayColor] withAlpha:1 withSize:self.lineView.bounds.size];
}

#pragma mark - 초기화
#pragma mark - 뷰 테그 초기화
- (void)setViewTagInit
{
    self.pBgBtn.tag = VOD_POP_UP_VIEW_BTN_01;
    self.pCancelBtn.tag = VOD_POP_UP_VIEW_BTN_02;
    self.pOkBtn.tag = VOD_POP_UP_VIEW_BTN_03;
}

#pragma mark - 화면 초기화
- (void)setViewInit
{
    self.pTextField.type = Secure_CMTextFieldType;
}

#pragma mark - 액션 이벤트
#pragma mark - 버튼 액션 이벤트
- (IBAction)onBtnClicked:(UIButton *)btn
{
    [self.pTextField resignFirstResponder];
    
    switch ([btn tag]) {
        case VOD_POP_UP_VIEW_BTN_01:
        case VOD_POP_UP_VIEW_BTN_02:
        {
            [self dismissViewControllerAnimated:NO completion:nil];
        }break;
        case VOD_POP_UP_VIEW_BTN_03:
        {
//            CMDBDataManager *manager = [CMDBDataManager sharedInstance];
            
//            if ( ![self.pTextField.text isEqualToString:[manager purchaseAuthorizedNumber]] )
            if ( ![self.pTextField.text isEqualToString:[[CMAppManager sharedInstance] getKeychainBuyPw]] )
            {
                [SIAlertView alert:@"알림" message:@"구매 비밀번호가 잘못되었습니다." button:nil];
            }
            else
            {
                
//                [self requestWithPurchaseAssetEx2];
            }
        }break;
         
    }
}

#pragma mark - 결제 전문
#pragma mark - 일반 결제
- (void)requestWithPurchaseAssetEx2
{
    
}


#pragma mark - 쿠폰 결제
- (void)requestWithPurchaseByCoupon
{
    
}

#pragma mark - TV 포인트 결제
- (void)requestWithPurchaseByPoint
{
    
}

#pragma mark - 복합 결제
- (void)requestWithPurchaseByComplexMethods
{
    
}

//#pragma mark - 일반 결제
//- (void)requestWithPurchaseAssetEx2
//{
//    NSLog(@"일반 결제");
//    
//    NSObject *itemObj = [[[[self pBuyDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"];
//    
//    if ( [itemObj isKindOfClass:[NSDictionary class]] )
//    {
//        NSString *sProductId = [NSString stringWithFormat:@"%@", [[[[[self pBuyDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"] objectForKey:@"productId"]];
//        NSString *sGoodi = [NSString stringWithFormat:@"%@", [[[[[self pBuyDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"] objectForKey:@"goodId"]];
//        NSString *sPrice = [NSString stringWithFormat:@"%@", [[[[[self pBuyDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"] objectForKey:@"price"]];
//        
//        NSURLSessionDataTask *tesk = [NSMutableDictionary paymentPurchaseAssetEx2WithProductId:sProductId WithGoodId:sGoodi WithUiComponentDomain:sPrice WithUiComponentId:@"0" WithPrice:@"0" completion:^(NSArray *preference, NSError *error) {
//            
//            DDLogError(@"preference = [%@]", preference);
//            
//            [SIAlertView alert:@"구매완료" message:@"가입이 완료 되었습니다.\n[VOD 구매목록]메뉴에서 구매내역을\n확인하실 수 있습니다."
//                        cancel:nil
//                       buttons:@[@"확인"]
//                    completion:^(NSInteger buttonIndex, SIAlertView *alert) {
//                        
//                        [self dismissViewControllerAnimated:NO completion:^{
//                            
//                            [self.delegate VodPopUpViewWithTag:0];
//                            
//                        }];
//                        
//                    }];
//
//        }];
//        
//        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
//        
//    }
//    else if ( [itemObj isKindOfClass:[NSArray class]] )
//    {
//        NSString *sProductId = [NSString stringWithFormat:@"%@", [[[[[[self pBuyDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"] objectAtIndex:0] objectForKey:@"productId"]];
//        NSString *sGoodi = [NSString stringWithFormat:@"%@", [[[[[[self pBuyDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"] objectAtIndex:0] objectForKey:@"goodId"]];
//        NSString *sPrice = [NSString stringWithFormat:@"%@", [[[[[[self pBuyDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"] objectAtIndex:0] objectForKey:@"price"]];
//        
//        NSURLSessionDataTask *tesk = [NSMutableDictionary paymentPurchaseAssetEx2WithProductId:sProductId WithGoodId:sGoodi WithUiComponentDomain:@"0" WithUiComponentId:@"0" WithPrice:sPrice completion:^(NSArray *preference, NSError *error) {
//            
//            DDLogError(@"preference = [%@]", preference);
//        }];
//        
//        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
//        
//    }
//    
//    
//}
@end
