//
//  EpgMainViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 11..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "EpgMainViewController.h"

@interface EpgMainViewController ()

@end

@implementation EpgMainViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
     [self.pTableView registerClass:[EpgMainTableViewCell class] forCellReuseIdentifier:@"EpgMainTableViewCell"];
    
    [self setTagInit];
}

- (void)setTagInit
{
    self.pBackBtn.tag = EPG_MAIN_VIEW_BTN_TAG_01;
    self.pPopUpBtn.tag = EPG_MAIN_VIEW_BTN_TAG_02;
}

- (IBAction)onBtnClick:(UIButton *)btn;
{
    switch ([btn tag]) {
        case EPG_MAIN_VIEW_BTN_TAG_01:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }break;
        case EPG_MAIN_VIEW_BTN_TAG_02:
        {
            
        }break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EpgMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EpgMainTableViewCell" forIndexPath:indexPath];
    [cell setNeedsUpdateConstraints];
    
    
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
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
