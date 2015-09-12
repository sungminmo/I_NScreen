//
//  LeftMenuViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 11..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "LeftMenuViewController.h"

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController
@synthesize delegate;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - 클릭 이벤트
#pragma mark - 버튼 클릭 이벤트
- (IBAction)onCloseBtnClick:(id)sender
{
    self.nTag = 0;
    
    [[CMAppManager sharedInstance] onLeftMenuListClose:self];
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
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[CMAppManager sharedInstance] onLeftMenuListClose:self];
    
    self.nTag = (int)[indexPath row] + 1;
    
    switch ([indexPath row]) {
        case 0:
        {
            
        }break;
        case 1:
        {
            
        }break;
        case 2:
        {
            
        }break;
        case 3:
        {
            
        }break;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 84;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
