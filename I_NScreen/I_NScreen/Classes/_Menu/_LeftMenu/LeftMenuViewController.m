//
//  LeftMenuViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 11..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "UIView+Layer.h"
#import "CMTermsViewController.h"
#import "CMVersionViewController.h"

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController
@synthesize delegate;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.upperView clearSubOutLineLayers];
    [self.bottomView clearSubOutLineLayers];
    
    [UIView setOuterLine:self.upperView direction:HMOuterLineDirectionTop|HMOuterLineDirectionBottom lineWeight:1 lineColor:[UIColor colorWithHexString:@"ffffff"]];
    [UIView setOuterLine:self.bottomView direction:HMOuterLineDirectionTop lineWeight:1 lineColor:[UIColor colorWithHexString:@"ffffff"]];

    CALayer* layer = nil;
    layer = self.pairingButton.layer;
    layer.cornerRadius = 4;
    
    layer = self.termsButton.layer;
    layer.cornerRadius = 4;
    
    layer = self.versionButton.layer;
    layer.cornerRadius = 4;
    
}


#pragma mark - 클릭 이벤트
#pragma mark - 버튼 클릭 이벤트
- (IBAction)onCloseBtnClick:(id)sender
{
    self.nTag = 0;
    
    [[CMAppManager sharedInstance] onLeftMenuListClose:self];
}
- (IBAction)actionTermsButton:(id)sender {
    CMTermsViewController *controller = [[CMTermsViewController alloc] initWithNibName:@"CMTermsViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)actionVersionButton:(id)sender {
    CMVersionViewController *controller = [[CMVersionViewController alloc] initWithNibName:@"CMVersionViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onLeftMenuCloseComplet
{
    if ( [self.delegate respondsToSelector:@selector(onLeftMenuViewCloseCompletReflash:)] )
    {
        [self.delegate onLeftMenuViewCloseCompletReflash:self.nTag];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
    }
  
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"EPG";
        }break;
        case 1:
        {
            cell.textLabel.text = @"PVR";
        }break;
        case 2:
        {
            cell.textLabel.text = @"검색";
        }break;
        case 3:
        {
            cell.textLabel.text = @"설정";
        }break;
        case 4:
        {
            cell.textLabel.text = @"마이 C&M";
        }break;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[CMAppManager sharedInstance] onLeftMenuListClose:self];
    
    self.nTag = (int)[indexPath row] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
