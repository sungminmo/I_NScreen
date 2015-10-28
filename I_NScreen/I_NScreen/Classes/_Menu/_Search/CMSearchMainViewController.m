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

typedef enum : NSInteger {
    VOD_TABMENU_TYPE,
    PROGRAM_TABMENU_TYPE
} TABMENU_TYPE;

static NSString* const autoCompletCell = @"autoCompletCell";
static NSString* const vodCellIdentifier = @"vodCell";
static NSString* const programCellIdentifier = @"programCell";

static NSString* const searchWordList = @"searchWordList";
static NSString* const searchWord = @"searchWord";

static NSString* const VodSearch_Item = @"VodSearch_Item";

static const CGFloat pageSize = 28;

@interface CMSearchMainViewController ()

@property (nonatomic, strong) IBOutlet CMTextField* searchField;
@property (nonatomic, strong) IBOutlet UILabel* infoLabel;
@property (nonatomic, strong) IBOutlet UITableView* autoCompletList;

@property (nonatomic, strong) CMTabMenuView* tabMenu;
@property (nonatomic, strong) IBOutlet UIView* tabMenuContainer;

@property (nonatomic, strong) IBOutlet UICollectionView* vodList;
@property (nonatomic, strong) IBOutlet UITableView* programList;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *topConstraint;

@property (nonatomic, strong) NSMutableArray* searchWordArray;   //  검색어 목록
@property (nonatomic, strong) NSMutableArray* dataArray;    //  vod/프로그램 목록

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger totalPage;

@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, strong) NSTimer* searchWordTimer;

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
    [self.autoCompletList registerNib:nib forCellReuseIdentifier:autoCompletCell];
    
    nib = [UINib nibWithNibName:@"CMSearchCollectionViewCell" bundle:nil];
    [self.vodList registerNib:nib forCellWithReuseIdentifier:vodCellIdentifier];
    
    nib = [UINib nibWithNibName:@"CMSearchTableViewCell" bundle:nil];
    [self.programList registerNib:nib forCellReuseIdentifier:programCellIdentifier];
    
    [self loadUI];
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

- (void)setListCount:(NSInteger)count {
    
    if (0 > count) {
        
        self.infoLabel.text = @"성인 콘텐츠를 검색하시려면\n 설정>성인검색 제한 설정을 해제 해주세요.";
    } else {
        
        self.infoLabel.text = [NSString stringWithFormat:@"총 %ld개의 검색결과가 있습니다." , count];
    }
}

- (void)resetData {
    
    self.pageIndex = 0;
    
    [self.searchWordArray removeAllObjects];
    [self.dataArray removeAllObjects];
    [self setListCount:0];
    [self.vodList reloadData];
    [self.programList reloadData];
}

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

- (void)requestSearchWord {
    
    self.searchWordTimer = nil;
    
    NSString* searchWord = [self.searchField.text trim];
    
    if (searchWord.length == 0) {
        return;
    }
    
    [NSMutableDictionary searchWordListWithSearchString:searchWord completion:^(NSArray *programs, NSError *error) {
        
        NSDictionary* response = programs[0];
        
        NSString* resultCode = response[CNM_OPEN_API_RESULT_CODE_KEY];
        if ([CNM_OPEN_API_RESULT_CODE_SUCCESS_KEY isEqualToString:resultCode] == false) {
            
            [self showAutoCompletList:NO];
            
            DDLogError(@"error : %@", response[CNM_OPEN_API_RESULT_ERROR_STRING_KEY]);
            
            return;
        }
        
        NSObject* itemObject = response[searchWordList];
        
        if ([itemObject isKindOfClass:[NSDictionary class]]) {
            [self.searchWordArray addObject:itemObject];
        } else if ([itemObject isKindOfClass:[NSArray class]]) {
            [self.searchWordArray addObjectsFromArray:(NSArray*)itemObject];
        }
     
        [self showAutoCompletList:YES];
    }];
}

