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

#import "MainPopUpTableViewCell.h"
#import "MainPopUpTableView2thOpenCell.h"
#import "MainPopUpTableView2thCloseCell.h"
#import "MainPopUpTableView3thOpenCell.h"
#import "MainPopUpTableView3thCloseCell.h"


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
    
    UINib* nib = nil;
    nib = [UINib nibWithNibName:@"MainPopUpTableViewCell" bundle:nil];
    [self.pTableView registerNib:nib forCellReuseIdentifier:@"viewCell"];

    nib = [UINib nibWithNibName:@"MainPopUpTableView2thOpenCell" bundle:nil];
    [self.pTableView registerNib:nib forCellReuseIdentifier:@"view2oCell"];
    
    nib = [UINib nibWithNibName:@"MainPopUpTableView2thCloseCell" bundle:nil];
    [self.pTableView registerNib:nib forCellReuseIdentifier:@"view2cCell"];
    
    nib = [UINib nibWithNibName:@"MainPopUpTableView3thOpenCell" bundle:nil];
    [self.pTableView registerNib:nib forCellReuseIdentifier:@"view3oCell"];
    
    nib = [UINib nibWithNibName:@"MainPopUpTableView3thCloseCell" bundle:nil];
    [self.pTableView registerNib:nib forCellReuseIdentifier:@"view3cCell"];
    
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
    
    NSMutableDictionary *item = [self.pModel itemForRowAtIndexPath:indexPath];
    BOOL isOpen = [self.pModel isCellOpenForRowAtIndexPath:indexPath];
    
    
    NSString* identifier = @"";
    
    NSString *sLeaf = [NSString stringWithFormat:@"%@", item[@"leaf"]];
    NSString *sDepth = [NSString stringWithFormat:@"%@", item[@"depth"]];
    
    if ( [sDepth isEqualToString:@"2"] )
    {
        // 2댑스
        if ( [sLeaf isEqualToString:@"0"] )
        {
            // 하위 댑스 있음
            if ( isOpen == NO )
            {
                // 닫힘
                identifier = @"view2cCell";
            }
            else
            {
                // 열림
                identifier = @"view2oCell";
            }
        }
        else
        {
            // 하위 댑스 없음 // 닫힘
            identifier = @"view2cCell";
        }
    }
    else if ( [sDepth isEqualToString:@"3"] )
    {
        // 3댑스
        if ( [sLeaf isEqualToString:@"0"] )
        {
            // 하위 댑스 있음
            if ( isOpen == NO )
            {
                // 닫힘
                identifier = @"view3cCell";
            }
            else
            {
                // 열림
                identifier = @"view3oCell";
            }
        }
        else
        {
            // 하위 댑스 없음
            identifier = @"view3cCell";
        }
    }
    else
    {
        // 4댑스
            identifier = @"viewCell";
    }
    
    UITableViewCell *pCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (pCell == nil)
    {
        NSString* cellName = nil;
        if ([identifier isEqualToString:@"viewCell"]) {
            cellName = @"MainPopUpTableViewCell";
        }
        else if ([identifier isEqualToString:@"view2oCell"]) {
            cellName = @"MainPopUpTableView2thOpenCell";
        }
        else if ([identifier isEqualToString:@"view2cCell"]) {
            cellName = @"MainPopUpTableView2thCloseCell";
        }
        else if ([identifier isEqualToString:@"view3oCell"]) {
            cellName = @"MainPopUpTableView3thOpenCell";
        }
        else if ([identifier isEqualToString:@"view3cCell"]) {
            cellName = @"MainPopUpTableView3thCloseCell";
        }
        
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:cellName owner:nil options:nil];
        pCell = [arr objectAtIndex:0];
    }
    
    [pCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [(MainPopUpTableViewCell* )pCell setListData:item WithIndex:(int)indexPath.row WithOpen:isOpen];
    
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