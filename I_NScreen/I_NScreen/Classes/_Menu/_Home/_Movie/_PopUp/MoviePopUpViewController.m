//
//  MoviePopUpViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "MoviePopUpViewController.h"

@interface MoviePopUpViewController ()

@end

@implementation MoviePopUpViewController
@synthesize pModel;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"contents" ofType:@"json"];
    
    self.pModel = [[TreeListModel alloc] initWithJSONFilePath:filePath];
    
    [self.pTableView reloadData];
}


// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pModel.cellCount;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *pCellIn = @"MoviePopUpTableViewCellIn";
    
    MoviePopUpTableViewCell *pCell = (MoviePopUpTableViewCell *)[tableView dequeueReusableCellWithIdentifier:pCellIn];
    
    if (pCell == nil)
    {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MoviePopUpTableViewCell" owner:nil options:nil];
        pCell = [arr objectAtIndex:0];
    }
    
    [pCell setSelectionStyle:UITableViewCellSelectionStyleNone];

    
    NSMutableDictionary *item = [self.pModel itemForRowAtIndexPath:indexPath];
    
    BOOL isOpen = [self.pModel isCellOpenForRowAtIndexPath:indexPath];

    [pCell setListData:item WithIndex:(int)indexPath.row WithOpen:isOpen];
    return pCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *item = [self.pModel itemForRowAtIndexPath:indexPath];
    int item_count = [[item valueForKeyPath:@"value.@count"] intValue];
    if (item_count<=0)
        return;
    
    BOOL newState = NO;
    BOOL isOpen = [self.pModel isCellOpenForRowAtIndexPath:indexPath];
    if (NO == isOpen) {
        newState = YES;
    } else {
        newState = NO;
    }
    [self.pModel setOpenClose:newState forRowAtIndexPath:indexPath];
    
    [tableView beginUpdates];
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
             withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
}

@end
