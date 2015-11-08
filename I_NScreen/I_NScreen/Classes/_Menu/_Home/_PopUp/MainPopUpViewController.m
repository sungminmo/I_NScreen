//
//  MainPopUpViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 5..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "MainPopUpViewController.h"
#import "UIAlertView+AFNetworking.h"
#import "NSMutableDictionary+VOD.h"

@interface MainPopUpViewController ()
@property (nonatomic, strong) NSString *pFourDepthListJsonStr;
@end

@implementation MainPopUpViewController
@synthesize pModel;
@synthesize delegate;
@synthesize pDataStr;
@synthesize nViewTag;


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = [UIScreen mainScreen].bounds;
    
    [self setTagInit];
    [self setViewInit];
    
    [self requestWithGetCateforyTree4Depth];
}

#pragma mark - 초기화
#pragma mark - 태그 초기화
- (void)setTagInit
{
    self.pBgBtn.tag = MAIN_POPUP_VIEW_BTN_01;
}

#pragma mark - 화면 초기화
- (void)setViewInit
{
    //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"contents" ofType:@"json"];
    
    self.pFourDepthListJsonStr = @"";
}

#pragma mark - 액션이벤트
#pragma mark - 버튼 액션 이벤트
- (IBAction)onBtnClicked:(UIButton *)btn
{
    switch ([btn tag]) {
        case MAIN_POPUP_VIEW_BTN_01:
        {
            [self.view removeFromSuperview];
            [self willMoveToParentViewController:nil];
            [self removeFromParentViewController];
        }break;
    }
}

#pragma mark - 델리게이트
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pModel.cellCount;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *pCellIn = @"MainPopUpTableViewCellIn";
    
    MainPopUpTableViewCell *pCell = (MainPopUpTableViewCell *)[tableView dequeueReusableCellWithIdentifier:pCellIn];
    
    if (pCell == nil)
    {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MainPopUpTableViewCell" owner:nil options:nil];
        pCell = [arr objectAtIndex:0];
    }
    
    [pCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    NSMutableDictionary *item = [self.pModel itemForRowAtIndexPath:indexPath];
    
    BOOL isOpen = [self.pModel isCellOpenForRowAtIndexPath:indexPath];
    
    [pCell setListData:item WithIndex:(int)indexPath.row WithOpen:isOpen];
    return pCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *item = [self.pModel itemForRowAtIndexPath:indexPath];
    int item_count = [[item valueForKeyPath:@"subData.@count"] intValue];
    if (item_count<=0)
    {
        [self.view removeFromSuperview];
        [self willMoveToParentViewController:nil];
        [self removeFromParentViewController];
        [self.delegate MainPopUpViewWithBtnData:item WithViewTag:nViewTag];
    }
    else
    {
        BOOL newState = NO;
        BOOL isOpen = [self.pModel isCellOpenForRowAtIndexPath:indexPath];
        if (NO == isOpen) {
            newState = YES;
        } else {
            newState = NO;
        }
        [self.pModel setOpenClose:newState forRowAtIndexPath:indexPath];
        
        [tableView beginUpdates];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                 withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
}

#pragma mark - 전문
#pragma mark - 4댑스 카테고리 tree 리스트 전문
- (void)requestWithGetCateforyTree4Depth
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetCategoryTreeWithCategoryId:CNM_OPEN_API_MOVIE_CATEGORY_ID WithDepth:@"4" block:^(NSArray *vod, NSError *error) {
        
        DDLogError(@"4댑스 카테고리 tree 리스트 = [%@]", vod);
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:[[CMAppManager sharedInstance] getResponseTreeSplitWithData:vod WithCategoryIdSearch:CNM_OPEN_API_MOVIE_CATEGORY_ID]
                                                           options:NSJSONWritingPrettyPrinted error:&error];
        self.pFourDepthListJsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"jsonString = [%@]", self.pFourDepthListJsonStr);
        
        self.pModel = [[TreeListModel alloc] initWithJSONFilePath:self.pFourDepthListJsonStr];
        
        [self.pTableView reloadData];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

@end