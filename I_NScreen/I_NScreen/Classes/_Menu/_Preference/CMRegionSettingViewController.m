//
//  CMRegionSettingViewController.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 10. 9..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMRegionSettingViewController.h"
#import "NSMutableDictionary+EPG.h"
#import "CMDBDataManager.h"

typedef enum : NSInteger {
    TAG_CANCEL = 10000000,
    TAG_COMPLETE
} ButtonsInRegionSetting;

typedef enum : NSInteger {
    TAG_REGION_LABEL_IN_CELL = 11000000,
    TAG_CHECK_IMAGE_IN_CELL
} ItemInRegionSetting;

static NSString* const CellIdentifier = @"regionSettingCell";

@interface CMRegionSettingViewController ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topConstraint;
@property (nonatomic, weak) IBOutlet UILabel* resionLabel;
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, weak) IBOutlet UIButton* cancelButton;
@property (nonatomic, weak) IBOutlet UIButton* completeButton;

@property (nonatomic, strong) NSMutableArray* regionData;

//  test
@property (nonatomic, assign) NSInteger selectedIdx;

@end

@implementation CMRegionSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"지역설정";
    self.isUseNavigationBar = YES;
    self.topConstraint.constant = cmNavigationHeight;
    
    self.cancelButton.tag = TAG_CANCEL;
    self.completeButton.tag = TAG_COMPLETE;
    
    //  test
//    self.regionData = [@[@"노원구", @"마포구", @"동대문구", @"서대문구", @"서초구", @"성북구", @"성동구", @"가나다라마바사아차카"] mutableCopy];
//    self.selectedIdx = 0;
    self.regionData = [@[] mutableCopy];
    [self loadAreaList];
}

- (void)loadAreaList {
    [NSMutableDictionary epgGetChannelAreaCompletion:^(NSArray *epgs, NSError *error) {
        id obj = [epgs valueForKeyPath:@"areaItem"];
        if ([obj isKindOfClass:[NSArray class]]) {
            [self.regionData addObjectsFromArray:[(NSArray*)obj copy]];
        }
        else {
            [self.regionData addObject:(NSDictionary*)obj];
        }

        DDLogInfo(@"%@", [obj description]);
        [self loadSelectedRegion];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
- (void)loadSelectedRegion {
    CMDBDataManager* manager = [CMDBDataManager sharedInstance];
    CMAreaInfo* info = [manager currentAreaInfo];
    
    NSPredicate* p = [NSPredicate predicateWithFormat:@"areaCode == %@", info.areaCode];
    NSArray* rs = [self.regionData filteredArrayUsingPredicate:p];
    if (rs.count > 0) {
        self.selectedIdx = [self.regionData indexOfObject:rs.lastObject];
    }
    
    [self selectRegionAtIndex:self.selectedIdx];
}


- (void)selectRegionAtIndex:(NSInteger)index {

    if (index > self.regionData.count - 1) {
        return;
    }
    
    self.selectedIdx = index;
    
    [self setPresentResionLabel:self.regionData[index][@"areaName"]];
    [self.tableView reloadData];
}

- (void)setPresentResionLabel:(NSString*)region {
    NSString* fixedText = @"현재지역설정 :";
    NSString* desc = [NSString stringWithFormat:@"%@ %@", fixedText, region];
    self.resionLabel.text = desc;
    

    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.resionLabel.attributedText];
    NSRange range = NSMakeRange(fixedText.length, region.length + 1);
    [attributedText addAttributes:@{NSForegroundColorAttributeName : [CMColor colorViolet]} range:range];
    
    self.resionLabel.attributedText = attributedText;
}

#pragma mark - Event 

- (IBAction)buttonWasTouchUpInside:(id)sender {
    NSInteger tag = ((UIButton*)sender).tag;
    
    switch (tag) {
        case TAG_CANCEL: {
            [self backCommonAction];
        }
            break;
        case TAG_COMPLETE: {
            
            NSDictionary* areaItem = self.regionData[self.selectedIdx];
            if (areaItem != nil) {
                CMDBDataManager* manager = [CMDBDataManager sharedInstance];
                [manager saveAreaCode:areaItem[@"areaCode"] name:areaItem[@"areaName"]];
            }
            [self backCommonAction];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITablevewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.regionData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        
        UILabel* regionlabel = [[UILabel alloc] init];
        regionlabel.translatesAutoresizingMaskIntoConstraints = NO;
        regionlabel.tag = TAG_REGION_LABEL_IN_CELL;
        [cell.contentView addSubview:regionlabel];

        NSDictionary * views = @{@"contentView":cell.contentView, @"regionlabel":regionlabel};
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[contentView]-(<=0)-[regionlabel(==contentView)]"
                                                                                 options:NSLayoutFormatAlignAllCenterX
                                                                                 metrics:nil views:views]];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[contentView]-(<=0)-[regionlabel]"
                                                                                 options:NSLayoutFormatAlignAllCenterY
                                                                                 metrics:nil views:views]];
        
        UIImageView* checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_check.png"]];
        checkImageView.translatesAutoresizingMaskIntoConstraints = NO;
        checkImageView.tag = TAG_CHECK_IMAGE_IN_CELL;
        [cell.contentView addSubview:checkImageView];
        
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[regionlabel]-8-[checkImageView]"
                                                                                 options:NSLayoutFormatAlignAllCenterY
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(regionlabel, checkImageView)]];
        
        UIView* lineView = [[UIView alloc] init];
        lineView.translatesAutoresizingMaskIntoConstraints = NO;
        lineView.backgroundColor = [CMColor colorTableSeparator];
        [cell.contentView addSubview:lineView];
        
        views = NSDictionaryOfVariableBindings(lineView);
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[lineView]|" options:0 metrics:nil views:views]];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lineView(==1)]|" options:0 metrics:nil views:views]];
    }

    UILabel* regionLabel = (UILabel*)[cell.contentView viewWithTag:TAG_REGION_LABEL_IN_CELL];
    UIImageView* checkImageView = (UIImageView*)[cell.contentView viewWithTag:TAG_CHECK_IMAGE_IN_CELL];
    
    regionLabel.text = self.regionData[indexPath.row][@"areaName"];
    
    if (self.selectedIdx == indexPath.row) {
        checkImageView.hidden = NO;
    } else {
        checkImageView.hidden = YES;
    }

    return cell;
}

#pragma mark - UITableVewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (self.selectedIdx == indexPath.row) {
        return;
    }
    
    [self selectRegionAtIndex:indexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [CMColor colorViolet];
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor blackColor];
}

@end
