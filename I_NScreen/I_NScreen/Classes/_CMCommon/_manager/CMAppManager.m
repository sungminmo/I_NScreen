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
    [ud setAdultCertYN:CMAdultCertificationNone];
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

- (void)setInfoDataKey:(NSString *)key Value:(id)value
{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:value forKey:key];
    [preferences synchronize];
}


- (void)setBoolDataKey:(NSString *)key Value:(BOOL)value
{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    [preferences setBool:value forKey:key];
    [preferences synchronize];
}

- (void)removeInfoDataKey:(NSString *)key
{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    [preferences removeObjectForKey:key];
    [preferences synchronize];
}

- (void)removeBoolDataKey:(NSString *)key
{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    [preferences removeObjectForKey:key];
    [preferences synchronize];
}

- (id)getInfoData:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (BOOL)getBoolData:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
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

#pragma mark - uuid 생성
- (NSString*) getUniqueUuid
{
    if([[NSUserDefaults standardUserDefaults] stringForKey:CNM_OPEN_API_UUID_KEY] == NULL){
        
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        
        NSString *string = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
        
        [[NSUserDefaults standardUserDefaults] setObject:string forKey:CNM_OPEN_API_UUID_KEY];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSString *uniqueid = [[NSUserDefaults standardUserDefaults] stringForKey:CNM_OPEN_API_UUID_KEY];
    
    NSLog(@"uuid : %@", uniqueid);
    
    return uniqueid;
}

#pragma mark - private 터미널 키가 없으면 public 터미널 키를 리턴
- (NSString *)getTerminalKeyCheck
{
    NSString *sTerminalKey = CNM_PUBLIC_TERMINAL_KEY;
    if ( [[CMAppManager sharedInstance] getInfoData:CNM_OPEN_API_PRIVATE_TERMINAL_KEY_KEY] != NULL )
    {
        sTerminalKey = [[CMAppManager sharedInstance] getInfoData:CNM_OPEN_API_PRIVATE_TERMINAL_KEY_KEY];
    }
    
    return sTerminalKey;
}

#pragma mark - 배열 검색
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

#pragma mark - 시간 splite ex) 2015-11-12 22:30:00 -> 22:30
- (NSString *)getSplitTimeWithDateStr:(NSString *)sDate
{
    NSArray *dateArr = [sDate componentsSeparatedByString:@" "];
    NSArray *dateArr2 = [[dateArr objectAtIndex:1] componentsSeparatedByString:@":"];
    
    NSString *sTime = [NSString stringWithFormat:@"%@:%@", [dateArr2 objectAtIndex:0], [dateArr2 objectAtIndex:1]];
    
    return sTime;
}

#pragma mark - 날짜 splite ex) 2015-11-12 21:00:00 -> 11월12일
- (NSString *)getSplitScrollWithDateStr:(NSString *)sDate
{
    NSArray *dateArr = [sDate componentsSeparatedByString:@" "];
    NSArray *dateArr2 = [[dateArr objectAtIndex:0] componentsSeparatedByString:@"-"];
    
    NSString *sDay = [NSString stringWithFormat:@"%@월%@일", [dateArr2 objectAtIndex:1], [dateArr2 objectAtIndex:2]];
    
    return sDay;
}

#pragma mark - 날짜 splite ex) 0000-00-03 00:00:00 -> 몇일 남았는지 몇시간 남았는지
- (NSString *)getSplitTermWithDateStr:(NSString *)sDate
{
    NSString *sViewablePeriod = @"";
    
    NSArray *dateArr = [sDate componentsSeparatedByString:@" "];
    NSArray *fDateArr = [[dateArr objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSArray *eDateArr = [[dateArr objectAtIndex:1] componentsSeparatedByString:@":"];
    
    NSString *sYear = [NSString stringWithFormat:@"%@", [fDateArr objectAtIndex:0]];
    NSString *sMonth = [NSString stringWithFormat:@"%@", [fDateArr objectAtIndex:1]];
    NSString *sDay = [NSString stringWithFormat:@"%@", [fDateArr objectAtIndex:2]];
    
    NSString *sHour = [NSString stringWithFormat:@"%@", [eDateArr objectAtIndex:0]];
    NSString *sMinute = [NSString stringWithFormat:@"%@", [eDateArr objectAtIndex:1]];
    NSString *sSecond = [NSString stringWithFormat:@"%@", [eDateArr objectAtIndex:2]];
    
    int nYear = [sYear intValue];
    int nMonth = [sMonth intValue];
    int nDay = [sDay intValue];
    
    int nHour = [sHour intValue];
    int nMinute = [sMinute intValue];
    int nSecond = [sSecond intValue];
    
    if ( nYear > 0 )
    {
        sViewablePeriod = [NSString stringWithFormat:@"%d년", nYear];
    }
    else
    {
        if ( nMonth > 0 )
        {
            sViewablePeriod = [NSString stringWithFormat:@"%d월", nMonth];
        }
        else
        {
            if ( nDay > 0 )
            {
                sViewablePeriod = [NSString stringWithFormat:@"%d일", nDay];
            }
            else
            {
                if ( nHour > 0 )
                {
                    sViewablePeriod = [NSString stringWithFormat:@"%d시", nHour];
                }
                else
                {
                    if ( nMinute > 0 )
                    {
                        sViewablePeriod = [NSString stringWithFormat:@"%d분", nMinute];
                    }
                    else
                    {
                        sViewablePeriod = [NSString stringWithFormat:@"%d초", nSecond];
                    }
                }
            }
        }
    }
    
    return sViewablePeriod;
}

#pragma mark - startTime 시작 시간 23:29 , endTime 끝시간 02:09
- (CGFloat)getProgressViewBufferWithStartTime:(NSString *)startTime WithEndTime:(NSString *)endTime
{
    NSArray *startArr = [startTime componentsSeparatedByString:@":"];
    NSArray *endArr = [endTime componentsSeparatedByString:@":"];
    
    NSString *sStartTime01 = [NSString stringWithFormat:@"%@", [startArr objectAtIndex:0]];
    NSString *sStartTime02 = [NSString stringWithFormat:@"%@", [startArr objectAtIndex:1]];
    
    NSString *sEndTime01 = [NSString stringWithFormat:@"%@", [endArr objectAtIndex:0]];
    NSString *sEndTime02 = [NSString stringWithFormat:@"%@", [endArr objectAtIndex:1]];
    
    int nStartTime01 = [sStartTime01 intValue];
    int nStartTime02 = [sStartTime02 intValue];
    
    int nEndTime01 = [sEndTime01 intValue];
    int nEndTime02 = [sEndTime02 intValue];
    
    int nStartTotal = nStartTime01 * 60 + nStartTime02;
    int nEndTotal = nEndTime01 * 60 + nEndTime02;
    
    int nFullTotal = 24 * 60;
    
    CGFloat nHap = 0;
    
    if ( nStartTotal > nEndTotal )
    {
        nHap = nFullTotal - nStartTotal + nEndTotal;
    }
    else
    {
        nHap = nEndTotal - nStartTotal;
    }

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Seoul"]];
    
    [dateFormatter setDateFormat:@"HH"];
    int nHour = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    [dateFormatter setDateFormat:@"mm"];
    int nMin = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    
    int nToday = nHour * 60 + nMin;
    CGFloat nToHap = 0;
    
    if ( nStartTotal > nToday )
    {
        nToHap = nFullTotal - nStartTotal + nToday;
    }
    else
    {
        nToHap = nToday - nStartTotal;
    }
    
    CGFloat nProgress = nToHap / nHap;
    
    if ( nProgress > 1 )
        nProgress = 1;
    
    if ( nStartTotal < nEndTotal )
    {
        if ( nStartTotal > nToday )
        {
            nProgress = 0;
        }
    }
    
    return nProgress;
}

#pragma mark -요일을 리턴한다.
- (NSString *)GetDayOfWeek:(NSString *)strDay
{
    int nDayFromYear = [[strDay substringWithRange:NSMakeRange(0, 4)] intValue];
    int nDayFromMohth = [[strDay substringWithRange:NSMakeRange(4, 2)] intValue];
    int nDayFromDay = [[strDay substringWithRange:NSMakeRange(6, 2)] intValue];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:nDayFromYear];
    [dateComponents setMonth:nDayFromMohth];
    [dateComponents setDay:nDayFromDay];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [gregorian dateFromComponents:dateComponents];
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    
    switch ([weekdayComponents weekday]) {
        case 1:
        {
            return @"일";
        }break;
        case 2:
        {
            return @"월";
        }break;
        case 3:
        {
            return @"화";
        }break;
        case 4:
        {
            return @"수";
        }break;
        case 5:
        {
            return @"목";
        }break;
        case 6:
        {
            return @"금";
        }break;
    }
    
    return @"토";
}

#pragma mark - 남은 시간 구하기 2015-11-10 23:59:59 -> 몇시간 남음
- (NSString *)getLicenseEndDate:(NSString *)endDate
{
    NSString *sComment = @"";
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Seoul"]];
    [dateFormatter setDateFormat:@"yyyy"];
    int year = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    [dateFormatter setDateFormat:@"MM"];
    int month = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    [dateFormatter setDateFormat:@"dd"];
    int day = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    [dateFormatter setDateFormat:@"HH"];
    int hour = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    [dateFormatter setDateFormat:@"mm"];
    int min = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    [dateFormatter setDateFormat:@"ss"];
    int sec = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    
    NSArray *endArr = [endDate componentsSeparatedByString:@" "];
    NSArray *endArr2 = [[endArr objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSArray *endArr3 = [[endArr objectAtIndex:1] componentsSeparatedByString:@":"];
    
    NSString *sEndYear = [NSString stringWithFormat:@"%@", [endArr2 objectAtIndex:0]];
    NSString *sEndMonth = [NSString stringWithFormat:@"%@", [endArr2 objectAtIndex:1]];
    NSString *sEndDay = [NSString stringWithFormat:@"%@", [endArr2 objectAtIndex:2]];
    
    NSString *sEndHour = [NSString stringWithFormat:@"%@", [endArr3 objectAtIndex:0]];
    NSString *sEndMin = [NSString stringWithFormat:@"%@", [endArr3 objectAtIndex:1]];
    NSString *sEndSec = [NSString stringWithFormat:@"%@", [endArr3 objectAtIndex:2]];
    
    int nEndYear = [sEndYear intValue];
    int nEndMonth = [sEndMonth intValue];
    int nEndDay = [sEndDay intValue];
    int nEndHour = [sEndHour intValue];
    int nEndMin = [sEndMin intValue];
    int nEndSec = [sEndSec intValue];
    
    if ( nEndYear > year )
    {
        sComment = [NSString stringWithFormat:@"%d년 남음", nEndYear - year];
    }
    else
    {
        if ( nEndMonth > month )
        {
            sComment = [NSString stringWithFormat:@"%d월 남음", nEndMonth - month];
        }
        else
        {
            if ( nEndDay > day )
            {
                sComment = [NSString stringWithFormat:@"%d일 남음", nEndDay - day];
            }
            else
            {
                if ( nEndHour > hour )
                {
                    sComment = [NSString stringWithFormat:@"%d시간 남음", nEndHour - hour];
                }
                else
                {
                    if ( nEndMin > min )
                    {
                        sComment = [NSString stringWithFormat:@"%d분 남음", nEndMin - min];
                    }
                    else
                    {
                        sComment = [NSString stringWithFormat:@"%d초 남음", nEndSec - sec];
                    }
                }
            }
        }
    }
    
    
    return sComment;
}

@end
