//
//  CMRegionSettingViewController.m
//  I_NScreen
//
//  Created by kimts on 2015. 10. 9..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMRegionSettingViewController.h"

typedef enum : NSInteger {
    TAG_CANCEL = 10000000,
    TAG_COMPLETE
} ButtonsInRegionSetting;

static NSString* const CellIdentifier = @"regionSettingCell";

@interface CMRegionSettingViewController ()

@property (nonatomic, strong) IBOutlet UILabel* resionLabel;
@property (nonatomic, strong) IBOutlet UITableView* tableView;
@property (nonatomic, strong) IBOutlet UIButton* cancelButton;
@property (nonatomic, strong) IBOutlet UIButton* completeButton;

@property (nonatomic, strong) NSMutableArray* resionData;

@end

@implementation CMRegionSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //  test
    self.resionData = [@[@"노원구", @"마포구", @"동대문구", @"서대문구", @"서초구", @"성북구", @"성동구"] mutableCopy];
    
    [self setPresentResionLabel:@"호호호호호"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

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
            
        }
            break;
        case TAG_COMPLETE: {
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITablevewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.resionData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        
        UIView* lineView = [[UIView alloc] init];
        lineView.backgroundColor = [CMColor colorTableSeparator];
        lineView.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:lineView];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(lineView);
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[lineView]-0-|" options:0 metrics:nil views:views]];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lineView]-0-|" options:0 metrics:nil views:views]];
    }
    
    cell.textLabel.text = self.resionData[indexPath.row];
    
    return cell;
}

#pragma mark - UITableVewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
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
