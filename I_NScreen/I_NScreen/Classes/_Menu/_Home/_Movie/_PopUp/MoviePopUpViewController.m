//
//  MoviePopUpViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "MoviePopUpViewController.h"

@interface MoviePopUpViewController ()

@end

@implementation MoviePopUpViewController
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
    // Do any additional setup after loading the view from its nib.
    
    [self setTagInit];
    [self setViewInit];
}

#pragma mark - 초기화
#pragma mark - 태그 초기화
- (void)setTagInit
{
    self.pBgBtn.tag = MOVICE_POPUP_VIEW_BTN_01;
}

#pragma mark - 화면 초기화
- (void)setViewInit
{
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"contents" ofType:@"json"];
    
    self.pModel = [[TreeListModel alloc] initWithJSONFilePath:self.pDataStr];
    
    [self.pTableView reloadData];
}

#pragma mark - 액션이벤트
#pragma mark - 버튼 액션 이벤트
- (IBAction)onBtnClicked:(UIButton *)btn
{
    switch ([btn tag]) {
        case MOVICE_POPUP_VIEW_BTN_01:
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
    
    static NSString *pCellIn = @"MoviePopUpTableViewCellIn";
    
    MoviePopUpTableViewCell *pCell = (MoviePopUpTableViewCell *)[tableView dequeueReusableCellWithIdentifier:pCellIn];
    
    if (pCell == nil)
    {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MoviePopUpTableViewCell" owner:nil options:nil];
        pCell = [arr objectAtIndex:0];
    }
    
    [pCell setSelectionStyle:UITableViewCellSelectionStyleNone];

    
    NSMutableDictionary *item = [self.pModel itemForRowAtIndexPath:indexPath];
    
    BOOL isOpen = [self.pModel isCellOpenForRowAtIndexPath:indexPath];

    [pCell setListData:item WithIndex:(int)indexPath.row WithOpen:isOpen];
    return pCell;
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
        [self.delegate MoviePopUpViewWithBtnData:item WithViewTag:nViewTag];
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

@end
