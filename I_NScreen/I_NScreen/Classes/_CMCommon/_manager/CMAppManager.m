//
//  CMAppManager.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 8. 18..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "CMAppManager.h"
#import "LeftMenuViewController.h"

@implementation CMAppManager

+ (CMAppManager *)sharedInstance {
    static CMAppManager *sharedInstanced = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstanced = [[self alloc] init];
    });
    return sharedInstanced;
}

- (id)init {
    if (self = [super init]) {
        
        self.isFirst = [self isFirstLoading];
        if (self.isFirst) {
            [self defaultSetting];
        }

    }
    return self;
}

- (void)defaultSetting {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setAppType:CMAppTypePhone];
    [ud setRestrictType:CMContentsRestrictedTypeAdult];
    [ud synchronize];
}

- (BOOL)isFirstLoading {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL isFirst = [ud boolForKey:@"CMFirstApplicationLoading"];
    
    if (!isFirst) {
        [ud setBool:YES forKey:@"CMFirstApplicationLoading"];
    }
    
    return !isFirst;
}

#pragma mark -
- (void)onLeftMenuListOpen:(id)control;
{
    LeftMenuViewController *pViewController = [[LeftMenuViewController alloc] initWithNibName:@"LeftMenuViewController" bundle:nil];
    pViewController.delegate = control;
    
    [control addChildViewController:pViewController];
    [pViewController didMoveToParentViewController:control];
    [[control view] addSubview:pViewController.view];
    
    pViewController.view.frame = CGRectMake(-[control view].frame.size.width, 0, [control view].frame.size.width, [control view].frame.size.height);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    pViewController.view.frame = CGRectMake(0, 0, [control view].frame.size.width, [control view].frame.size.height);
    [UIView commitAnimations];

}

- (void)onLeftMenuListClose:(id)control;
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         [control view].frame = CGRectMake(-[control view].frame.size.width, 0, [control view].frame.size.width, [control view].frame.size.height);
                     } completion:^(BOOL finished) {
                         [[control view] removeFromSuperview];
                         [control willMoveToParentViewController:nil];
                         [control removeFromParentViewController];
                         
                         if ( [control respondsToSelector:@selector(onLeftMenuCloseComplet)])
                         {
                             [control onLeftMenuCloseComplet];
                         }
                     }];

}

#pragma mark - 디바이스 체크
- (NSString *)getDeviceCheck
{
    int nHeight = [UIScreen mainScreen].bounds.size.height;

    NSString *sVersion;
    
    if ( nHeight >= 736 )
    {
        // 6+
        sVersion = [NSString stringWithFormat:@"%@", IPHONE_RESOLUTION_6_PLUS];
    }
    else if ( nHeight < 736 && nHeight >= 667 )
    {
        // 6
        sVersion = [NSString stringWithFormat:@"%@", IPHONE_RESOLUTION_6];
    }
    else if ( nHeight < 667 && nHeight >= 568 )
    {
        // 5
        sVersion = [NSString stringWithFormat:@"%@", IPHONE_RESOLUTION_5];
    }
    else
    {
        // 4
        sVersion = [NSString stringWithFormat:@"%@", IPHONE_RESOLUTION_ELSE];
    }
    
    return sVersion;
}

#pragma mark -숫자에 , 삽입
-(NSString *)insertComma:(NSString *)data
{
    if([data isEqualToString:@"0"] || data == nil ||data.length == 0)
        return @"0";
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"];
    
    NSDecimalNumber *tfPriceChange = [NSDecimalNumber decimalNumberWithString:data];
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [currencyFormatter setLocale:locale];
    
    return [NSString stringWithFormat:@"%@", [currencyFormatter stringFromNumber:tfPriceChange]];
}

#pragma mark -숫자에 , 삭제
-(NSString *)deleteComma:(NSString *)data
{
    if([data isEqualToString:@"0"] || data == nil)
        return @"0";
    
    NSMutableString *strBuffer = [NSMutableString stringWithString:data];
    return [strBuffer stringByReplacingOccurrencesOfString:@"," withString:@""];
}


- (NSMutableArray *)getSearchWithArr:(NSMutableArray *)listArr WithSearchStr:(NSString *)searchStr WithKey:(NSString *)key
{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parentCategoryId LIKE[cd] %@",searchStr];
    NSMutableArray *filter =[[NSMutableArray alloc] init];
    filter = [[listArr filteredArrayUsingPredicate:predicate] mutableCopy];
    
    return filter;
}

