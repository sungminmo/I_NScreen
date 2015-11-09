//
//  CMSearchMainViewController.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 9. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMSearchMainViewController.h"
#import "CMSearchCollectionViewCell.h"
#import "CMSearchTableViewCell.h"
#import "CMAutoCompletTableViewCell.h"
#import "CMConstants.h"
#import "BMXSwipableCell+ConfigureCell.h"
#import "NSMutableDictionary+SEARCH.h"
#import "CMDBDataManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "UIAlertView+AFNetworking.h"

typedef enum : NSInteger {
    VOD_TABMENU_TYPE,
    PROGRAM_TABMENU_TYPE
} TABMENU_TYPE;

static NSString* const AutoCompletCell = @"autoCompletCell";
static NSString* const VodCellIdentifier = @"vodCell";
static NSString* const ProgramCellIdentifier = @"programCell";

static NSString* const SearchWordList = @"searchWordList";
static NSString* const SearchWord = @"searchWord";

static NSString* const VodSearch_Item = @"VodSearch_Item";
static NSString* const ScheduleItem = @"scheduleItem";

static const CGFloat pageSize = 28;

@interface CMSearchMainViewController ()

@property (nonatomic, strong) IBOutlet CMTextField* searchField;    //  검색어 텍스트 필드
@property (nonatomic, strong) IBOutlet UILabel* infoLabel;          //  검색갤과 정보 표출 라벨
@property (nonatomic, strong) IBOutlet UITableView* autoCompletList;//  검색어 테이블

@property (nonatomic, strong) CMTabMenuView* tabMenu;               //  vod, 프로그램 탭메뉴
@property (nonatomic, strong) IBOutlet UIView* tabMenuContainer;    //  vod, 프로그램 탭메뉴

@property (nonatomic, strong) IBOutlet UICollectionView* vodList;   //  vod 목록 테이블
@property (nonatomic, strong) IBOutlet UITableView* programList;    //  프로그램 목록 테이블
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *topConstraint;

@property (nonatomic, strong) NSMutableArray* searchWordArray;  //  검색어 목록
@property (nonatomic, strong) NSMutableArray* dataArray;        //  vod/프로그램 목록

@property (nonatomic, assign) NSInteger pageIndex;  //  검색 목록 페이지 인덱스
@property (nonatomic, assign) NSInteger totalPage;  //  검색 목록 전체 페이지 수

@property (nonatomic, assign) BOOL isLoading;   //  request 진행 여부

@property (nonatomic, strong) NSTimer* searchWordTimer; //  검색어 요청 타이머

@end

@implementation CMSearchMainViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"검색";
    self.isUseNavigationBar = YES;
    self.topConstraint.constant = cmNavigationHeight;
    
    self.pageIndex = 0;
    self.totalPage = 0;
    self.searchWordArray = [@[] mutableCopy];
    self.dataArray = [@[] mutableCopy];
    
    [self setListCount:self.dataArray.count];

    UINib* nib;
    
    nib = [UINib nibWithNibName:@"CMAutoCompletTableViewCell" bundle:nil];
    [self.autoCompletList registerNib:nib forCellReuseIdentifier:AutoCompletCell];
    
    nib = [UINib nibWithNibName:@"CMSearchCollectionViewCell" bundle:nil];
    [self.vodList registerNib:nib forCellWithReuseIdentifier:VodCellIdentifier];
    
    nib = [UINib nibWithNibName:@"CMSearchTableViewCell" bundle:nil];
    [self.programList registerNib:nib forCellReuseIdentifier:ProgramCellIdentifier];
    
    [self loadUI];
}

