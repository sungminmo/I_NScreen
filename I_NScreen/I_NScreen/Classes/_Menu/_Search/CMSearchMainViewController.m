//
//  CMSearchMainViewController.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 9. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMSearchMainViewController.h"
#import "CMSearchCollectionViewCell.h"
#import "CMConstants.h"

typedef enum : NSInteger {
    VOD_TABMENU_TYPE,
    PROGRAM_TABMENU_TYPE
} TABMENU_TYPE;

static NSString* const vodCellIdentifier = @"vodCell";
static NSString* const programCellIdentifier = @"programCell";

@interface CMSearchMainViewController ()

@property (nonatomic, strong) CMTabMenuView* tabMenu;
@property (nonatomic, strong) IBOutlet UIView* tabMenuContainer;

@property (nonatomic, strong) IBOutlet UICollectionView* vodList;
@property (nonatomic, strong) IBOutlet UITableView* programList;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (nonatomic, strong) NSMutableArray* dataArray;

@end

@implementation CMSearchMainViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"검색";
    self.isUseNavigationBar = YES;
    self.topConstraint.constant = cmNavigationHeight;
    
    self.dataArray = [@[] mutableCopy];
    
    //  test
    for (int i = 0; i < 100; i++) {
        [self.dataArray addObject:@{@"image":@"testimg.png", @"title":@"포켓몬스터"}];
    }
    
    UINib* nib = [UINib nibWithNibName:@"CMSearchCollectionViewCell" bundle:nil];
    [self.vodList registerNib:nib forCellWithReuseIdentifier:vodCellIdentifier];
    
    [self loadUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)loadUI {
    self.tabMenu = [[CMTabMenuView alloc] initWithMenuArray:@[@"VOD 명 검색", @"프로그램 명 검색"] posY:0 delegate:self];
    [self.tabMenuContainer addSubview:self.tabMenu];
    
    self.vodList.hidden = false;
    self.programList.hidden = true;
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
    [cell setImageUrl:data[@"image"] title:data[@"title"]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:programCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:programCellIdentifier];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
