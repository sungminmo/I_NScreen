//
//  EpgSubViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 14..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "EpgSubViewController.h"
#import "IDScrollableTabBar.h"
#import "BMXSwipableCell+ConfigureCell.h"

@interface EpgSubViewController ()

@end

@implementation EpgSubViewController

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
#pragma mark - 버튼 태그 초기화
- (void)setTagInit
{
    self.pBackBtn.tag = EPG_SUP_VIEW_BTN_01;
}

#pragma mark - 화면 초기화
- (void)setViewInit
{
    IDItem *itemClock = [[IDItem alloc] initWithImage:[UIImage imageNamed:@"clock"] text:@"10.26"];
    IDItem *itemCamera = [[IDItem alloc] initWithImage:[UIImage imageNamed:@"camera"] text:@"10.27"];
    IDItem *itemMail = [[IDItem alloc] initWithImage:[UIImage imageNamed:@"mail"] text:@"10.28"];
    IDItem *itemFave = [[IDItem alloc] initWithImage:[UIImage imageNamed:@"fave"] text:@"10.29"];
    IDItem *itemGames = [[IDItem alloc] initWithImage:[UIImage imageNamed:@"games"] text:@"10.30"];
    IDItem *itemSettings = [[IDItem alloc] initWithImage:[UIImage imageNamed:@"settings"] text:@"10.31"];
    IDItem *itemMusic = [[IDItem alloc] initWithImage:[UIImage imageNamed:@"music"] text:@"11.01"];
    IDItem *itemZip = [[IDItem alloc] initWithImage:[UIImage imageNamed:@"zip"] text:@"11.02"];
    
    IDScrollableTabBar *scrollableTabBarGray = [[IDScrollableTabBar alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 0) itemWidth:74 items:itemClock,itemCamera,itemMail,itemFave,itemGames,itemSettings,itemMusic,itemZip, nil];
    scrollableTabBarGray.delegate = self;
    scrollableTabBarGray.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    //    [scrollableTabBarGray setArchImage:[UIImage imageNamed:@"grayArch"] centerImage:[UIImage imageNamed:@"grayCenter"] backGroundImage:[UIImage imageNamed:@"grayBackground"]];
    
    //    _backImageView.backgroundColor = [UIColor colorWithRed:198.0f/255.0f green:179.0f/255.0f blue:221.0f/255.0f alpha:1.0f];
    //    [scrollableTabBarGray setArchImage:[UIImage imageNamed:@""] centerImage:[UIImage imageNamed:@""] backGroundImage:[UIImage imageNamed:@"blueBackground"]];
    [scrollableTabBarGray setResizeCoeff:0.2f];
    //you can hide divider image and shadow images
    [scrollableTabBarGray setDividerImage:nil];
    [scrollableTabBarGray setShadowImageRight:nil];
    [scrollableTabBarGray setShadowImageLeft:nil];
    [self.pSubChannelView addSubview:scrollableTabBarGray];
}

-(void)scrollTabBarAction : (NSNumber *)selectedNumber sender:(id)sender{
    DDLogError(@"selectedNumber - %@", selectedNumber);
}

- (IBAction)onBtnClick:(UIButton *)btn;
{
    switch ([btn tag]) {
        case EPG_SUP_VIEW_BTN_01:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }break;
        case EPG_SUP_VIEW_BTN_02:
        {
            // 하트 버튼
            
        }break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *pCellIn = @"EpgSubTableViewCellIn";
    
    EpgSubTableViewCell* cell = (EpgSubTableViewCell*)[tableView dequeueReusableCellWithIdentifier:pCellIn];
    
    if (cell == nil)
    {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"EpgSubTableViewCell" owner:nil options:nil];
        cell = [arr objectAtIndex:0];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.delegate = self;
    [cell configureCellForItem:@{@"More":@"TV로 시청", @"Delete":@"녹화중지"} WithItemCount:2];
    
//    [pCell setListData:nil WithIndex:(int)indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 66;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 24;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - 델리게이트
#pragma mark - EpgSubTableViewCellDelegate
- (void)EpgSubTableViewMoreBtn:(int)nIndex
{
    
}

- (void)EpgSubTableViewDeleteBtn:(int)nIndex
{
    
}

@end
