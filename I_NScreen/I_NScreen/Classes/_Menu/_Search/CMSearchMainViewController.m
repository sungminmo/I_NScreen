//
//  CMSearchMainViewController.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 9. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMSearchMainViewController.h"
#import "CMSearchCollectionViewCell.h"
#import "CMAutoCompletTableViewCell.h"
#import "CMConstants.h"
#import "BMXSwipableCell+ConfigureCell.h"
#import "NSMutableDictionary+SEARCH.h"
#import "CMDBDataManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "UIAlertView+AFNetworking.h"
#import "VodDetailMainViewController.h"
#import "CMWatchReserveList.h"
#import "NSMutableDictionary+REMOCON.h"
#import "NSMutableDictionary+PVR.h"
#import "NSMutableDictionary+EPG.h"
#import "VodDetailBundleMainViewController.h"
#import "NSMutableDictionary+VOD.h"

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

static const CGFloat pageSize = 20;

@interface CMSearchMainViewController ()

@property (nonatomic, weak) IBOutlet CMTextField* searchField;    //  검색어 텍스트 필드
@property (nonatomic, weak) IBOutlet UILabel* infoLabel;          //  검색갤과 정보 표출 라벨
@property (nonatomic, weak) IBOutlet UITableView* autoCompletList;//  검색어 테이블

@property (nonatomic, strong) CMTabMenuView* tabMenu;               //  vod, 프로그램 탭메뉴
@property (nonatomic, weak) IBOutlet UIView* tabMenuContainer;    //  vod, 프로그램 탭메뉴

@property (nonatomic, weak) IBOutlet UICollectionView* vodList;   //  vod 목록 테이블
@property (nonatomic, weak) IBOutlet UITableView* programList;    //  프로그램 목록 테이블
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topConstraint;

@property (nonatomic, strong) NSMutableArray* searchWordArray;  //  검색어 목록
@property (nonatomic, strong) NSMutableArray* dataArray;        //  vod/프로그램 목록
@property (nonatomic, strong) NSMutableArray* programArray;        //  vod/프로그램 목록

@property (nonatomic, assign) NSInteger pageIndex;  //  검색 목록 페이지 인덱스
@property (nonatomic, assign) NSInteger totalPage;  //  검색 목록 전체 페이지 수

@property (nonatomic, assign) BOOL isLoading;   //  request 진행 여부

@property (nonatomic, strong) NSTimer* searchWordTimer; //  검색어 요청 타이머

@property (nonatomic, strong) NSMutableArray *recordingchannelArr;  // 녹화중인지 배열
@property (nonatomic, strong) NSMutableArray *pRecordReservListArr; // 녹화 예약 목록 배열

@property (nonatomic, strong) NSMutableArray *pNowStateCheckArr;    // 상태값 체크

@property (nonatomic, weak) IBOutlet UILabel *pComentLbl;

@property (nonatomic, strong) NSURLSessionDataTask *tesk1;
@property (nonatomic, strong) NSURLSessionDataTask *tesk2;

@end

