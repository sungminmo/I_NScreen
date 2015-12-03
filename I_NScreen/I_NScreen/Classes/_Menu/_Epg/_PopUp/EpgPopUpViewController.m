//
//  EpgPopUpViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 14..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "EpgPopUpViewController.h"
#import "NSMutableDictionary+EPG.h"
#import "UIAlertView+AFNetworking.h"

@interface EpgPopUpViewController ()
@property (nonatomic, strong) NSMutableArray *pDataArr;

@end

@implementation EpgPopUpViewController
@synthesize delegate;
@synthesize nGenreCode;

- (id)init{
    self = [super init];
    if(self){
        self.isUseNavigationBar = NO;        
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


- (void)viewWillDisappear:(BOOL)animated  {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTagInit];
    [self setViewInit];
    [self requestWithChannelGenre];
}

#pragma mark - 초기화
#pragma mark - 화면 태그값 초기화
- (void)setTagInit
{
    self.pCloseBtn.tag = EPG_POPUP_VIEW_BTN_01;
    self.pChannelFullBtn.tag = EPG_POPUP_VIEW_BTN_02;
    self.pChannelFavorBtn.tag = EPG_POPUP_VIEW_BTN_03;
    self.pChannelBgBtn.tag = EPG_POPUP_VIEW_BTN_04;
    
    self.pSubBtn01.tag = EPG_POPUP_VIEW_BTN_05;
    self.pSubBtn02.tag = EPG_POPUP_VIEW_BTN_06;
    self.pSubBtn03.tag = EPG_POPUP_VIEW_BTN_07;
    self.pSubBtn04.tag = EPG_POPUP_VIEW_BTN_08;
    self.pSubBtn05.tag = EPG_POPUP_VIEW_BTN_09;
    self.pSubBtn06.tag = EPG_POPUP_VIEW_BTN_10;
    self.pSubBtn07.tag = EPG_POPUP_VIEW_BTN_11;
    self.pSubBtn08.tag = EPG_POPUP_VIEW_BTN_12;
    self.pSubBtn09.tag = EPG_POPUP_VIEW_BTN_13;
}

#pragma mark - 뷰 초기화
- (void)setViewInit
{
    self.pDataArr = [[NSMutableArray alloc]init];
    
    switch (self.nGenreCode) {
        case 0:
        {
            // 전체
            [self.pChannelFullBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.pChannelFullBtn setBackgroundImage:[UIImage imageNamed:@"ch_select.png"] forState:UIControlStateNormal];
        }break;
        case 1:
        {
            // 선호채널
            [self.pChannelFavorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.pChannelFavorBtn setBackgroundImage:[UIImage imageNamed:@"ch_select.png"] forState:UIControlStateNormal];
        }break;
        case 2:
        {
            // 지상파
            [self.pSubBtn01 setBackgroundImage:[UIImage imageNamed:@"genreregion_select.png"] forState:UIControlStateNormal];
        }break;
        case 3:
        {
            // 교육
            [self.pSubBtn02 setBackgroundImage:[UIImage imageNamed:@"genreedu_select.png"] forState:UIControlStateNormal];
        }break;
        case 4:
        {
            // 음악
            [self.pSubBtn03 setBackgroundImage:[UIImage imageNamed:@"genreentertaion_select.png"] forState:UIControlStateNormal];
        }break;
        case 5:
        {
            // 스포츠
            [self.pSubBtn04 setBackgroundImage:[UIImage imageNamed:@"genresports_select.png"] forState:UIControlStateNormal];
        }break;
        case 6:
        {
            // 종교
            [self.pSubBtn05 setBackgroundImage:[UIImage imageNamed:@"genrereligion_select.png"] forState:UIControlStateNormal];
        }break;
        case 7:
        {
            // 뉴스
            [self.pSubBtn06 setBackgroundImage:[UIImage imageNamed:@"genrenews_select.png"] forState:UIControlStateNormal];
        }break;
        case 8:
        {
            // 영화
            [self.pSubBtn07 setBackgroundImage:[UIImage imageNamed:@"genremovie_select.png"] forState:UIControlStateNormal];
        }break;
        case 9:
        {
            // 드라마
            [self.pSubBtn08 setBackgroundImage:[UIImage imageNamed:@"genredrama_select.png"] forState:UIControlStateNormal];
        }break;
        case 10:
        {
            // 홈쇼핑
            [self.pSubBtn09 setBackgroundImage:[UIImage imageNamed:@"genreshopping_select.png"] forState:UIControlStateNormal];
        }break;
            
    }
}

#pragma mark - 액션 이벤트
#pragma mark - 버튼 클릭 이벤트
- (IBAction)onBtnClick:(UIButton *)btn
{
    [self.view removeFromSuperview];
    [self willMoveToParentViewController:nil];
    [self removeFromParentViewController];

    
    switch (btn.tag) {
        case EPG_POPUP_VIEW_BTN_01:
        case EPG_POPUP_VIEW_BTN_04:
        {
            // 닫기
        }break;
        case EPG_POPUP_VIEW_BTN_02:
        {
            // 전체 채널
            self.nGenreCode = 0;
            [self.delegate EpgPopUpViewReloadWithGenre:nil WithTag:self.nGenreCode];
        }break;
        case EPG_POPUP_VIEW_BTN_03:
        {
            // 선호 채널
            self.nGenreCode = 1;
            [self.delegate EpgPopUpViewReloadWithGenre:nil WithTag:self.nGenreCode];
        }break;
        case EPG_POPUP_VIEW_BTN_05:
        {
            // 지상파
            self.nGenreCode = 2;
            [self.delegate EpgPopUpViewReloadWithGenre:[self.pDataArr objectAtIndex:0] WithTag:self.nGenreCode];
        }break;
        case EPG_POPUP_VIEW_BTN_06:
        {
            // 교육
            self.nGenreCode = 3;
            [self.delegate EpgPopUpViewReloadWithGenre:[self.pDataArr objectAtIndex:1] WithTag:self.nGenreCode];
        }break;
        case EPG_POPUP_VIEW_BTN_07:
        {
            // 음악
            self.nGenreCode = 4;
            [self.delegate EpgPopUpViewReloadWithGenre:[self.pDataArr objectAtIndex:2] WithTag:self.nGenreCode];
        }break;
        case EPG_POPUP_VIEW_BTN_08:
        {
            // 스포츠
            self.nGenreCode = 5;
            [self.delegate EpgPopUpViewReloadWithGenre:[self.pDataArr objectAtIndex:3] WithTag:self.nGenreCode];
        }break;
        case EPG_POPUP_VIEW_BTN_09:
        {
            // 종교
            self.nGenreCode = 6;
            [self.delegate EpgPopUpViewReloadWithGenre:[self.pDataArr objectAtIndex:4] WithTag:self.nGenreCode];
        }break;
        case EPG_POPUP_VIEW_BTN_10:
        {
            // 뉴스
            self.nGenreCode = 7;
            [self.delegate EpgPopUpViewReloadWithGenre:[self.pDataArr objectAtIndex:5] WithTag:self.nGenreCode];
        }break;
        case EPG_POPUP_VIEW_BTN_11:
        {
            // 영화
            self.nGenreCode = 8;
            [self.delegate EpgPopUpViewReloadWithGenre:[self.pDataArr objectAtIndex:6] WithTag:self.nGenreCode];
        }break;
        case EPG_POPUP_VIEW_BTN_12:
        {
            // 드라마
            self.nGenreCode = 9;
            [self.delegate EpgPopUpViewReloadWithGenre:[self.pDataArr objectAtIndex:7] WithTag:self.nGenreCode];
        }break;
        case EPG_POPUP_VIEW_BTN_13:
        {
            // 홈쇼핑
            self.nGenreCode = 10;
            [self.delegate EpgPopUpViewReloadWithGenre:[self.pDataArr objectAtIndex:8] WithTag:self.nGenreCode];
        }break;
    }
}

#pragma mark - 전문
#pragma mark - 체널 장르 전문
- (void)requestWithChannelGenre
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary epgGetChannelGenreAreCode:CNM_AREA_CODE Completion:^(NSArray *epgs, NSError *error) {
      
        DDLogError(@"epg = [%@]", epgs);
        
        [self.pDataArr removeAllObjects];
        
        if ( [epgs count] == 0 )
            return;
        
        [self.pDataArr setArray:[[epgs objectAtIndex:0] objectForKey:@"genreItem"]];
        
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 응답후 데이터 셋팅
- (void)setResponseData
{
    
}

@end
