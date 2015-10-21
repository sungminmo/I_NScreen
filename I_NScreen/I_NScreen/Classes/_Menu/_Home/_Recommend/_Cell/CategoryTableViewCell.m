//
//  CategoryTableViewCell.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 20..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CategoryTableViewCell.h"

@implementation CategoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index
{
    [self banPageControllerInit];
}

#pragma mark - 배너
#pragma mark - 배너 페이지 컨트롤 초기화
- (void)banPageControllerInit
{
    // 하드코딩 토탈 카운터 3개만 하자
    NSMutableArray *pControllers = [[NSMutableArray alloc] init];
    
    int nTotalCount = 3;
    
    for ( NSUInteger i = 0; i < nTotalCount; i++ )
    {
        [pControllers addObject:[NSNull null]];
    }
    
    self.pViewController = pControllers;
    
    self.pPageCtrl.numberOfPages = nTotalCount;
    self.pPageCtrl.currentPage = 0;
    
    self.pScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.pScrollView.frame) * nTotalCount, CGRectGetHeight(self.pScrollView.frame));
    self.pScrollView.pagingEnabled = YES;
    self.pScrollView.showsHorizontalScrollIndicator = NO;
    self.pScrollView.showsVerticalScrollIndicator = NO;
    self.pScrollView.scrollsToTop = NO;
    self.pScrollView.delegate = self;
    int nWith = [UIScreen mainScreen].bounds.size.width;
    self.pScrollView.frame = CGRectMake(6, 10, nWith - 12, 100);
    self.pScrollView.backgroundColor = [UIColor redColor];
    
    [self banLoadScrollViewWithPage:0];
    [self banLoadScrollViewWithPage:1];
}

#pragma mark - 배너 페이지 전환
- (void)banLoadScrollViewWithPage:(NSInteger )page
{
    int nTotalCount = 3;
    
    // 초기값 리턴
    if ( page >= nTotalCount || page < 0 )
        return;
    
    CMPageCollectionViewController *controller = [self.pViewController objectAtIndex:page];
    
    if ( (NSNull *)controller == [NSNull null] )
    {
//        CGRect rect = self.pScrollView.frame;
        
        controller = [[CMPageCollectionViewController alloc] initWithData:nil WithPage:(int)page];
        controller.delegate = self;
        [self.pViewController replaceObjectAtIndex:page withObject:controller];
    }
    
    if ( [controller.view superview] == nil )
    {
        CGRect frame = self.pScrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        [self.pScrollView addSubview:controller.view];
    }
}

#pragma mark - UIScrollView 델리게이트
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ( scrollView == self.pScrollView )
    {
        CGFloat pageWidth = CGRectGetWidth(self.pScrollView.frame);
        NSUInteger page = floor((self.pScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.pPageCtrl.currentPage = page;
        
        [self banLoadScrollViewWithPage:page - 1];
        [self banLoadScrollViewWithPage:page];
        [self banLoadScrollViewWithPage:page + 1];
    }
}


@end