@implementation CMSearchMainViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"검색";
    self.isUseNavigationBar = YES;
    self.topConstraint.constant = cmNavigationHeight;
    
    self.pageIndex = -1;
    self.totalPage = 0;
    self.searchWordArray = [@[] mutableCopy];
    self.dataArray = [@[] mutableCopy];
    self.programArray = [@[] mutableCopy];
    
    self.pRecordReservListArr = [@[] mutableCopy];
    self.recordingchannelArr = [@[] mutableCopy];
    
    self.pNowStateCheckArr = [@[] mutableCopy];
    
    [self setListCount:-1];

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
    NSString *sIncludeAdultCategory = @"0";
    
    if ( [[CMAppManager sharedInstance] getKeychainAdultCertification] == YES )
    {
        sIncludeAdultCategory = @"1";
    }
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary searchWordListWithSearchString:@"막" WithIncludeAdultCategory:@"0" completion:^(NSArray *programs, NSError *error) {
        DDLogError(@"%@", programs);
    }];
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)loadUI {
    
    self.searchField.returnKeyType = UIReturnKeySearch;
    
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
- (void)setListCount:(NSInteger)count
{
    if (count < 0) {
        self.infoLabel.hidden = YES;
        self.pComentLbl.hidden = NO;
        self.pComentLbl.text = @"검색창에 원하시는 검색어를 입력해 주세요";
    }
    else if ( count == 0 )
    {
        self.infoLabel.hidden = NO;
        self.infoLabel.text = [NSString stringWithFormat:@"총 %ld개의 검색결과가 있습니다." , (long)count];
        
        self.pComentLbl.hidden = NO;
        self.pComentLbl.text = @"검색결과가 없습니다. 다른 검색어를 입력해 주세요.";
    }
    else
    {
        self.infoLabel.hidden = NO;
        self.infoLabel.text = [NSString stringWithFormat:@"총 %ld개의 검색결과가 있습니다." , (long)count];
        self.pComentLbl.hidden = YES;
    }
}

/**
 *  검색된 정보 및 UI를 삭제한다.
 */
- (void)resetData {
    
    self.pageIndex = -1;
    
    [self.searchWordArray removeAllObjects];
    [self.dataArray removeAllObjects];
    [self.programArray removeAllObjects];
    [self setListCount:-1];
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
        
        if (self.searchWordTimer == nil) {
            return;
        }

        self.searchWordTimer = nil;
        
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
    
    // IncludeAdultCategory 성인 체크 여부 0일시 성인 제한 , 1이면 전체 뿌림
    NSString *sIncludeAdultCategory = @"1";
    if ( [[CMAppManager sharedInstance] getKeychainAdultLimit] == YES )
    {
        sIncludeAdultCategory = @"0";
    }
    
    self.tesk1 = [NSMutableDictionary searchContentGroupWithSearchKeyword:searchWord WithIncludeAdultCategory:sIncludeAdultCategory completion:^(NSArray *gets, NSError *error) {
        
        
        DDLogError(@"vod 검색 = [%@]", gets);
        
        [self.dataArray removeAllObjects];
        

        NSDictionary* response = gets[0];

        NSString* resultCode = response[CNM_OPEN_API_RESULT_CODE_KEY];
        if ([CNM_OPEN_API_RESULT_CODE_SUCCESS_KEY isEqualToString:resultCode] == false) {

            
            [self.vodList reloadData];

            DDLogError(@"error : %@", response[CNM_OPEN_API_RESULT_ERROR_STRING_KEY]);

            return;
        }

        // test
        self.totalPage = 0;

        NSDictionary* searchResult = [[response objectForKey:@"searchResultList"] objectForKey:@"searchResult"];
        id countObj = [searchResult valueForKeyPath:@"totalCount"];
        NSInteger total = 0;
        
        if ([countObj isKindOfClass:[NSArray class]]) {
            for (NSString* strCount in (NSArray*)countObj) {
                total += [strCount integerValue];
            }
        }
        else {
            total = [(NSString*)countObj integerValue];
        }
        [self setListCount:total];

        NSObject *itemObje = [[response objectForKey:@"searchResultList"] objectForKey:@"searchResult"];
        
        if ( [itemObje isKindOfClass:[NSDictionary class]] )
        {
            NSObject *itemSubObje = [[(NSDictionary *)itemObje objectForKey:@"contentGroupList"] objectForKey:@"contentGroup"];
            
            if ( [itemSubObje isKindOfClass:[NSDictionary class]] )
            {
                [self.dataArray addObject:itemSubObje];
            }
            else
            {
                [self.dataArray setArray:(NSArray *)itemSubObje];
            }
        }
        else
        {
            NSObject *itemSubObje = [[[(NSArray *)itemObje objectAtIndex:0] objectForKey:@"contentGroupList"] objectForKey:@"contentGroup"];
            
            if ( [itemSubObje isKindOfClass:[NSDictionary class]] )
            {
                [self.dataArray addObject:itemSubObje];
            }
            else
            {
                [self.dataArray setArray:(NSArray *)itemSubObje];
            }
        }
        
        [self.vodList reloadData];
        self.isLoading = NO;
    }];
    
//    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:self.tesk1 delegate:nil];
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
    
    if (self.pageIndex < 0)
    {
        self.pageIndex = 0;
        
        [self.programArray removeAllObjects];
        [self.programList reloadData];
    }
    
    CMAreaInfo* areaInfo = [[CMDBDataManager sharedInstance] currentAreaInfo];
    
    self.tesk2 = [NSMutableDictionary programScheduleListWithSearchString:searchWord WithPageSize:pageSize WithPageIndex:self.pageIndex WithAreaCode:areaInfo.areaCode completion:^(NSArray *programs, NSError *error) {

//        self.isLoading = NO;
        
        DDLogError(@"tv프로그램 목록 가져오기 = [%@]", programs);

        NSDictionary* response = programs[0];
        NSString* resultCode = response[CNM_OPEN_API_RESULT_CODE_KEY];
        if ([CNM_OPEN_API_RESULT_CODE_SUCCESS_KEY isEqualToString:resultCode] == false) {

            [self.programArray removeAllObjects];
            [self.programList reloadData];
            
            DDLogError(@"error : %@", response[CNM_OPEN_API_RESULT_ERROR_STRING_KEY]);
            return;
        }
        
        NSString* totalCount = response[CNM_OPEN_API_RESULT_TOTAL_COUNT];
        [self setListCount:[totalCount integerValue]];
        
        self.totalPage = ceil([totalCount integerValue] / pageSize);
        
        NSObject* itemObject = response[ScheduleItem];
        
        if ([itemObject isKindOfClass:[NSDictionary class]]) {
            [self.programArray addObject:itemObject];
        } else if ([itemObject isKindOfClass:[NSArray class]]) {
            [self.programArray addObjectsFromArray:(NSArray*)itemObject];
        }
        
        [self setListDataSplit];
        
        [self requestWithGetSetTopStatus];
    }];
    
//    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:self.tesk2 delegate:nil];
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

#pragma mark - 리모컨 상태 체크 전문( 녹화중인지 체크 )
- (void)requestWithGetSetTopStatus
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary remoconGetSetTopStatusCompletion:^(NSArray *pairing, NSError *error) {
        
        DDLogError(@"리모컨 상태 체크 = [%@]", pairing);
        
        if ( [pairing count] == 0 )
            return;
        
        NSString *sRecordingchannel1 = [NSString stringWithFormat:@"%@", [[pairing objectAtIndex:0] objectForKey:@"recordingchannel1"]];
        NSString *sRecordingchannel2 = [NSString stringWithFormat:@"%@", [[pairing objectAtIndex:0] objectForKey:@"recordingchannel2"]];
        
        [self.recordingchannelArr removeAllObjects];
        
        [self.recordingchannelArr addObject:sRecordingchannel1];
        [self.recordingchannelArr addObject:sRecordingchannel2];
        
        
        DDLogError(@"녹화중 체크 = [%@]", self.recordingchannelArr );
        
        [self requestWithGetRecordReserveList];
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}


#pragma mark - 녹화 예약 목록 가져오는 전문
- (void)requestWithGetRecordReserveList
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary pvrGetrecordReservelistCompletion:^(NSArray *pvr, NSError *error) {
        
        DDLogError(@"녹화 예약 목록 = [%@]", pvr);
        if ( [pvr count] == 0 )
            return;
        
        [self.pRecordReservListArr removeAllObjects];
        
        NSObject *itemObject = [[pvr objectAtIndex:0] objectForKey:@"Reserve_Item"];
        
        if ( [itemObject isKindOfClass:[NSDictionary class]] )
        {
            [self.pRecordReservListArr addObject:(NSDictionary *)itemObject];
        }
        else
        {
            [self.pRecordReservListArr setArray:(NSArray *)itemObject];
        }
        
        DDLogError(@"녹화예약목록2 = [%@]", self.pRecordReservListArr);
        
        for ( int i =0; i < [self.programArray count]; i++ )
        {
            [self setCellStateIndex:i];
        }
        
        
        [self.programList reloadData];
        
        self.isLoading = NO;
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - Event

- (IBAction)buttonWasTouchUpInside:(id)sender {

    //  검색필드에 X 버튼 터치시
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

    switch (tabIndex) {
        case VOD_TABMENU_TYPE: {
            if (self.tesk2) {
                [self.tesk2 cancel];
                self.tesk2 = nil;
            }
            self.vodList.hidden = false;
            self.programList.hidden = true;
        }
            break;
        case PROGRAM_TABMENU_TYPE: {
            if (self.tesk1) {
                [self.tesk1 cancel];
                self.tesk1 = nil;
            }
            self.vodList.hidden = true;
            self.programList.hidden = false;
        }
            break;
    }
    
    [self requestList];
}

#pragma mark - UICollectionViewDataSource (VOD)

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CMSearchCollectionViewCell* cell = (CMSearchCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:VodCellIdentifier forIndexPath:indexPath];

    NSDictionary* data = self.dataArray[indexPath.row];

    
    NSArray *keyArr = [data allKeys];
    BOOL isTvOnly = NO;
    for ( NSString *key in keyArr )
    {
        if ( [key isEqualToString:@"mobilePublicationRight"] )
        {
            if ( ![data[@"mobilePublicationRight"] isEqualToString:@"1"] )
                isTvOnly = YES;
        }
        else if ( [key isEqualToString:@"publicationRight"] )
        {
            if ( ![data[@"publicationRight"] isEqualToString:@"2"] )
                isTvOnly = YES;
        }
    }
    
    [cell setImageUrl:data[@"smallImageFileName"] title:data[@"title"] rating:data[@"rating"] WithTyOnly:isTvOnly data:data];
   
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    
    if ( [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_6_PLUS] )
    {
        size.width = 95;
        size.height = 158;
    }
    else if ( [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_6] )
    {
        size.width = 85;
        size.height = 138;
    }
    else
    {
        size.width = 70;
        size.height = 113;
    }
    
    
    return size;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *sRatinting = [NSString stringWithFormat:@"%@", [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"rating"]];
    NSString *sAssetId = @"";
    NSString *sContentGroupId = @"";
    NSString *sAssetBundle = @"0";
    NSString *sEpisodePeerExistence = @"0";
    
    NSArray *allKey = [[self.dataArray objectAtIndex:indexPath.row] allKeys];
    NSDictionary* item = self.dataArray[indexPath.row];
    
    if ([allKey containsObject:@"assetId"])
    {
        sAssetId = item[@"assetId"];
    }
    
    if ([allKey containsObject:@"primaryAssetId"])
    {
        sAssetId = item[@"primaryAssetId"];
    }
    
    if ([allKey containsObject:@"episodePeerExistence"])
    {
        sEpisodePeerExistence = item[@"episodePeerExistence"];
    }
    
    if ([allKey containsObject:@"contentGroupId"])
    {
        sContentGroupId = item[@"contentGroupId"];
    }
    
    if ([allKey containsObject:@"assetBundle"])
    {
        sAssetBundle = item[@"assetBundle"];
    }
    
    if ( [sRatinting isEqualToString:@"19"] )
    {
        // 성인
        if ( [[CMAppManager sharedInstance] getKeychainAdultCertification] == YES )
        {
            // 인증 받았으면s
            if ( [sAssetBundle isEqualToString:@"1"] )
            {
                // 묶음 상품
                [self requestWithAssetInfo:sAssetId WithEpisodePeerExistence:sEpisodePeerExistence WithContentGroupId:sContentGroupId];
            }
            else
            {
                VodDetailMainViewController *pViewController = [[VodDetailMainViewController alloc] initWithNibName:@"VodDetailMainViewController" bundle:nil];
                pViewController.pAssetIdStr = sAssetId;
                pViewController.pEpisodePeerExistence = sEpisodePeerExistence;
                pViewController.pContentGroupId = sContentGroupId;
                [self.navigationController pushViewController:pViewController animated:YES];
            }
        }
        else
        {
            [SIAlertView alert:@"성인인증 필요" message:@"성인 인증이 필요한 콘텐츠입니다.\n성인 인증을 하시겠습니까?" cancel:@"취소" buttons:@[@"확인"]
                    completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                        
                        if ( buttonIndex == 1 )
                        {
                            // 설정 창으로 이동
                            CMPreferenceMainViewController* controller = [[CMPreferenceMainViewController alloc] initWithNibName:@"CMPreferenceMainViewController" bundle:nil];
                            [self.navigationController pushViewController:controller animated:YES];
                        }
                    }];
        }
    }
    else
    {
        if ( [sAssetBundle isEqualToString:@"1"] )
        {
            [self requestWithAssetInfo:sAssetId WithEpisodePeerExistence:sEpisodePeerExistence WithContentGroupId:sContentGroupId];
        }
        else
        {
            VodDetailMainViewController *pViewController = [[VodDetailMainViewController alloc] initWithNibName:@"VodDetailMainViewController" bundle:nil];
            pViewController.pAssetIdStr = sAssetId;
            pViewController.pEpisodePeerExistence = sEpisodePeerExistence;
            pViewController.pContentGroupId = sContentGroupId;
            [self.navigationController pushViewController:pViewController animated:YES];
        }
    }
    
}

#pragma mark - UITableViewDataSource (프로그램, 검색어)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.autoCompletList == tableView) {
        return self.searchWordArray.count;
    } else if (self.programList == tableView) {
        return self.programArray.count;
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
        
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        NSDictionary* item = self.programArray[indexPath.row];
        
        CMDBDataManager *manager = [CMDBDataManager sharedInstance];
        RLMArray *ramArr = [manager getFavorChannel];

        NSString *sSeq = item[@"channelProgramSeq"];
        NSString *sProgramId = item[@"channelProgramID"];
    
        BOOL isCheck = NO;
        for ( CMFavorChannelInfo *info in ramArr )
        {
            if ( [info.pChannelSeq isEqualToString:sSeq] &&
                [info.pProgramId isEqualToString:sProgramId] )
            {
                // 선호체널
                isCheck = YES;
            }
        }
        cell.delegate2 = self;
        [cell setData:item WithIndex:(int)indexPath.row WithStar:isCheck WithWatchCheck:[self getWatchReserveIndex:(int)indexPath.row] WithRecordingCheck:[self getRecordingChannelIndex:(int)indexPath.row] WithReservCheck:[self getRecordReservListIndex:(int)indexPath.row]];
        
        //  스와이프시, 메뉴 셋팅
        
        if ( [self.pNowStateCheckArr count] != 0 )
        {
            NSString *sMore = [NSString stringWithFormat:@"%@", [[self.pNowStateCheckArr objectAtIndex:indexPath.row] objectForKey:@"moreState"]];
            NSString *sDele = [NSString stringWithFormat:@"%@", [[self.pNowStateCheckArr objectAtIndex:indexPath.row] objectForKey:@"deleState"]];
            
            [cell configureCellForItem:@{@"More":sMore, @"Delete":sDele} WithItemCount:2];
            
        }
        
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
        
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if ( self.programList == tableView )
    {
        NSDictionary* item = self.programArray[indexPath.row];
        
        NSString *sSeq = item[@"channelProgramSeq"];
        NSString *sProgramId = item[@"channelProgramID"];
        CMDBDataManager *manager = [CMDBDataManager sharedInstance];
        RLMArray *ramArr = [manager getFavorChannel];
        BOOL isCheck = NO;
        
        int nCount = 0;
        for ( CMFavorChannelInfo *info in ramArr )
        {
            if ( [info.pChannelSeq isEqualToString:sSeq] &&
                [info.pProgramId isEqualToString:sProgramId] )
            {
                isCheck = YES;
                [manager removeFavorChannel:nCount];
            }
            nCount++;
        }
        
        if ( isCheck == NO )
        {
            [manager setFavorChannel:item];
        }
        
        [self.programList reloadData];
    }
    
   
}