// 키워드 검색 전문
- (void)requstWithSearchWorldTest
{
    // http://58.141.255.79:8080/HApplicationServer/getSearchWord.json?version=1&terminalKey=8A5D2E45D3874824FF23EC97F78D358&includeAdultCategory=0&searchKeyword=%EB%A7%89
    
    
    // includeAdultCategory 1, 0 성인 컨텐츠 포함 여부
    /*!<
     {
     "transactionId":"",
     "totalCount":35,
     "searchWordList":[
     "막걸스",
     "막달라마리아",
     "막달레나 크론슈라거",
     "막돼먹은영애씨1",
     "막돼먹은영애씨2",
     "막돼먹은영애씨3",
     "막돼먹은 영애씨7",
     "막돼먹은 영애씨8",
     "막돼먹은영애씨 시즌10",
     "막돼먹은영애씨 시즌11",
     "막돼먹은영애씨 시즌12",
     "막돼먹은 영애씨 시즌13",
     "막돼먹은 영애씨 시즌14",
     "막무가내쇼시즌2",
     "막문위",
     "막미림",
     "막부말Rock",
     "막부말 의인전 로망",
     "막소기",
     "막소총",
     "막스 리멜트",
     "막스 리에멜트",
     "막스 마누스",
     "막스본시도우",
     "막스 본 시도우",
     "막스 본 토운",
     "막스 쇼워터",
     "막스 오퓔스",
     "막스 폰 시도우",
     "막시밀리안 브뤼크너",
     "막시밀리안 시모니슈에크",
     "막시밀리언 엘렌바인",
     "막심 고바레",
     "막심 스베쉬니코브",
     "막이래쇼 무작정여행단"
     ],
     "resultCode":100,
     "totalPage":0,
     "errorString":"",
     "version":"1"
     }
     */
    
    
   NSURLSessionDataTask *tesk = [NSMutableDictionary searchWordListWithSearchString:@"막" WithIncludeAdultCategory:@"0" completion:^(NSArray *programs, NSError *error) {
      
       DDLogError(@"%@", programs);
   }];
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)loadUI {
    
    [self.searchField addTarget:self action:@selector(textMessageChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.tabMenu = [[CMTabMenuView alloc] initWithMenuArray:@[@"VOD 명 검색", @"TV 프로그램 명 검색"] posY:0 delegate:self];
    [self.tabMenuContainer addSubview:self.tabMenu];
    
    UIView* tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.programList.frame.size.width, 1)];
    tableHeaderView.backgroundColor = [CMColor colorTableSeparator];
    self.programList.tableHeaderView = tableHeaderView;
    
    self.vodList.hidden = false;
    self.programList.hidden = true;
}

/**
 *  검색어필드 하단에 검색 정보를 표출한다.
 *
 *  @param count 검색결과 카운트
 */
- (void)setListCount:(NSInteger)count {
    
    if (0 > count) {
        
        self.infoLabel.text = @"성인 콘텐츠를 검색하시려면\n 설정>성인검색 제한 설정을 해제 해주세요.";
    } else {
        
        self.infoLabel.text = [NSString stringWithFormat:@"총 %ld개의 검색결과가 있습니다." , (long)count];
    }
}

/**
 *  검색된 정보 및 UI를 삭제한다.
 */
- (void)resetData {
    
    self.pageIndex = 0;
    
    [self.searchWordArray removeAllObjects];
    [self.dataArray removeAllObjects];
    [self setListCount:0];
    [self.vodList reloadData];
    [self.programList reloadData];
}

/**
 *  검색어 테이블을 표출 여부를 설정한다.
 *
 *  @param isShow 검색어 테이블 표출 여부
 */
