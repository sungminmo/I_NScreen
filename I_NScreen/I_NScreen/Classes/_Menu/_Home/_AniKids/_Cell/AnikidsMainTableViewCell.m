//
//  AnikidsMainTableViewCell.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 23..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "AnikidsMainTableViewCell.h"

@implementation AnikidsMainTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setListData:(NSArray *)arr WithIndex:(int)index WithViewerType:(NSString *)viewerType
{
    self.pAssetIdArr = [[NSMutableArray alloc] init];
    
    self.nIndex = index;
    
    int nIndexs = 0;
    for ( NSDictionary *dic in arr )
    {
        switch (nIndexs) {
            case 0:
            {
                self.pView01.hidden = NO;
                
            }break;
            case 1:
            {
                self.pView02.hidden = NO;
                
            }break;
            case 2:
            {
                self.pView03.hidden = NO;
                
            }break;
            case 3:
            {
                self.pView04.hidden = NO;
                
            }break;
        }
        
        NSString *sAsset = [NSString stringWithFormat:@"%@", [[arr objectAtIndex:nIndexs] objectForKey:@"assetId"]];
        [self.pAssetIdArr addObject:sAsset];
        
        nIndexs++;
    }

    
    int nCount = (int)[arr count];
    
    if ( [viewerType isEqualToString:@"200"] )
    {
        // 인기순위
        for ( int i = 0; i < nCount; i++ )
        {
            switch (i) {
                case 0:
                {
                    self.pTitleLbl01.text = [NSString stringWithFormat:@"%@", [[arr objectAtIndex:i] objectForKey:@"title"]];
                }break;
                case 1:
                {
                    self.pTitleLbl02.text = [NSString stringWithFormat:@"%@", [[arr objectAtIndex:i] objectForKey:@"title"]];
                }break;
                case 2:
                {
                    self.pTitleLbl03.text = [NSString stringWithFormat:@"%@", [[arr objectAtIndex:i] objectForKey:@"title"]];
                }break;
                case 3:
                {
                    self.pTitleLbl04.text = [NSString stringWithFormat:@"%@", [[arr objectAtIndex:i] objectForKey:@"title"]];
                }break;
            }
        }
    }
    
    
}

- (IBAction)onBtnClicked:(UIButton *)btn
{
    [self.delegate AnikidsMainTableViewCellBtnClicked:(int)[btn tag] WithSelect:self.nIndex WithAssetId:[self.pAssetIdArr objectAtIndex:[btn tag]]];
}

@end