#pragma mark - UITextFieldDelegate (검색어)

- (void)textFieldDidBeginEditing:(UITextField *)textField {

}

- (void)textFieldDidEndEditing:(UITextField *)textField {

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (self.searchWordTimer) {
        [self.searchWordTimer invalidate];
        self.searchWordTimer = nil;
    }
    
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
            
            /*CGFloat offsetY = scrollView.contentOffset.y;
            CGFloat contentHeight = scrollView.contentSize.height;
            
            
            if ( self.isLoading == NO && (offsetY + scrollView.frame.size.height > contentHeight)) {
                if (self.totalPage > self.pageIndex + 1) {
                    
                    if (self.isLoading == NO)
                    {
                        self.pageIndex++;
                        
                        [self requestVodList];
                    }
                }
            }*/
        }
            break;
        case PROGRAM_TABMENU_TYPE: {
            
            CGFloat offsetY = scrollView.contentOffset.y;
            CGFloat contentHeight = scrollView.contentSize.height;
            
            if ( self.isLoading == NO && (offsetY + scrollView.frame.size.height > contentHeight)) {
                if (self.totalPage > self.pageIndex + 1) {
                    if (self.isLoading == NO)
                    {
                        self.isLoading = YES;
                        self.pageIndex++;
                        DDLogDebug(@"======= page : %ld", self.pageIndex);
                        [self requestProgramList];
                    }
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 델리게이트
- (void)CMSearchTableViewCellTag:(int)nTag
{
    [self.programList reloadData];
}

#pragma mark - 시청예약 체크
- (BOOL)getWatchReserveIndex:(int)index
{
    NSString *sTilte = [NSString stringWithFormat:@"%@", [[self.programArray objectAtIndex:index] objectForKey:@"channelProgramTitle"]];
    NSString *sSeq = [NSString stringWithFormat:@"%@", [[self.programArray objectAtIndex:index] objectForKey:@"channelProgramSeq"]];
    NSString *sProgramId = [NSString stringWithFormat:@"%@", [[self.programArray objectAtIndex:index] objectForKey:@"channelProgramID"]];
    
    CMDBDataManager *manager = [CMDBDataManager sharedInstance];
    BOOL isCheck = NO;
    for ( CMWatchReserveList *info in [manager getWatchReserveList] )
    {
        if ( [sTilte isEqualToString:info.programTitleStr] &&
            [sSeq isEqualToString:info.scheduleSeqStr] &&
            [sProgramId isEqualToString:info.programIdStr] )
        {
            isCheck = YES;
        }
    }
    
    return isCheck;
}

#pragma mark - 녹화중 체크
- (BOOL)getRecordingChannelIndex:(int)index
{
    // 체널 id 로 체크
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.programArray objectAtIndex:index] objectForKey:@"channelId"]];
    
    BOOL isCheck = NO;
    for ( NSString *str in self.recordingchannelArr )
    {
        if ( [str isEqualToString:sChannelId] )
        {
            isCheck = YES;
        }
    }
    return isCheck;
}