- (void)showAutoCompletList:(BOOL)isShow {
    
    if (isShow) {
        
        if (self.searchWordArray.count == 0) {
            
            self.autoCompletList.hidden = YES;
        } else {
            
            [self.autoCompletList reloadData];
            [self.autoCompletList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            self.autoCompletList.hidden = !isShow;
        }
    } else {
        
        [self.searchWordArray removeAllObjects];
        [self.autoCompletList reloadData];
        self.autoCompletList.hidden = !isShow;
    }
}

#pragma mark - Request

/**
 *  검색어 목록을 요청한다.
 */
- (void)requestSearchWord {
    
    self.searchWordTimer = nil;
    
    NSString* searchWord = [self.searchField.text trim];
    
    if (searchWord.length == 0) {
        return;
    }
    
    //성인컨텐츠 검색여부
    // includeAdultCategory 1, 0 성인 컨텐츠 포함 여부
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    CMContentsRestrictedType type = [ud restrictType];
    NSString* strOn = @"0";
    if (type == CMContentsRestrictedTypeNone) {
        strOn = @"1";
    }
    
    [NSMutableDictionary searchWordListWithSearchString:searchWord WithIncludeAdultCategory:strOn completion:^(NSArray *programs, NSError *error) {
        
        NSDictionary* response = programs[0];
        
        NSString* resultCode = response[CNM_OPEN_API_RESULT_CODE_KEY];
        if ([CNM_OPEN_API_RESULT_CODE_SUCCESS_KEY isEqualToString:resultCode] == false) {
            
            [self showAutoCompletList:NO];
            
            DDLogError(@"error : %@", response[CNM_OPEN_API_RESULT_ERROR_STRING_KEY]);
            
            return;
        }
        
        NSDictionary* itemDic = (NSDictionary*)response[SearchWordList];
        NSObject* item = itemDic[SearchWord];
        if ([item isKindOfClass:[NSArray class]]) {
            [self.searchWordArray addObjectsFromArray:(NSArray*)item];
        } else if([item isKindOfClass:[NSString class]]){
            [self.searchWordArray addObject:item];
        }
        
        /*NSObject* itemObject = response[searchWordList];
        
        if ([itemObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary* dic = (NSDictionary*)itemObject;
            NSArray* array = dic[@"searchWord"];
            [self.searchWordArray addObjectsFromArray:array];
        } else if ([itemObject isKindOfClass:[NSArray class]]) {
            [self.searchWordArray addObjectsFromArray:(NSArray*)itemObject];
        }*/
     
        [self showAutoCompletList:YES];
    }];
}

/**
 *  VOD 목륵을 요청한다.
 */
- (void)requestVodList {
    
    self.isLoading = YES;
    
    NSString* searchWord = [self.searchField.text trim];
    
    if (searchWord.length == 0) {
        return;
    }
    
//    [NSMutableDictionary vodSerchListWithSearchString:searchWord WithPageSize:pageSize WithPageIndex:self.pageIndex WithSortType:@"TitleAsc" completion:^(NSArray *programs, NSError *error) {
//        
//        self.isLoading = NO;
//        
//        NSDictionary* response = programs[0];
//        
//        NSString* resultCode = response[CNM_OPEN_API_RESULT_CODE_KEY];
//        if ([CNM_OPEN_API_RESULT_CODE_SUCCESS_KEY isEqualToString:resultCode] == false) {
//            
//            [self.dataArray removeAllObjects];
//            [self.vodList reloadData];
//            
//            DDLogError(@"error : %@", response[CNM_OPEN_API_RESULT_ERROR_STRING_KEY]);
//            
//            return;
//        }
//        
//        self.totalPage = [(NSString*)response[CNM_OPEN_API_RESULT_TOTAL_PAGE] integerValue];
//        
//        NSString* totalCount = response[CNM_OPEN_API_RESULT_TOTAL_COUNT];
//        [self setListCount:[totalCount integerValue]];
//        
//        NSObject* itemObject = response[VodSearch_Item];
//        
//        if ([itemObject isKindOfClass:[NSDictionary class]]) {
//            [self.dataArray addObject:itemObject];
//        } else if ([itemObject isKindOfClass:[NSArray class]]) {
//            [self.dataArray addObjectsFromArray:(NSArray*)itemObject];
//        }
//
//        [self.vodList reloadData];
//    }];
    
//    http://58.141.255.79:8080/HApplicationServer/searchContentGroup.json?version=1&terminalKey=8A5D2E45D3874824FF23EC97F78D358&includeAdultCategory=0&searchKeyword=막돼먹은&contentGroupProfile=2
    /*!<
     [(
     {
     __name = response;
     resultCode = 100;
     searchResultList =     {
     searchResult =     {
     contentGroupList =     {
     contentGroup =     (
     {
     assetNew = 0;
     imageFileName = http://58.141.255.79:8080/PosterImage/big/M0248152LSG188050410.jpg;
     rating = 15;
     runningTime = 00:47;
     smallImageFileName = http://58.141.255.79:8080/PosterImage/normal/M0248152LSG188050410.jpg;
     primaryAssetId = www.hchoice.co.kr|M0294955LSG282802401;
     title = 막돼먹은영애씨 시즌12;
     synopsis = 이직한 영애씨의 막돼먹은 뒷담화.;
     assetBundle = 0;
     likedCount = 0;
     mobilePublicationRight = 0;
     starring = 김현숙,송민형,윤서현,강예빈;
     assetFree = 1;
     episodePeerExistence = 1;
     assetSeriesLink = 1;
     isLiked = 0;
     production = 130708008300020;
     UHDAssetCount = 0;
     isFavorite = 0;
     director = 한상재, 윤재순;
     HDAssetCount = 21;
     SDAssetCount = 20;
     genre = 미니시리즈;
     promotionSticker = 0;
     reviewRating = 0.0;
     assetHot = 0;
     categoryId = 287092;
     contentGroupId = 282115;
     }
     .
     .
     .
     .
     .
     );
     }
     ;
     totalCount = 10;
     totalPage = 0;
     searchCategory = title;
     }
     ;
     }
     ;
     version = 1;
     }
     
     )]
     */
    
    // IncludeAdultCategory 성인 체크 여부 1 , 0
    NSURLSessionDataTask *tesk = [NSMutableDictionary searchContentGroupWithSearchKeyword:searchWord WithIncludeAdultCategory:@"0" completion:^(NSArray *gets, NSError *error) {
        
        DDLogError(@"vod 검색 = [%@]", gets);
        

        self.isLoading = NO;

        NSDictionary* response = gets[0];

        NSString* resultCode = response[CNM_OPEN_API_RESULT_CODE_KEY];
        if ([CNM_OPEN_API_RESULT_CODE_SUCCESS_KEY isEqualToString:resultCode] == false) {

            [self.dataArray removeAllObjects];
            [self.vodList reloadData];

            DDLogError(@"error : %@", response[CNM_OPEN_API_RESULT_ERROR_STRING_KEY]);

            return;
        }

        self.totalPage = [(NSString *)[[[response objectForKey:@"searchResultList"] objectForKey:@"searchResult"] objectForKey:@"totalPage"] integerValue];

//        NSString* totalCount = response[CNM_OPEN_API_RESULT_TOTAL_COUNT];
        NSString* totalCount = (NSString *)[[[response objectForKey:@"searchResultList"] objectForKey:@"searchResult"] objectForKey:@"totalCount"];
        [self setListCount:[totalCount integerValue]];

        NSObject* itemObject = [[[[response objectForKey:@"searchResultList"] objectForKey:@"searchResult"] objectForKey:@"contentGroupList"] objectForKey:@"contentGroup"];

        if ([itemObject isKindOfClass:[NSDictionary class]]) {
            [self.dataArray addObject:itemObject];
        } else if ([itemObject isKindOfClass:[NSArray class]]) {
            [self.dataArray addObjectsFromArray:(NSArray*)itemObject];
        }

        [self.vodList reloadData];

    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}


/**
 *  프로그램 목록을 요청한다.
 */
- (void)requestProgramList {
    
    self.isLoading = YES;
    
    NSString* searchWord = [self.searchField.text trim];
    
    if (searchWord.length == 0) {
        return;
    }
    
    CMAreaInfo* areaInfo = [[CMDBDataManager sharedInstance] currentAreaInfo];
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary programScheduleListWithSearchString:searchWord WithPageSize:pageSize WithPageIndex:self.pageIndex WithAreaCode:@"0" completion:^(NSArray *programs, NSError *error) {

        self.isLoading = NO;
        
        NSDictionary* response = programs[0];
        
        NSString* resultCode = response[CNM_OPEN_API_RESULT_CODE_KEY];
        if ([CNM_OPEN_API_RESULT_CODE_SUCCESS_KEY isEqualToString:resultCode] == false) {
            
            [self.dataArray removeAllObjects];
            [self.programList reloadData];
            
            DDLogError(@"error : %@", response[CNM_OPEN_API_RESULT_ERROR_STRING_KEY]);
            
            return;
        }
        
        NSString* totalCount = response[CNM_OPEN_API_RESULT_TOTAL_COUNT];
        [self setListCount:[totalCount integerValue]];
        
        self.totalPage = ceil([totalCount integerValue] / pageSize);
        
        NSObject* itemObject = response[ScheduleItem];
        
        if ([itemObject isKindOfClass:[NSDictionary class]]) {
            [self.dataArray addObject:itemObject];
        } else if ([itemObject isKindOfClass:[NSArray class]]) {
            [self.dataArray addObjectsFromArray:(NSArray*)itemObject];
        }
        
        [self.programList reloadData];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

/**
 *  선택된 탭메뉴에 해당되는 VOD/프로그램 목록을 요청한다.
 */
- (void)requestList {
    
    TABMENU_TYPE type = [self.tabMenu getTabMenuIndex];
    switch (type) {
        case VOD_TABMENU_TYPE: {
            
            [self requestVodList];
        }
            break;
        case PROGRAM_TABMENU_TYPE: {
            
            [self requestProgramList];
        }
            break;
    }
}

#pragma mark - Event

- (IBAction)buttonWasTouchUpInside:(id)sender {

    [self resetData];
    
    self.searchField.text = @"";
    [self.searchField becomeFirstResponder];
}

/**
 *  검색어 입력시, 키패드 타이핑시마다 검색어 목록 요청이 들어가는 막고자 딜레이 및 캔슬 추가.
 */
- (void)textMessageChanged:(CMTextField*)textField {
    
    [self showAutoCompletList:NO];
    
    if (self.searchWordTimer) {
        [self.searchWordTimer invalidate];
    }
    
    self.searchWordTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(requestSearchWord) userInfo:nil repeats:false];
}

#pragma mark - CMTabMenuViewDelegate (탭메뉴)

- (void)tabMenu:(CMTabMenuView *)sender didSelectedTab:(NSInteger)tabIndex {
    
    [self.searchField resignFirstResponder];
    [self showAutoCompletList:NO];
    
    [self resetData];
    [self requestList];
    
    switch (tabIndex) {
        case VOD_TABMENU_TYPE: {
            self.vodList.hidden = false;
            self.programList.hidden = true;
        }
            break;
        case PROGRAM_TABMENU_TYPE: {
            self.vodList.hidden = true;
            self.programList.hidden = false;
        }
            break;
    }
}

#pragma mark - UICollectionViewDataSource (VOD)

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CMSearchCollectionViewCell* cell = (CMSearchCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:VodCellIdentifier forIndexPath:indexPath];

    NSDictionary* data = self.dataArray[indexPath.row];

//    [cell setImageUrl:data[@"VOD_IMG"] title:data[@"VOD_Title"]];
    [cell setImageUrl:data[@"smallImageFileName"] title:data[@"title"]];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UITableViewDataSource (프로그램, 검색어)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.autoCompletList == tableView) {
        return self.searchWordArray.count;
    } else if (self.programList == tableView) {
        return self.dataArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.autoCompletList == tableView) {
        CMAutoCompletTableViewCell* cell = (CMAutoCompletTableViewCell*)[tableView dequeueReusableCellWithIdentifier:AutoCompletCell];
        
        [cell setTitle:self.searchWordArray[indexPath.row]];
        
        return cell;
    } else if (self.programList == tableView) {
        CMSearchTableViewCell* cell = (CMSearchTableViewCell*)[tableView dequeueReusableCellWithIdentifier:ProgramCellIdentifier];
        
        NSDictionary* item = self.dataArray[indexPath.row];
        
        [cell setData:item];
        
        //  스와이프시, 메뉴 셋팅
        [cell configureCellForItem:@{}];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate (프로그램, 검색어)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.autoCompletList == tableView) {
        return 33;
    } else if (self.programList == tableView) {
        return 66;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.autoCompletList == tableView) {
        
        [self.searchField resignFirstResponder];
        
        self.searchField.text = self.searchWordArray[indexPath.row];
        [self resetData];
        [self requestList];
        
        [self showAutoCompletList:NO];
    } else if (self.programList == tableView) {
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextFieldDelegate (검색어)

- (void)textFieldDidBeginEditing:(UITextField *)textField {

}

- (void)textFieldDidEndEditing:(UITextField *)textField {

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self resetData];
    
    [self showAutoCompletList:NO];
    
    [self requestList];
    
    return YES;
}

#pragma mark - UIScrollViewDelegate (VOD, 프로그램)

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    switch ([self.tabMenu getTabMenuIndex]) {
        case VOD_TABMENU_TYPE: {
            
        }
            break;
        case PROGRAM_TABMENU_TYPE: {
            [BMXSwipableCell hideBasementOfAllCells];
        }
            break;
        default:
            break;
    }
    
}

/**
 *  검색된 목록의 마지막까지 스크롤 될 경우, 다음 페이지 목록 요청
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    switch ([self.tabMenu getTabMenuIndex]) {
        case VOD_TABMENU_TYPE: {
            
            CGFloat offsetY = scrollView.contentOffset.y;
            CGFloat contentHeight = scrollView.contentSize.height;
            
//            if ( self.isLoading == NO && (offsetY + scrollView.frame.size.height > contentHeight - 200)) {
            if ( self.isLoading == NO && (offsetY + scrollView.frame.size.height > contentHeight)) {
                if (self.totalPage > self.pageIndex) {
                    self.pageIndex++;
                    
                    [self requestVodList];
                }
            }
        }
            break;
        case PROGRAM_TABMENU_TYPE: {
            
            CGFloat offsetY = scrollView.contentOffset.y;
            CGFloat contentHeight = scrollView.contentSize.height;
            
            if ( self.isLoading == NO && (offsetY + scrollView.frame.size.height > contentHeight)) {
                if (self.totalPage > self.pageIndex) {
                    self.pageIndex++;
                    
                    [self requestProgramList];
                }
            }
        }
            break;
        default:
            break;
    }
}

@end