- (void)requestVodList {
    
    self.isLoading = YES;
    
    NSString* searchWord = [self.searchField.text trim];
    
    if (searchWord.length == 0) {
        return;
    }
    
    [NSMutableDictionary vodSerchListWithSearchString:searchWord WithPageSize:pageSize WithPageIndex:self.pageIndex WithSortType:@"TitleAsc" completion:^(NSArray *programs, NSError *error) {
        
        self.isLoading = NO;
        
        NSDictionary* response = programs[0];
        
        NSString* resultCode = response[CNM_OPEN_API_RESULT_CODE_KEY];
        if ([CNM_OPEN_API_RESULT_CODE_SUCCESS_KEY isEqualToString:resultCode] == false) {
            
            [self.dataArray removeAllObjects];
            [self.vodList reloadData];
            
            DDLogError(@"error : %@", response[CNM_OPEN_API_RESULT_ERROR_STRING_KEY]);
            
            return;
        }
        
        self.totalPage = [(NSString*)response[CNM_OPEN_API_RESULT_TOTAL_PAGE] integerValue];
        
        NSString* totalCount = response[CNM_OPEN_API_RESULT_TOTAL_COUNT];
        [self setListCount:[totalCount integerValue]];
        
        NSObject* itemObject = response[VodSearch_Item];
        
        if ([itemObject isKindOfClass:[NSDictionary class]]) {
            [self.dataArray addObject:itemObject];
        } else if ([itemObject isKindOfClass:[NSArray class]]) {
            [self.dataArray addObjectsFromArray:(NSArray*)itemObject];
        }

        [self.vodList reloadData];
    }];
}

#pragma mark - Event

- (IBAction)buttonWasTouchUpInside:(id)sender {

    [self resetData];
    
    self.searchField.text = @"";
    [self.searchField becomeFirstResponder];
}

- (void)textMessageChanged:(CMTextField*)textField {
    
    [self showAutoCompletList:NO];
    
    if (self.searchWordTimer) {
        [self.searchWordTimer invalidate];
    }
    
    self.searchWordTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(requestSearchWord) userInfo:nil repeats:false];
}

#pragma mark - CMTabMenuViewDelegate

- (void)tabMenu:(CMTabMenuView *)sender didSelectedTab:(NSInteger)tabIndex {
    
    switch (tabIndex) {
        case VOD_TABMENU_TYPE: {
            self.vodList.hidden = false;
            
            //  table reset
            self.programList.hidden = true;
        }
            break;
        case PROGRAM_TABMENU_TYPE: {
            
            //  collection reset
            self.vodList.hidden = true;
            
            self.programList.hidden = false;
        }
            break;
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CMSearchCollectionViewCell* cell = (CMSearchCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:vodCellIdentifier forIndexPath:indexPath];

    NSDictionary* data = self.dataArray[indexPath.row];

    [cell setImageUrl:data[@"VOD_IMG"] title:data[@"VOD_Title"]];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.autoCompletList == tableView) {
        return self.searchWordArray.count;
    } else if (self.programList == tableView) {
        return 100;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.autoCompletList == tableView) {
        CMAutoCompletTableViewCell* cell = (CMAutoCompletTableViewCell*)[tableView dequeueReusableCellWithIdentifier:autoCompletCell];
        
        [cell setTitle:self.searchWordArray[indexPath.row][searchWord]];
        
        return cell;
    } else if (self.programList == tableView) {
        CMSearchTableViewCell* cell = (CMSearchTableViewCell*)[tableView dequeueReusableCellWithIdentifier:programCellIdentifier];
        
        [cell configureCellForItem:@{}];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

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
        
        self.searchField.text = self.searchWordArray[indexPath.row][searchWord];
        [self resetData];
        [self requestVodList];
        
        [self showAutoCompletList:NO];
    } else if (self.programList == tableView) {
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {

}

- (void)textFieldDidEndEditing:(UITextField *)textField {

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self resetData];
    
    TABMENU_TYPE type = [self.tabMenu getTabMenuIndex];
    switch (type) {
        case VOD_TABMENU_TYPE: {
            
            [self showAutoCompletList:NO];
            
            [self requestVodList];
        }
            break;
        case PROGRAM_TABMENU_TYPE: {
            
        }
            
        default:
            break;
    }
    
    return YES;
}

#pragma mark - UIScrollViewDelegate

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
            
        }
            break;
        default:
            break;
    }
}

@end