#pragma mark - 녹화 예약 체크
- (BOOL)getRecordReservListIndex:(int)index
{
    NSString *sRecordStartTime = [NSString stringWithFormat:@"%@", [[self.programArray objectAtIndex:index] objectForKey:@"channelProgramTime"]];
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.programArray objectAtIndex:index] objectForKey:@"channelId"]];
    
    BOOL isCheck = NO;
    for ( NSDictionary *dic in self.pRecordReservListArr )
    {
        NSString *sDicRecordStartTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"RecordStartTime"]];
        NSString *sDicChannelId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"channelId"]];
        
        if ( [sRecordStartTime isEqualToString:sDicRecordStartTime] &&
            [sChannelId isEqualToString:sDicChannelId] )
        {
            isCheck = YES;
        }
    }
    return isCheck;
}


- (void)setListDataSplit
{
    [self.pNowStateCheckArr removeAllObjects];
    
    for (int i = 0; i < self.programArray.count; i++ )
    {
        NSMutableDictionary *stateDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"", @"cellState", @"", @"moreState", @"", @"deleState", nil];
        [self.pNowStateCheckArr addObject:stateDic];
    }
}


- (void)setCellStateIndex:(int)index
{
    NSString *sState = @"";
    if ( [self getWatchReserveIndex:index] == YES )
    {
        sState = @"시청예약";
    }
    
    if ( [self getRecordingChannelIndex:index] == YES )
    {
        sState = @"녹화중";
    }
    
    if ( [self getRecordReservListIndex:index] == YES )
    {
        sState = @"녹화예약중";
    }
    
    [[self.pNowStateCheckArr objectAtIndex:index] setObject:sState forKey:@"cellState"];
    
    NSString *sMore = @"";
    NSString *sDele = @"";
    if ( [self getWatchReserveIndex:index] == YES )
    {
        // 시청 예약중이기 때문에 시청 예약 취소로
        sMore = @"시청예약취소";
    }
    else
    {
        // 시청 예약 취소이기 때문에 시청 예약중으로
        sMore = @"시청예약설정";
    }
    
    if ( [self getRecordReservListIndex:index] == YES )
    {
        // 녹화예약중이면 녹화예약취소로
        sDele = @"녹화예약취소";
    }
    else
    {
        // 녹화예약취소이면 녹화예약설정으로
        sDele = @"녹화예약설정";
    }

    
    [[self.pNowStateCheckArr objectAtIndex:index] setObject:sMore forKey:@"moreState"];
    [[self.pNowStateCheckArr objectAtIndex:index] setObject:sDele forKey:@"deleState"];
}


