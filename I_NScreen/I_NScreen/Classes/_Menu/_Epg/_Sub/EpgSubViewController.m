//
//  EpgSubViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 14..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "EpgSubViewController.h"
#import "BMXSwipableCell+ConfigureCell.h"
#import "UIImageView+AFNetworking.h"

@interface EpgSubViewController ()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;   //  네비게이션바 간격

@property (nonatomic, strong) IBOutlet UIView* pSubChannelView;     //  채널 로고 + 날짜 스크롤뷰
@property (nonatomic, strong) IBOutlet UIImageView* logoImageView;  //  채널 로고
@property (nonatomic, strong) CMDateScrollView* dateScrollView;     //  날짜 스크롤뷰
@property (nonatomic, strong) IBOutlet UITableView* pTableView;     //  방송 목록 테이블

@property (nonatomic, strong) NSMutableArray* dataArray;    //  방송 정보

@end

@implementation EpgSubViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topConstraint.constant = cmNavigationHeight;
    
    self.isUseNavigationBar = YES;
    
    [self showFavoriteButton:true];
    
    self.dataArray = [@[] mutableCopy];

    [self setViewInit];
    
    [self setTestData];
    
}

#pragma mark - 화면 초기화

- (void)setViewInit
{
    CGFloat posX = self.logoImageView.bounds.size.width;
    self.dateScrollView = [[CMDateScrollView alloc] initWithFrame:CGRectMake(posX, 0, [UIScreen mainScreen].bounds.size.width - posX, self.pSubChannelView.bounds.size.height)];
    
    [self.pSubChannelView addSubview:self.dateScrollView];
}

- (IBAction)onBtnClick:(UIButton *)btn;
{
    switch ([btn tag]) {
        case EPG_SUP_VIEW_BTN_02:
        {
            // 하트 버튼
            
        }break;
    }
}

#pragma mark - Privates

/**
 *  테스트용 데이터 셋팅, 추후 삭제.
 */
#warning TEST
- (void)setTestData {
    
    self.title = @"CH.05 KBS";
    
    [self.logoImageView setImageWithURL:[NSURL URLWithString:@"http://58.141.255.69:8080/logo/193.png"]];
    
    NSMutableArray* dateArray = [@[] mutableCopy];
    
    for (int i = 0; i < 20; i++) {
        [dateArray addObject:[NSString stringWithFormat:@"12월%02d일", i]];
    }
    
    [self.dateScrollView setDateArray:dateArray];
    
    for (int i = 0; i < 30; i++) {
        
        NSString* grade;
        if (i%3 == 1)       grade = @"19";
        else if (i%3 == 2)  grade = @"15";
        else                grade = @"모두";

        [self.dataArray addObject:@{@"title":@"뉴스파이터", @"time":@"15:00~16:00", @"grade":grade, @"hd":@"Y", @"progress":@(1)}];
    }
    
    [self.pTableView reloadData];
}

#pragma mark - Event

/**
 *  Override
 *  네비게이션바 즐겨찾기 버튼 이벤트 함수
 */
- (void)favoriteButton:(id)sender {
    
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *pCellIn = @"EpgSubTableViewCell";
    
    EpgSubTableViewCell* cell = (EpgSubTableViewCell*)[tableView dequeueReusableCellWithIdentifier:pCellIn];
    
    if (cell == nil)
    {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"EpgSubTableViewCell" owner:nil options:nil];
        cell = [arr objectAtIndex:0];
    }
    
    cell.delegate = self;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary* data = self.dataArray[indexPath.row];
    [cell setData:data];

    [cell configureCellForItem:@{@"More":@"TV로 시청", @"Delete":@"녹화중지"} WithItemCount:2];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 66;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - 델리게이트
#pragma mark - EpgSubTableViewCellDelegate
- (void)EpgSubTableViewMoreBtn:(int)nIndex
{
    
}

- (void)EpgSubTableViewDeleteBtn:(int)nIndex
{
    
}

#pragma mark - CMDateScrollViewDelegate

- (void)dateScrollView:(CMDateScrollView *)dateScrollView selectedIndex:(NSInteger)index {
    NSLog(@"dateScrollView : %ld", (long)index);
}

@end
