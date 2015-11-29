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

@implementation CMDotLineView

- (void)awakeFromNib {
    [self updateLine];
}

-(void)updateLine{
    
    //TODO: 일단 일정상 대충 하드코딩한다...
    CGFloat lineWidth = self.frame.size.width;
    CGFloat defineWidth = 414;
    if ( [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_6_PLUS] ) {//414
        CGFloat margin = defineWidth - 414;
        lineWidth -= margin;
    }
    else if ( [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_6] ) {//375
        CGFloat margin = defineWidth - 375;
        lineWidth -= margin;
    }
    else {//320
        CGFloat margin = defineWidth - 320;
        lineWidth -= margin;
    }
    
    // Important, otherwise we will be adding multiple sub layers
    if ([[[self layer] sublayers] objectAtIndex:0])
    {
        self.layer.sublayers = nil;
    }
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [shapeLayer setPosition:CGPointMake(self.frame.origin.x *2, 0)];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor colorWithHexString:@"3c3c3c"] CGColor]];
    [shapeLayer setLineWidth:.3];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:@[@2, @1]];
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.frame.origin.x, 0);
    CGPathAddLineToPoint(path, NULL,  self.frame.origin.x + lineWidth, 0);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    [[self layer] addSublayer:shapeLayer];
}

@end

@interface MainPopUpViewController ()
@property (nonatomic, strong) NSString *pFourDepthListJsonStr;
@end

@implementation MainPopUpViewController
@synthesize pModel;
@synthesize delegate;
@synthesize pDataStr;
@synthesize nViewTag;
@synthesize pCategoryId;


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
    NSMutableDictionary *item = [self.pModel itemForRowAtIndexPath:indexPath];
    NSString *sDepth = [NSString stringWithFormat:@"%@", item[@"depth"]];
    if ([@[@"2"] containsObject:sDepth]) {
        return 56;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *item = [self.pModel itemForRowAtIndexPath:indexPath];
    
    //셀 하이라이트 이팩트 대체 꼼수
    NSString *sDepth = [NSString stringWithFormat:@"%@", item[@"depth"]];

    if ([@[@"2", @"3"] containsObject:sDepth] == NO) {
        MainPopUpTableViewCell* cell = (MainPopUpTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            __block BOOL isFinish = NO;

            [UIView animateWithDuration:0.8 animations:^{
                cell.pressEffectView.hidden = NO;
            } completion:^(BOOL finished) {
                cell.pressEffectView.hidden = YES;
                isFinish = YES;
            }];
            while (isFinish == NO) {
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
            }
        }
    }
    
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
        [tableView reloadData];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

#pragma mark - 전문
#pragma mark - 4댑스 카테고리 tree 리스트 전문
- (void)requestWithGetCateforyTree4Depth
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetCategoryTreeWithCategoryId:self.pCategoryId WithDepth:@"4" block:^(NSArray *vod, NSError *error) {
        
        DDLogError(@"4댑스 카테고리 tree 리스트 = [%@]", vod);
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:[[CMAppManager sharedInstance] getResponseTreeSplitWithData:vod WithCategoryIdSearch:self.pCategoryId]
                                                           options:NSJSONWritingPrettyPrinted error:&error];
        self.pFourDepthListJsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"jsonString = [%@]", self.pFourDepthListJsonStr);
        
        self.pModel = [[TreeListModel alloc] initWithJSONFilePath:self.pFourDepthListJsonStr];
        
        [self.pTableView reloadData];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

@end