- (NSString *)getWatchReserveIndex2:(int)index
{
    NSString *sTilte = [NSString stringWithFormat:@"%@", [[self.programArray objectAtIndex:index] objectForKey:@"channelProgramTitle"]];
    NSString *sSeq = [NSString stringWithFormat:@"%@", [[self.programArray objectAtIndex:index] objectForKey:@"channelProgramSeq"]];
    NSString *sProgramId = [NSString stringWithFormat:@"%@", [[self.programArray objectAtIndex:index] objectForKey:@"channelId"]];
    
    CMDBDataManager *manager = [CMDBDataManager sharedInstance];
    BOOL isCheck = NO;
    for ( CMWatchReserveList *info in [manager getWatchReserveList] )
    {
        if ( [sTilte isEqualToString:info.programTitleStr] &&
            [sSeq isEqualToString:info.scheduleSeqStr] &&
            [sProgramId isEqualToString:info.programIdStr] )
        {
            isCheck = YES;
        }
    }
    
    
    NSString *sTitle = @"시청예약설정";
    if ( isCheck == YES )
        sTitle = @"시청예약취소";
    return sTitle;
}

#pragma mark - 델리게이트
#pragma mark - EpgSubTableViewCellDelegate
- (void)CMSearchTableViewMoreBtn:(int)nIndex
{
    // 시청 예약 체크
    if ( [[self getWatchReserveIndex2:nIndex] isEqualToString:@"시청예약설정"] )
    {
        // 설정 해제
        CMDBDataManager *manager = [CMDBDataManager sharedInstance];
        [manager setWatchReserveList:[self.programArray objectAtIndex:nIndex]];
        [[self.pNowStateCheckArr objectAtIndex:nIndex] setObject:@"시청예약" forKey:@"cellState"];
        [[self.pNowStateCheckArr objectAtIndex:nIndex] setObject:@"시청예약취소" forKey:@"moreState"];
    }
    else
    {
        // 시청 예약 설정
        CMDBDataManager *manager = [CMDBDataManager sharedInstance];
        [manager removeWatchReserveList:[self.programArray objectAtIndex:nIndex]];
        [[self.pNowStateCheckArr objectAtIndex:nIndex] setObject:@"" forKey:@"cellState"];
        [[self.pNowStateCheckArr objectAtIndex:nIndex] setObject:@"시청예약설정" forKey:@"moreState"];
    }
    
    [self.programList reloadData];
}