#pragma mark - 트리 리스트 데이터 파싱
- (NSMutableDictionary *)getResponseTreeSplitWithData:(NSArray *)data WithCategoryIdSearch:(NSString *)categoryIdSearch
{
    NSMutableArray *fourDepthTreeListArr = [[NSMutableArray alloc] init];
    
    NSMutableArray *totalArr = [[NSMutableArray alloc] init];
    [totalArr setArray:[[[data objectAtIndex:0] objectForKey:@"categoryList"] objectForKey:@"category"]];
    
    for ( NSDictionary *twoDic in [self getSearchWithArr:totalArr WithSearchStr:categoryIdSearch WithKey:@"parentCategoryId"] )
    {
        NSString *sViewerType = [NSString stringWithFormat:@"%@", [twoDic objectForKey:@"viewerType"]];
        
        if ( ![sViewerType isEqualToString:@"60"] ) // 뷰 타입 60 제외
        {
            NSString *sTwoDepthLeaf = [NSString stringWithFormat:@"%@", [twoDic objectForKey:@"leaf"]];
            NSString *sCategoryId = [NSString stringWithFormat:@"%@", [twoDic objectForKey:@"categoryId"]];
            
            NSMutableDictionary *twoDepthDic = [[NSMutableDictionary alloc] init];
            [twoDepthDic setObject:[twoDic objectForKey:@"subCategoryPresentationType"] forKey:@"subCategoryPresentationType"];
            [twoDepthDic setObject:[twoDic objectForKey:@"categoryName"] forKey:@"categoryName"];
            [twoDepthDic setObject:[twoDic objectForKey:@"subCategoryVisible"] forKey:@"subCategoryVisible"];
            [twoDepthDic setObject:[twoDic objectForKey:@"menuType"] forKey:@"menuType"];
            [twoDepthDic setObject:[twoDic objectForKey:@"orientationType"] forKey:@"orientationType"];
            [twoDepthDic setObject:[twoDic objectForKey:@"adultCategory"] forKey:@"adultCategory"];
            [twoDepthDic setObject:[twoDic objectForKey:@"titlePresentationType"] forKey:@"titlePresentationType"];
            [twoDepthDic setObject:[twoDic objectForKey:@"packageDisplayPrice"] forKey:@"packageDisplayPrice"];
            [twoDepthDic setObject:[twoDic objectForKey:@"packageLink"] forKey:@"packageLink"];
            [twoDepthDic setObject:[twoDic objectForKey:@"subCategoryPcgView"] forKey:@"subCategoryPcgView"];
            [twoDepthDic setObject:[twoDic objectForKey:@"titleImage"] forKey:@"titleImage"];
            [twoDepthDic setObject:[twoDic objectForKey:@"viewerType"] forKey:@"viewerType"];
            [twoDepthDic setObject:[twoDic objectForKey:@"seriesLink"] forKey:@"seriesLink"];
            [twoDepthDic setObject:[twoDic objectForKey:@"vodType"] forKey:@"vodType"];
            [twoDepthDic setObject:[twoDic objectForKey:@"parentCategoryId"] forKey:@"parentCategoryId"];
            [twoDepthDic setObject:[twoDic objectForKey:@"leaf"] forKey:@"leaf"];
            [twoDepthDic setObject:[twoDic objectForKey:@"categoryId"] forKey:@"categoryId"];
            [twoDepthDic setObject:@"2" forKey:@"depth"];
            [twoDepthDic setObject:@"false" forKey:@"isOpen"];
            
            NSMutableArray *twoDepthSubData = [[NSMutableArray alloc] init];
            
            if ( [sTwoDepthLeaf isEqualToString:@"0"] )
            {
                
                // 서브 데이터 있음
                for ( NSDictionary *threeDic in [self getSearchWithArr:totalArr WithSearchStr:sCategoryId WithKey:@"parentCategoryId"] )
                {
                    NSString *sThreeDepthLeaf = [NSString stringWithFormat:@"%@", [threeDic objectForKey:@"leaf"]];
                    NSString *sThreeCategoryId = [NSString stringWithFormat:@"%@", [threeDic objectForKey:@"categoryId"]];
                    
                    NSMutableDictionary *threeDepthDic = [[NSMutableDictionary alloc] init];
                    [threeDepthDic setObject:[threeDic objectForKey:@"subCategoryPresentationType"] forKey:@"subCategoryPresentationType"];
                    [threeDepthDic setObject:[threeDic objectForKey:@"categoryName"] forKey:@"categoryName"];
                    [threeDepthDic setObject:[threeDic objectForKey:@"subCategoryVisible"] forKey:@"subCategoryVisible"];
                    [threeDepthDic setObject:[threeDic objectForKey:@"menuType"] forKey:@"menuType"];
                    [threeDepthDic setObject:[threeDic objectForKey:@"orientationType"] forKey:@"orientationType"];
                    [threeDepthDic setObject:[threeDic objectForKey:@"adultCategory"] forKey:@"adultCategory"];
                    [threeDepthDic setObject:[threeDic objectForKey:@"titlePresentationType"] forKey:@"titlePresentationType"];
                    [threeDepthDic setObject:[threeDic objectForKey:@"packageDisplayPrice"] forKey:@"packageDisplayPrice"];
                    [threeDepthDic setObject:[threeDic objectForKey:@"packageLink"] forKey:@"packageLink"];
                    [threeDepthDic setObject:[threeDic objectForKey:@"subCategoryPcgView"] forKey:@"subCategoryPcgView"];
                    [threeDepthDic setObject:[threeDic objectForKey:@"titleImage"] forKey:@"titleImage"];
                    [threeDepthDic setObject:[threeDic objectForKey:@"viewerType"] forKey:@"viewerType"];
                    [threeDepthDic setObject:[threeDic objectForKey:@"seriesLink"] forKey:@"seriesLink"];
                    [threeDepthDic setObject:[threeDic objectForKey:@"vodType"] forKey:@"vodType"];
                    [threeDepthDic setObject:[threeDic objectForKey:@"parentCategoryId"] forKey:@"parentCategoryId"];
                    [threeDepthDic setObject:[threeDic objectForKey:@"leaf"] forKey:@"leaf"];
                    [threeDepthDic setObject:[threeDic objectForKey:@"categoryId"] forKey:@"categoryId"];
                    [threeDepthDic setObject:@"3" forKey:@"depth"];
                    [threeDepthDic setObject:@"false" forKey:@"isOpen"];
                    
                    NSMutableArray *threeDepthSubData = [[NSMutableArray alloc] init];
                    
                    if ( [sThreeDepthLeaf isEqualToString:@"0"] )
                    {
                        // 서브 데이터 있음
                        
                        for ( NSDictionary *fourDic in [self getSearchWithArr:totalArr WithSearchStr:sThreeCategoryId WithKey:@"parentCategoryId"] )
                        {
                            NSMutableDictionary *fourDepthDic = [[NSMutableDictionary alloc] init];
                            [fourDepthDic setObject:[fourDic objectForKey:@"subCategoryPresentationType"] forKey:@"subCategoryPresentationType"];
                            [fourDepthDic setObject:[fourDic objectForKey:@"categoryName"] forKey:@"categoryName"];
                            [fourDepthDic setObject:[fourDic objectForKey:@"subCategoryVisible"] forKey:@"subCategoryVisible"];
                            [fourDepthDic setObject:[fourDic objectForKey:@"menuType"] forKey:@"menuType"];
                            [fourDepthDic setObject:[fourDic objectForKey:@"orientationType"] forKey:@"orientationType"];
                            [fourDepthDic setObject:[fourDic objectForKey:@"adultCategory"] forKey:@"adultCategory"];
                            [fourDepthDic setObject:[fourDic objectForKey:@"titlePresentationType"] forKey:@"titlePresentationType"];
                            [fourDepthDic setObject:[fourDic objectForKey:@"packageDisplayPrice"] forKey:@"packageDisplayPrice"];
                            [fourDepthDic setObject:[fourDic objectForKey:@"packageLink"] forKey:@"packageLink"];
                            [fourDepthDic setObject:[fourDic objectForKey:@"subCategoryPcgView"] forKey:@"subCategoryPcgView"];
                            [fourDepthDic setObject:[fourDic objectForKey:@"titleImage"] forKey:@"titleImage"];
                            [fourDepthDic setObject:[fourDic objectForKey:@"viewerType"] forKey:@"viewerType"];
                            [fourDepthDic setObject:[fourDic objectForKey:@"seriesLink"] forKey:@"seriesLink"];
                            [fourDepthDic setObject:[fourDic objectForKey:@"vodType"] forKey:@"vodType"];
                            [fourDepthDic setObject:[fourDic objectForKey:@"parentCategoryId"] forKey:@"parentCategoryId"];
                            [fourDepthDic setObject:[fourDic objectForKey:@"leaf"] forKey:@"leaf"];
                            [fourDepthDic setObject:[fourDic objectForKey:@"categoryId"] forKey:@"categoryId"];
                            [fourDepthDic setObject:@"4" forKey:@"depth"];
                            [fourDepthDic setObject:@"false" forKey:@"isOpen"];
                            NSMutableArray *fourDepthSubData = [[NSMutableArray alloc] init];
                            
                            // 4 댑스 까지만
                            [fourDepthDic setObject:fourDepthSubData forKey:@"subData"];
                            
                            [threeDepthSubData addObject:fourDepthDic];
                        }
                        
                        [threeDepthDic setObject:threeDepthSubData forKey:@"subData"];
                    }
                    else
                    {
                        // 서브 데이터 없음
                        [threeDepthDic setObject:threeDepthSubData forKey:@"subData"];
                    }
                    
                    [twoDepthSubData addObject:threeDepthDic];
                }
                
                [twoDepthDic setObject:twoDepthSubData forKey:@"subData"];
            }
            else
            {
                // 서브 데이터 없음
                [twoDepthDic setObject:twoDepthSubData forKey:@"subData"];
            }
            
            
            [fourDepthTreeListArr addObject:twoDepthDic];
        }
        
    }
    
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 2; i++) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"MySong", @"title",
                              @"MyArtist", @"artist",
                              nil];
        [arrayOfDicts addObject:dict];
    }
    
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    [dicInfo setObject:@"true" forKey:@"isOpen"];
    [dicInfo setObject:@"root" forKey:@"categoryName"];
    [dicInfo setObject:fourDepthTreeListArr forKey:@"subData"];
    
    
    return dicInfo;
}

@end