- (void)CMSearchTableViewDeleteBtn:(int)nIndex
{
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.programArray objectAtIndex:nIndex] objectForKey:@"channelId"]];
    
    NSString *sProgramBroadcastingStartTime = [NSString stringWithFormat:@"%@", [[self.programArray objectAtIndex:nIndex] objectForKey:@"channelProgramTime"]];
    
    BOOL isCheck = NO;
    for ( NSDictionary *dic in self.pRecordReservListArr )
    {
        NSString *sRecordStartTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"RecordStartTime"]];
        NSString *sChannelIdReserv = [NSString stringWithFormat:@"%@", [dic objectForKey:@"channelId"]];
        
        if ( [sRecordStartTime isEqualToString:sProgramBroadcastingStartTime] &&
            [sChannelId isEqualToString:sChannelIdReserv] )
        {
            
            // 녹화 예약중이다
            isCheck = YES;
        }
    }
    
    if ( isCheck == YES )
    {
        [self requestWithSetRecordCancelReserveWithReserveCancel:@"2" WithSeriesId:0 WithIndex:nIndex];
        
    }
    else
    {
        [self requstWithSetRecordReserveWithIndex:nIndex];
        
    }

}

#pragma mark - 녹화예약 취소
- (void)requestWithSetRecordCancelReserveWithReserveCancel:(NSString *)reserveCancel WithSeriesId:(NSString *)seriesId WithIndex:(int)nIndex
{
    //    ReserveCancel = 1 (시리즈 전체 삭제) / ReserveCancel = 2 (단편 삭제)
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.programArray objectAtIndex:nIndex] objectForKey:@"channelId"]];
    NSString *sProgramBroadcastingStartTime = [NSString stringWithFormat:@"%@", [[self.programArray objectAtIndex:nIndex] objectForKey:@"channelProgramTime"]];
    
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary epgSetRecordCancelReserveWithChannelId:sChannelId WithStartTime:sProgramBroadcastingStartTime WithSeriesId:seriesId WithReserveCancel:reserveCancel completion:^(NSArray *epgs, NSError *error) {
        
        DDLogError(@"녹화에약취소 = [%@}", epgs);
        
        if ( [epgs count] == 0 )
            return;
        
        if ( [[[epgs objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
        {
            [[self.pNowStateCheckArr objectAtIndex:nIndex] setObject:@"" forKey:@"cellState"];
            [[self.pNowStateCheckArr objectAtIndex:nIndex] setObject:@"녹화예약설정" forKey:@"deleState"];
            [self.programList reloadData];
        }
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 녹화예약설정 단일
- (void)requstWithSetRecordReserveWithIndex:(int)nIndex
{
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.programArray objectAtIndex:nIndex] objectForKey:@"channelId"]];
    NSString *sProgramBroadcastingStartTime = [NSString stringWithFormat:@"%@", [[self.programArray objectAtIndex:nIndex] objectForKey:@"channelProgramTime"]];
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary epgSetRecordReserveWithChannelId:sChannelId WithStartTime:sProgramBroadcastingStartTime completion:^(NSArray *epgs, NSError *error) {
        
        DDLogError(@"녹화 예약 설정 단일 = [%@]", epgs);
        if ( [epgs count] == 0 )
            return;
        
        if ( [[[epgs objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
        {
            [[self.pNowStateCheckArr objectAtIndex:nIndex] setObject:@"녹화예약중" forKey:@"cellState"];
            [[self.pNowStateCheckArr objectAtIndex:nIndex] setObject:@"녹화예약취소" forKey:@"deleState"];
            [self.programList reloadData];
        }
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 녹화예약설정 시리즈
- (void)requstWithSetRecordSeriesReserveWithSeries:(NSString *)series WithIndex:(int)nIndex
{
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [[self.programArray objectAtIndex:nIndex] objectForKey:@"channelId"]];
    
    NSString *sProgramBroadcastingStartTime = [NSString stringWithFormat:@"%@", [[self.programArray objectAtIndex:nIndex] objectForKey:@"channelProgramTime"]];
    
    
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary epgSetRecordSeriesReserveWithChannelId:sChannelId WithStartTime:sProgramBroadcastingStartTime WithSeriesId:series completion:^(NSArray *epgs, NSError *error) {
        
        DDLogError(@"녹화예약 설정 시리즈 = [%@]", epgs);
        if ( [epgs count] == 0 )
            return;
        
        if ( [[[epgs objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
        {
            [[self.pNowStateCheckArr objectAtIndex:nIndex] setObject:@"녹화예약중" forKey:@"cellState"];
            [[self.pNowStateCheckArr objectAtIndex:nIndex] setObject:@"녹화예약취소" forKey:@"deleState"];
            [self.programList reloadData];
        }
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
    
}

#pragma mark - vod 상세 bundle 이며 구매 여부를 가져오기 위해 호출
- (void)requestWithAssetInfo:(NSString *)assetInfo WithEpisodePeerExistence:(NSString *)episodePeerExistence WithContentGroupId:(NSString *)contentGroupId
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetAssetInfoWithAssetId:assetInfo WithAssetProfile:@"9" completion:^(NSArray *vod, NSError *error) {
        
        DDLogError(@"vod 상세 = [%@]", vod);
        
        if ( [vod count] == 0 )
            return;
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        NSObject *itemObject = [[[[vod objectAtIndex:0] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"];
        
        if ( [itemObject isKindOfClass:[NSDictionary class]] )
        {
            [arr addObject:itemObject];
        }
        else
        {
            [arr setArray:(NSArray *)itemObject];
        }
        
        NSString *sProductId = @"";
        
        BOOL isCheck = NO;
        for ( NSDictionary *dic in arr )
        {
            NSString *sProductType = dic[@"productType"];
            NSString *sPurchasedTime = dic[@"purchasedTime"];
            
            if ( [sProductType isEqualToString:@"Bundle"] &&
                [sPurchasedTime length] != 0 )
            {   // 번들이고 구매한 사용자
                isCheck = YES;
                sProductId = dic[@"productId"];
            }
        }
        
        if ( isCheck == YES )
        {
            // 묶음 페이지이동
            VodDetailBundleMainViewController *pViewController = [[VodDetailBundleMainViewController alloc] initWithNibName:@"VodDetailBundleMainViewController" bundle:nil];
            pViewController.sAssetId = assetInfo;
            pViewController.sEpisodePeerExistence = episodePeerExistence;
            pViewController.sContentGroupId = contentGroupId;
            pViewController.sProductId = sProductId;
            [self.navigationController pushViewController:pViewController animated:YES];
        }
        else
        {
            // 기존 상세 로직
            VodDetailMainViewController *pViewController = [[VodDetailMainViewController alloc] initWithNibName:@"VodDetailMainViewController" bundle:nil];
            pViewController.pAssetIdStr = assetInfo;
            pViewController.pEpisodePeerExistence = episodePeerExistence;
            pViewController.pContentGroupId = contentGroupId;
            [self.navigationController pushViewController:pViewController animated:YES];
        }
        
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

@end
