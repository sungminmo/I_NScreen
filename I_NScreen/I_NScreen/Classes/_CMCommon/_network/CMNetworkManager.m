//
//  CMNetworkManager.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 8. 18..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "CMNetworkManager.h"
#import "XMLDictionary.h"
#import "UIActivityIndicatorView+AFNetworking.h"
#import "CMDBDataManager.h"

@implementation CMDRMServerClient

@end

@implementation CMSMAppServerClient

@end

@implementation CMSMAppServerClientVPN

@end

@implementation CMWebHasServerClient

@end

@implementation CMRUMPUSServerClient

@end

@implementation CMRUMPUSServerClientVPN

@end

@implementation CMAirCodeServerClient

@end

@interface CMNetworkManager() <NSXMLParserDelegate>

@property (nonatomic, strong) NSString* alreadyIndicatorKey;
@property (nonatomic, unsafe_unretained) BOOL isUsingIndicator;
@property (nonatomic, strong) UIActivityIndicatorView* indicator;

/**
 C&M SMApplicationServer의 openAPI를 사용하기 위한 NSURL 타입의 URL 반환한다.
 
 @param interface C&M SMApplicationServer의 openAPI의 인터페이스.
 @return NSURL 타입의 URL 반환.
 */
+ (NSURL *)genURLWithInterface:(NSString *)interface;

/**
 네이버의 검색API를 사용하기 위한 NSURL 타입의 URL 반환한다.
 
 @param query 검색 키워드.
 @return NSURL 타입의 URL 반환.
 */
+ (NSURL *)genURLWithQuery:(NSString *)query;

/**
 NSString 타입의 쿼리스트링 반환한다.
 
 @param dict 쿼리스트링을 생성할 파라미터 목록.
 @return NSString 타입의 쿼리스트링 반환.
 */
+ (NSString *)genQueryStringWithDictionary:(NSDictionary *)dict;

+ (NSString *)genParameter:(NSString *)key andValue:(NSString *)value;
@end


@implementation CMNetworkManager

+ (CMNetworkManager *)sharedInstance {
    static CMNetworkManager *sharedInstanced = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstanced = [[self alloc] init];
    });
    return sharedInstanced;
}

- (id)init {
    if (self = [super init]) {
        
        [self settingActivityIndicator];
        
        self.drmClient = [[CMDRMServerClient alloc] initWithBaseURL:[NSURL URLWithString:DRM_OPEN_API_SERVER_URL]];
        self.drmClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        self.smClient = [[CMSMAppServerClient alloc] initWithBaseURL:[NSURL URLWithString:CNM_OPEN_API_SERVER_URL]];
        self.smClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        self.smClientVpn = [[CMSMAppServerClientVPN alloc] initWithBaseURL:[NSURL URLWithString:CNM_OPEN_API_SERVER_URL_VPN]];
        self.smClientVpn.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        self.webClient = [[CMWebHasServerClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        self.webClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        self.rumClient = [[CMRUMPUSServerClient alloc] initWithBaseURL:[NSURL URLWithString:CNM_RUMPUS_OPEN_API_SERVER_URL]];
        self.rumClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        self.rumClientVpn = [[CMRUMPUSServerClientVPN alloc] initWithBaseURL:[NSURL URLWithString:CNM_RUMPUS_OPEN_API_SERVER_URL_VPN]];
        self.rumClientVpn.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        self.acodeClient = [[CMAirCodeServerClient alloc] initWithBaseURL:[NSURL URLWithString:CNM_AIRCODE_OPEN_API_SERVER_URL]];
        self.acodeClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];

        
    }
    return self;
}

- (void)settingActivityIndicator {
    UIActivityIndicatorView* IndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 40, [UIScreen mainScreen].bounds.size.height/2 - 40, 80, 80)];
    IndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    IndicatorView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    IndicatorView.color = [UIColor whiteColor];
    IndicatorView.layer.cornerRadius = 5;
    IndicatorView.layer.masksToBounds = YES;
    IndicatorView.tag = 1999;
    self.indicator = IndicatorView;
    self.indicator.hidesWhenStopped = YES;
}

- (void)updateActivityIndicator:(NSURLSessionTask*)task {
    UIWindow* window = [[UIApplication sharedApplication] delegate].window;
    if (self.isUsingIndicator == YES) {
        [self.indicator removeFromSuperview];
        self.isUsingIndicator = NO;
    }
    self.indicator.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 40, [UIScreen mainScreen].bounds.size.height/2 - 40, 80, 80);
    [window addSubview:self.indicator];
    [self.indicator setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.indicator setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin];
    [self.indicator setAnimatingWithStateOfTask:task];
    self.isUsingIndicator = YES;
    
    return;
    
//    UIWindow* window = [[UIApplication sharedApplication] delegate].window;
//    UINavigationController* navigationController = (UINavigationController* )window.rootViewController;
//    NSArray* viewControllers = navigationController.viewControllers;
//    UIViewController* topController = viewControllers.firstObject;
//    UIView* view = topController.view;
//    NSString* key = NSStringFromClass([topController class]);
//    if (key == nil) {
//        return;
//    }
//    
//    if (self.alreadyIndicatorKey != nil) {
//
//        if ([self.alreadyIndicatorKey isEqualToString:key]) {
//            return;
//        }
//        
//        [self.indicator removeFromSuperview];
//        self.alreadyIndicatorKey = nil;
//    }
//
//    [view addSubview:self.indicator];
//    [self.indicator setTranslatesAutoresizingMaskIntoConstraints:YES];
//    [self.indicator setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin];
//    self.alreadyIndicatorKey = NSStringFromClass([topController class]);
}

#pragma mar - from CMGenerator
+ (NSURL *)genURLWithInterface:(NSString *)interface
{
//    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.asp", CNM_OPEN_API_SERVER_URL, interface]];
//    return [NSURL URLWithString:[NSString stringWithFormat:@"%@.asp", interface]];
    // Add By BJK
     return [NSURL URLWithString:[NSString stringWithFormat:@"%@.xml", interface]];
}

// TODO: UI에서 페이징 처리 결정해야 함!
+ (NSURL *)genURLWithQuery:(NSString *)query
{
    // !!!: query는 UTF-8 인코딩.
    NSDictionary *dict = @{
                           @"key" : NAVER_SEARCH_API_KEY,
                           @"target" : @"webkr",
                           @"query" : [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           @"start" : @"1",
                           @"display" : @"10"
                           };
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", NAVER_SEARCH_API_SERVER_URL, [self genQueryStringWithDictionary:dict]]];
}

+ (NSString *)genParameter:(NSString *)key andValue:(NSString *)value
{
    NSString *element = [NSString stringWithFormat:@"%@=%@&", key, value];
    
    return element;
}

+ (NSString *)genQueryStringWithDictionary:(NSDictionary *)dict
{
    NSMutableString *queryString = [NSMutableString string];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [queryString appendString:[self genParameter:key andValue:obj]];
    }];
    
    return queryString;
}

#pragma mark - 



@end

@implementation CMNetworkManager(SEARCH)

- (NSURLSessionDataTask *)searchProgram:(NSString *)keyword block:(void (^)(NSArray *posts, NSError *error))block {
    
    self.smClient.responseSerializer = [AFJSONResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/json", @"text/javascript"]];
    
    NSURL *url = [CMNetworkManager genURLWithInterface:CNM_OPEN_API_INTERFACE_SearchProgram];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : @""/*[CMHTTPClient sharedCMHTTPClient].terminalKey*/,
                           CNM_OPEN_API_TRANSACTION_ID_KEY : @"0",
                           @"areaCode" : CNM_DEFAULT_AREA_CODE,
                           @"productCode" : CNM_DEFAULT_PRODUCT_CODE,
                           @"pageSize" : @"0",
                           @"pageIndex" : @"0",
                           @"Search_String" : [keyword stringByUrlEncoding]
                           };
    
    NSURLSessionDataTask *task = [self.smClient POST:url parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        //1차로 예외처리 및 공통처리할 때 사용.
        NSArray *response = [responseObject valueForKeyPath:@"data"];
        NSMutableArray *programs = [NSMutableArray arrayWithCapacity:[response count]];
        for (NSDictionary *item in response) {
        }
        if (block) {
            block([NSArray arrayWithArray:programs], nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
    [self updateActivityIndicator:task];
    return task;
}

- (NSURLSessionDataTask *)programSearchListWithSearchString:(NSString *)searchString WithPageSize:(NSInteger)pageSize WithPageIndex:(NSInteger)pageIndex WithAreaCode:(NSString *)areaCode WithProductCode:(NSString *)productCode completion:(void (^)(NSArray *programs, NSError *error))block {
    
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_SearchProgram];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : CNM_REAL_TEST_TERMINAL_KEY,
                           @"Search_String" : searchString,
                           @"pageSize" : @(pageSize),
                           @"pageIndex" : @(pageIndex),
                           @"areaCode" : areaCode,
                           @"productCode" : productCode
                           };
    
    NSURLSessionDataTask *task = [self.rumClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

- (NSURLSessionDataTask *)programScheduleListWithSearchString:(NSString *)searchString WithPageSize:(NSInteger)pageSize WithPageIndex:(NSInteger)pageIndex WithAreaCode:(NSString *)areaCode completion:(void (^)(NSArray *programs, NSError *error))block {
    
    self.acodeClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.acodeClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_SearchSchedule];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : CNM_REAL_TEST_TERMINAL_KEY,
                           @"searchString" : searchString,
//                           @"limit" : @(pageSize),
//                           @"offset" : @(pageIndex),
                           @"areaCode" : areaCode
                           };
    
    return [self.acodeClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}


- (NSURLSessionDataTask *)epgSearchChannelListWithSearchString:(NSString *)searchString WithPageSize:(NSString *)pageSize WithPageIndex:(NSString *)pageIndex WithSortType:(NSString *)sortType block:(void (^)(NSArray *, NSError *))block
{
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_SearchChannel];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : CNM_REAL_TEST_TERMINAL_KEY,
                           @"Search_String" : searchString,
                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex,
                           @"sortType" : sortType
                           };
    
    NSURLSessionDataTask *task = [self.rumClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

- (NSURLSessionDataTask *)vodSerchListWithSearchString:(NSString *)searchString WithPageSize:(NSInteger)pageSize WithPageIndex:(NSInteger)pageIndex WithSortType:(NSString *)sortType completion:(void (^)(NSArray *gets, NSError *error))block
{
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_SearchVod];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : CNM_REAL_TEST_TERMINAL_KEY,
                           @"Search_String" : searchString,
                           @"pageSize" : @(pageSize),
                           @"pageIndex" : @(pageIndex),
                           @"sortType" : sortType
                           };
    
    NSURLSessionDataTask *task = [self.rumClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

- (NSURLSessionDataTask *)searchWordListWithSearchString:(NSString*)searchString WithIncludeAdultCategory:(NSString *)adultCategory completion:(void (^)(NSArray *gets, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_getSearchWord];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : CNM_REAL_TEST_TERMINAL_KEY,
                           @"searchKeyword" : searchString,
                           @"includeAdultCategory" : adultCategory
                           };
    
    NSURLSessionDataTask *task = [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        block(nil, error);
    }];
//    [self updateActivityIndicator:task];
    return task;
}


- (NSURLSessionDataTask *)searchContentGroupWithSearchKeyword:(NSString *)searchKeyword  WithIncludeAdultCategory:(NSString *)includeAdultCategory completion:(void (^)(NSArray *gets, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_SearchContentGroup];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : [[CMAppManager sharedInstance]getTerminalKeyCheck],
                           @"searchKeyword" : searchKeyword,
                           @"includeAdultCategory" : includeAdultCategory,
                           @"contentGroupProfile" : @"2"
                           };
    
    NSURLSessionDataTask *task = [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

@end

@implementation CMNetworkManager(EPG)

//http://58.141.255.69:8080/nscreen/getChannelList.xml?version=1&areaCode=0
- (NSURLSessionDataTask *)epgGetChannelListAreaCode:(NSString *)areaCode block:(void (^)(NSArray *gets, NSError *error))block
{
    self.acodeClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.acodeClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetChannelList];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : CNM_REAL_TEST_TERMINAL_KEY,
                           @"areaCode" : areaCode
                           };
    
    NSURLSessionDataTask *task = [self.acodeClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

// http://58.141.255.69:8080/nscreen/getChannelList.xml?version=1&areaCode=0&genreCode=1
- (NSURLSessionDataTask *)epgGetChannelListAreaCode:(NSString *)areaCode WithGenreCode:(NSString *)genreCode block:(void (^)(NSArray *gets, NSError *error))block
{
    self.acodeClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.acodeClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetChannelList];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : CNM_REAL_TEST_TERMINAL_KEY,
                           @"areaCode" : areaCode,
                           @"genreCode" : genreCode
                           };
    
    NSURLSessionDataTask *task = [self.acodeClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}


//http://58.141.255.69:8080/nscreen/getChannelGenre.xml?version=1&areaCode=0
- (NSURLSessionDataTask *)epgGetChannelGenreArecode:(NSString *)areaCode block:(void (^)(NSArray *gets, NSError *error))block
{
    self.acodeClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.acodeClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetChannelGenre];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           @"areaCode" : areaCode
                           };
    
    NSURLSessionDataTask *task = [self.acodeClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser*)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
         block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

// http://58.141.255.69:8080/nscreen/getChannelArea.xml?version=1
- (NSURLSessionDataTask *)epgGetChannelAreaBlock:(void (^)(NSArray *gets, NSError *error))block
{
    self.acodeClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.acodeClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetChannelArea];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION
                           };
    
    NSURLSessionDataTask *task = [self.acodeClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
/*
 <?xml version="1.0" encoding="utf-8" standalone="yes"?>
 <response>
 <version>1.0.0</version>
 <transactionId>-1</transactionId>
 <resultCode>100</resultCode>
 <errorString/>
 <areaItem>
 <areaCode>0</areaCode>
 <areaName>CnM TEST</areaName>
 </areaItem>
 <areaItem>
 <areaCode>19</areaCode>
 <areaName>울산JCN TEST</areaName>
 </areaItem>
 <areaItem>
 <areaCode>17</areaCode>
 <areaName>강남 TEST</areaName>
 </areaItem>
 </response>
 */
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser*)responseObject];
/*
 <__NSArrayI 0x7fdd60702ab0>(
 {
 __name = response;
 transactionId = -1;
 resultCode = 100;
 areaItem = (
 {
 areaCode = 0;
 areaName = CnM TEST;
 }
 ,
 {
 areaCode = 19;
 areaName = 울산JCN TEST;
 }
 ,
 {
 areaCode = 17;
 areaName = 강남 TEST;
 }
 
 );
 version = 1.0.0;
 }
 
 )
 */
        block(@[result], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil, error);
    }];
    
    [self updateActivityIndicator:task];
    
    return task;
}

//- (NSURLSessionDataTask *)epgGetChannelAreaBlock:(void (^)(NSArray *gets, NSError *error))block
//{
//    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetChannelArea];
//    NSDictionary *dict = @{
//                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION
//                           };
//    
//    return [self.smClient GET:@"brand.html" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
//}

//http://58.141.255.69:8080/nscreen/getChannelSchedule.xml?version=1&channelId=1&dateIndex=7&areaCode=0
- (NSURLSessionDataTask *)epgGetChannelScheduleChannelId:(NSString *)channelId WithAreaCode:(NSString *)areaCode block:(void (^)(NSArray *gets, NSError *error))block
{
    self.acodeClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.acodeClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetChannelSchedule];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           @"channelId" : channelId,
                           @"areaCode" : areaCode,
                           @"dateIndex" : @"7"
                           };
    
    NSURLSessionDataTask *task = [self.acodeClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser*)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

// http://58.141.255.69:8080/nscreen/searchSchedule.xml?version=1&areaCode=1&searchString=aa
- (NSURLSessionDataTask *)epgSearchScheduleAreaCode:(NSString *)areaCode WithSearch:(NSString *)search block:(void (^)(NSArray *gets, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_SearchSchedule];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           @"areaCode" : @"1",
                           @"searchString" : @"data"
                           };
    
    NSURLSessionDataTask *task = [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    [self updateActivityIndicator:task];
    return task;
}

- (NSURLSessionDataTask *)epgSetRecordWithChannelId:(NSString *)channeId completion:(void (^)(NSArray *epgs, NSError *error))block
{
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_SetRecord];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : [[CMAppManager sharedInstance]getTerminalKeyCheck],
                           @"deviceId" : [[CMAppManager sharedInstance] getKeychainUniqueUuid],
                           @"ChannelId" : channeId
                           };
    
    NSURLSessionDataTask *task = [self.rumClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser*)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

- (NSURLSessionDataTask *)epgSetRecordStopWithChannelId:(NSString *)channeId completion:(void (^)(NSArray *epgs, NSError *error))block
{
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_SetRecordStop];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : [[CMAppManager sharedInstance]getTerminalKeyCheck],
                           @"deviceId" : [[CMAppManager sharedInstance] getKeychainUniqueUuid],
                           @"ChannelId" : channeId
                           };
    
    NSURLSessionDataTask *task = [self.rumClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser*)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

- (NSURLSessionDataTask *)epgSetRecordReserveWithChannelId:(NSString *)channeId WithStartTime:(NSString *)startTime completion:(void (^)(NSArray *epgs, NSError *error))block
{
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_SetRecordReserve];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : [[CMAppManager sharedInstance]getTerminalKeyCheck],
                           @"deviceId" : [[CMAppManager sharedInstance] getKeychainUniqueUuid],
                           @"ChannelId" : channeId,
                           @"StartTime" : startTime
                           };
    
    NSURLSessionDataTask *task = [self.rumClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser*)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

- (NSURLSessionDataTask *)epgSetRecordSeriesReserveWithChannelId:(NSString *)channeId WithStartTime:(NSString *)startTime WithSeriesId:(NSString *)seriesId completion:(void (^)(NSArray *epgs, NSError *error))block
{
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_SetRecordSeriesReserve];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : [[CMAppManager sharedInstance]getTerminalKeyCheck],
                           @"deviceId" : [[CMAppManager sharedInstance] getKeychainUniqueUuid],
                           @"ChannelId" : channeId,
                           @"StartTime" : startTime,
                           @"seriesId" : seriesId
                           };
    
    NSURLSessionDataTask *task = [self.rumClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser*)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

- (NSURLSessionDataTask *)epgSetRecordCancelReserveWithChannelId:(NSString *)channeId WithStartTime:(NSString *)startTime WithSeriesId:(NSString *)seriesId WithReserveCancel:(NSString *)reserveCancel completion:(void (^)(NSArray *epgs, NSError *error))block
{
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *dict = nil;
    
    if ( [reserveCancel isEqualToString:@"1"] )
    {
        // 시리즈
        
        dict = @{
                 CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                 CNM_OPEN_API_TERMINAL_KEY_KEY : [[CMAppManager sharedInstance]getTerminalKeyCheck],
                 @"deviceId" : [[CMAppManager sharedInstance] getKeychainUniqueUuid],
                 @"ChannelId" : channeId,
                 @"StartTime" : startTime,
                 @"seriesId" : seriesId,
                 @"ReserveCancel" : reserveCancel
                 };
        
    }
    else
    {
        // 단편
        dict = @{
                 CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                 CNM_OPEN_API_TERMINAL_KEY_KEY : [[CMAppManager sharedInstance]getTerminalKeyCheck],
                 @"deviceId" : [[CMAppManager sharedInstance] getKeychainUniqueUuid],
                 @"ChannelId" : channeId,
                 @"StartTime" : startTime,
                 @"ReserveCancel" : reserveCancel
                 };
        
    }
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_SetRecordCancelReserve];
    
    NSURLSessionDataTask *task = [self.rumClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser*)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}


@end

@implementation CMNetworkManager (VOD)

- (NSURLSessionDataTask *)vodGetPopularityChartWithCategoryId:(NSString *)categoryId WithRequestItems:(NSString *)requestItems block:(void (^)(NSArray *, NSError *))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetPopularityChart];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : [[CMAppManager sharedInstance]getTerminalKeyCheck],
                           @"categoryId" : categoryId,
                           @"requestItems" : requestItems,
                           @"assetProfile" : @"9"
                           };
    
    NSURLSessionDataTask* task = [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser*)responseObject];
        
        block(@[result], nil);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        block(nil, error);
    }];
    
    [self updateActivityIndicator:task];
    
    return task;
}

- (NSURLSessionDataTask *)vodGetContentGroupListWithContentGroupProfile:(NSString *)contentGroupProfile WithCategoryId:(NSString *)categoryId block:(void (^)(NSArray *, NSError *))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetContentGroupList];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : [[CMAppManager sharedInstance] getTerminalKeyCheck],
                           @"contentGroupProfile" : contentGroupProfile,
                           @"categoryId" : categoryId
                           };
    
    NSURLSessionDataTask *task = [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

- (NSURLSessionDataTask *)vodGetAssetInfoWithAssetId:(NSString *)assetId WithAssetProfile:(NSString *)assetProfile block:(void (^)(NSArray *, NSError *))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetAssetInfo];
    NSDictionary *dict = @{
                          CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                          CNM_OPEN_API_TERMINAL_KEY_KEY : [[CMAppManager sharedInstance]getTerminalKeyCheck],
                          @"assetId" : assetId,
                          @"assetProfile" : assetProfile
                          };
    
    NSURLSessionDataTask *task = [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

- (NSURLSessionDataTask *)vodRecommendContentGroupByAssetId:(NSString *)assetId WithContentGroupProfile:(NSString *)contentGroupProfile block:(void (^)(NSArray *gets, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_RecommendContentGroupByAssetId];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : [[CMAppManager sharedInstance]getTerminalKeyCheck],
                           @"assetId" : assetId,
                           @"contentGroupProfile" : contentGroupProfile
                           };
    
    NSURLSessionDataTask *task = [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

- (NSURLSessionDataTask *)vodGetBundleProductListWithProductProfile:(NSString *)productProfile block:(void (^)(NSArray *gets, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetBundleProductList];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : [[CMAppManager sharedInstance]getTerminalKeyCheck],
                           @"productProfile" : productProfile
                           };
    
    NSURLSessionDataTask *task = [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
       
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

- (NSURLSessionDataTask *)vodGetServicebannerlistBlock:(void(^)(NSArray *vod, NSError *error))block
{
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_GetServiceBannerlist];
    
    NSURLSessionDataTask *task = [self.rumClient GET:sUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

- (NSURLSessionDataTask *)vodGetCategoryTreeBlock:(void (^)(NSArray *vod, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetCategoryTree];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : [[CMAppManager sharedInstance]getTerminalKeyCheck],
                           CNM_OPEN_API_CATEGORY_PROFILE_KEY : @"1",
                           @"categoryId" : @"0",
                           @"depth" : @"2",
                           CNM_OPEN_API_TRAVERSE_TYPE_KEY : @"DFS"
                           };
    
    NSURLSessionDataTask *tesk = [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    
    [self updateActivityIndicator:tesk];
    return tesk;
}


- (NSURLSessionDataTask *)vodGetCategoryTreeWithCategoryId:(NSString *)categoryId WithDepth:(NSString *)depth block:(void (^)(NSArray *vod, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetCategoryTree];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : [[CMAppManager sharedInstance]getTerminalKeyCheck],
//                           CNM_OPEN_API_TRANSACTION_ID_KEY : @"135",
                           CNM_OPEN_API_CATEGORY_PROFILE_KEY : @"4",
                           @"categoryId" : categoryId,
                           @"depth" : depth,
                           CNM_OPEN_API_TRAVERSE_TYPE_KEY : @"DFS"
                           };
    
    NSURLSessionDataTask *tesk = [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
       
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    
    [self updateActivityIndicator:tesk];
    return tesk;
}

- (NSURLSessionDataTask *)vodRecommendAssetBySubscriberWithAssetProfile:(NSString *)assetProfile block:(void (^)(NSArray *vod, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_RecommendAssetBySubscriber];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : CNM_PRIVATE_TERMINAL_KEY,
                           CNM_OPEN_API_ASSET_PROFILE_KEY : assetProfile,
                           };
    
    NSURLSessionDataTask *tesk = [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
      
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    
    [self updateActivityIndicator:tesk];
    
    return tesk;
}

- (NSURLSessionDataTask *)vodGetAppInitializeCompletion:(void (^)(NSArray *pairing, NSError *error))block
{
//    http://112.168.232.147:8033/smapplicationserver/getappinitialize.asp?apptype=A&appId=002cc6d42269f3143470c116a3de51aa6128737c
    
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_GetAppInitialize];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           @"apptype" : @"I",
                           @"appId" : [[CMAppManager sharedInstance] getKeychainUniqueUuid]
//                           @"appId" : @"11223344556677889900"
                           };
    NSURLSessionDataTask *task = [self.rumClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

/// 이벤트 카테고리 
- (NSURLSessionDataTask *)vodGetEventListCompletion:(void (^)(NSArray *pairing, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetEventList];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : CNM_PRIVATE_TERMINAL_KEY
                           };
    
    NSURLSessionDataTask *tesk = [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    
    [self updateActivityIndicator:tesk];
    
    return tesk;
}

// 베너
- (NSURLSessionDataTask *)vodGetAssetListWithCategoryId:(NSString *)categoryId WithAssetProfile:(NSString *)assetProfile completion:(void (^)(NSArray *vod, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetAssetList];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : CNM_PRIVATE_TERMINAL_KEY,
                           @"categoryId" : categoryId,
                           @"assetProfile" : assetProfile
                           };
    
    NSURLSessionDataTask *tesk = [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    
    [self updateActivityIndicator:tesk];
    
    return tesk;
}


// 시리즈 api
- (NSURLSessionDataTask *)vodGetSeriesAssetListWithSeriesId:(NSString *)seriesId WithCategoryId:(NSString *)categoryId WithAssetProfile:(NSString *)assetProfile completion:(void (^)(NSArray *vod, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetSeriesAssetList];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : CNM_PRIVATE_TERMINAL_KEY,
                           @"categoryId" : categoryId,
                           @"seriesId" : seriesId,
                           @"assetProfile" : assetProfile
                           };
    
    NSURLSessionDataTask *tesk = [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    
    [self updateActivityIndicator:tesk];
    
    return tesk;
}

@end

@implementation CMNetworkManager ( PAIRING )

- (NSURLSessionDataTask *)pairingAddUserWithAuthCode:(NSString *)authCode completion:(void (^)(NSArray *pairing, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_AddUser];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : [[CMAppManager sharedInstance] getTerminalKeyCheck],
                           @"userId" : [[CMAppManager sharedInstance] getUniqueUuid],
                           @"authCode" : authCode
                           };
    
    NSURLSessionDataTask *task = [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
       
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

- (NSURLSessionDataTask *)pairingAuthenticateDeviceCompletion:(void (^)(NSArray *pairing, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_AuthenticateDevice];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           //                           @"secondDeviceId" : @"FFFFFF9234567899F2SSA"
                           // !! TEST BJK
//                           @"secondDeviceId" : @"sangho"
                          @"secondDeviceId" : [[CMAppManager sharedInstance] getKeychainUniqueUuid]
                           //
                           };
    
    NSURLSessionDataTask *task = [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
       
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

- (NSURLSessionDataTask *)pairingClientSetTopBoxRegistWithAuthKey:(NSString *)authKey completion:(void (^)(NSArray *pairing, NSError *error))block
{
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_ClientSetTopBoxRegist];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           @"deviceId" : [[CMAppManager sharedInstance] getKeychainUniqueUuid], // uuid 가 없으면 생성 페어링 실패 하면 데이터 지움
                           @"authKey" : authKey
                           };
    
    return [self.rumClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
//        [[CMAppManager sharedInstance] removeInfoDataKey:CNM_OPEN_API_UUID_KEY];
        
        block(nil, error);
    }];
}

- (NSURLSessionDataTask *)pairingRemoveUserCompletion:(void (^)(NSArray *pairing, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_RemoveUser];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : [[CMAppManager sharedInstance] getTerminalKeyCheck],
                           @"userId" : [[CMAppManager sharedInstance] getKeychainUniqueUuid]
                           };
    
    NSURLSessionDataTask *task = [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;

}


@end

@implementation CMNetworkManager ( PVR )

// 녹화물목록
- (NSURLSessionDataTask *)pvrGetrecordlistCompletion:(void (^)(NSArray *pvr, NSError *error))block
{
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_DEV_Getrecordlist];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : [[CMAppManager sharedInstance] getTerminalKeyCheck],
                           @"deviceId" : [[CMAppManager sharedInstance] getKeychainUniqueUuid]
                           };
    NSURLSessionDataTask *task = [self.rumClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

// 시리즈 녹화물 목록
- (NSURLSessionDataTask *)pvrGetrecordListWithSeriesId:(NSString *)seriesId completion:(void (^)(NSArray *pvr, NSError *error))block
{
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_DEV_Getrecordlist];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : [[CMAppManager sharedInstance] getTerminalKeyCheck],
                           @"deviceId" : [[CMAppManager sharedInstance] getKeychainUniqueUuid],
                           @"SeriesId" : seriesId
                           };
    NSURLSessionDataTask *task = [self.rumClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

- (NSURLSessionDataTask *)pvrGetrecordReservelistCompletion:(void (^)(NSArray *pvr, NSError *error))block
{
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_DEV_GetrecordReservelist];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : @"1",
                           CNM_OPEN_API_TERMINAL_KEY_KEY : [[CMAppManager sharedInstance] getTerminalKeyCheck],
                           @"deviceId" : [[CMAppManager sharedInstance] getKeychainUniqueUuid]
                           };
    NSURLSessionDataTask *task = [self.rumClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    
    [self updateActivityIndicator:task];
    return task;
}

- (NSURLSessionDataTask *)pvrSetRecordDeleWithChannelId:(NSString *)channeId WithStartTime:(NSString *)startTime WithRecordId:(NSString *)recordId completion:(void (^)(NSArray *pvr, NSError *error))block
{
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_SetRecordDele];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : @"1",
                           CNM_OPEN_API_TERMINAL_KEY_KEY : [[CMAppManager sharedInstance] getTerminalKeyCheck],
                           @"deviceId" : [[CMAppManager sharedInstance] getKeychainUniqueUuid],
                           @"RecordId" : recordId,
                           @"ChannelId" : channeId,
                           @"StartTime" : startTime,
                           @"deleteType" : @"0" // 고정
                           };
    NSURLSessionDataTask *task = [self.rumClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    
    [self updateActivityIndicator:task];
    return task;
}

- (NSURLSessionDataTask *)pvrSetRecordSeriesDeleWithRecordId:(NSString *)recordId WithSeriesId:(NSString *)seriesId WithChannelId:(NSString *)channelId WithStartTime:(NSString *)startTime completion:(void (^)(NSArray *pvr, NSError *error))block
{
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_SetRecordSeriesDele];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : @"1",
                           CNM_OPEN_API_TERMINAL_KEY_KEY : [[CMAppManager sharedInstance] getTerminalKeyCheck],
                           @"deviceId" : [[CMAppManager sharedInstance] getKeychainUniqueUuid],
                           @"RecordId" : recordId,
                           @"ChannelId" : channelId,
                           @"StartTime" : startTime,
                           @"seriesId" : seriesId
                           };
    NSURLSessionDataTask *task = [self.rumClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    
    [self updateActivityIndicator:task];
    return task;

}

@end

@implementation CMNetworkManager ( DRM )

- (NSURLSessionDataTask *)drmApiWithAsset:(NSString *)asset WithPlayStyle:(NSString *)style completion:(void (^)(NSDictionary *drm, NSError *error))block
{
    self.drmClient.responseSerializer = [AFJSONResponseSerializer new];
    self.drmClient.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/json", @"text/javascript"]];
    
    NSString *sUrl = [NSString stringWithFormat:@"v1/mso/10/asset/%@/%@", asset, style];
    
    
    NSURLSessionDataTask *task = [self.drmClient GET:sUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary *response = [responseObject objectForKey:@"drm"];
        
        if (block) {
            block(response, nil);
        }

        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        if (block) {
            block([NSDictionary dictionary], error);
        }
    }];
    
    [self updateActivityIndicator:task];
    return task;

}


@end

@implementation CMNetworkManager ( REMOCON )

- (NSURLSessionDataTask *)remoconSetRemotoePowerControlPower:(NSString *)power completion:(void (^)(NSArray *pvr, NSError *error))block
{
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_SetRemotePowerControl];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : [[CMAppManager sharedInstance] getTerminalKeyCheck],
                           @"deviceId" : [[CMAppManager sharedInstance] getKeychainUniqueUuid],
                           @"power" : power
                           };
    NSURLSessionDataTask *task = [self.rumClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

- (NSURLSessionDataTask *)remoconSetRemoteVolumeControlVolume:(NSString *)volume completion:(void (^)(NSArray *pvr, NSError *error))block
{
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_SetRemoteVolumeControl];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : [[CMAppManager sharedInstance] getTerminalKeyCheck],
                           @"deviceId" : [[CMAppManager sharedInstance] getKeychainUniqueUuid],
                           @"volume" : volume
                           };
    NSURLSessionDataTask *task = [self.rumClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

- (NSURLSessionDataTask *)remoconGetSetTopStatusCompletion:(void (^)(NSArray *pairing, NSError *error))block
{
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_GetSetTopStatus];
    NSDictionary *dict = @{
                           @"deviceId" : [[CMAppManager sharedInstance] getKeychainUniqueUuid]
                           };
    NSURLSessionDataTask *task = [self.rumClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    
    [self updateActivityIndicator:task];
    return task;
}


- (NSURLSessionDataTask *)remoconSetRemoteChannelControlWithChannelId:(NSString *)channelId completion:(void (^)(NSArray *pairing, NSError *error))block
{
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_SetRemoteChannelControl];
    NSDictionary *dict = @{
                           @"deviceId" : [[CMAppManager sharedInstance] getKeychainUniqueUuid],
                           @"channelId" : channelId
                           };
    NSURLSessionDataTask *task = [self.rumClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    
    [self updateActivityIndicator:task];
    return task;
}

@end

@implementation CMNetworkManager ( MyC_M )

- (NSURLSessionDataTask *)myCmGetWishListCompletion:(void (^)(NSArray *myCm, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetWishList];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : [[CMAppManager sharedInstance]getTerminalKeyCheck],
                           @"userId" : [[CMAppManager sharedInstance] getKeychainUniqueUuid],
                           @"assetProfile" : @"1"
                           };
    
    NSURLSessionDataTask *task = [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

- (NSURLSessionDataTask *)myCmGetValidPurchaseLogListCompletion:(void (^)(NSArray *myCm, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetValidPurchaseLogList];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY :[[CMAppManager sharedInstance]getTerminalKeyCheck],
                           @"purchaseLogProfile" : @"2"
                           };
    
    NSURLSessionDataTask *task = [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

@end

@implementation CMNetworkManager ( Preference )

// 유료체널 리스트 정보
- (NSURLSessionDataTask *)preferenceGetServiceJoyNListCompletion:(void (^)(NSArray *preference, NSError *error))block
{
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_GetServiceJoyNList];
    
    NSURLSessionDataTask *task = [self.rumClient GET:sUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

// 특정 유료체널 상세 정보
- (NSURLSessionDataTask *)preferenceGetServiceJoyNInfoCode:(NSString*)code completion:(void (^)(NSArray *preference, NSError *error))block
{
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_GetServiceJoyNInfo];
    NSDictionary *dict = @{
                           @"joyNId" : code,
                           };
    
    NSURLSessionDataTask *task = [self.rumClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

// 공지사항 리스트 및 상세 정보 ex)areaCode = 0 , productCode = 11
- (NSURLSessionDataTask *)preferenceGetServiceNoticeInfoCompletion:(void (^)(NSArray *, NSError *))block
{
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_GetServiceNoticeInfo];
    
    NSURLSessionDataTask *task = [self.rumClient GET:sUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

//고객센터, 이용약관
- (NSURLSessionDataTask *)perferenceGetServiceguideInfoWithCode:(NSString*)code completion:(void (^)(NSArray *preference, NSError *error))block {
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_GetServiceguideInfo];
    NSDictionary *dict = @{
                           CNM_OPEN_API_PREF_GUIDEID_KEY : code,
                           };
    
    NSURLSessionDataTask *task = [self.rumClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}

//버전정보
- (NSURLSessionDataTask *)perferenceGetAppVersionInfoCompletion:(void (^)(NSArray *preference, NSError *error))block {
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_GetAppVersionInfo];
    
    NSURLSessionDataTask *task = [self.rumClient GET:sUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}


@end

@implementation CMNetworkManager ( Payment )

- (NSURLSessionDataTask  *)paymentGetAvailablePaymentTypeWithDomainId:(NSString *)domainId completion:(void (^)(NSArray *preference, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetAvailablePaymentType];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY :[[CMAppManager sharedInstance]getTerminalKeyCheck],
                           @"domainId" : domainId
                           };
    
    NSURLSessionDataTask *task = [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;

}


- (NSURLSessionDataTask *)paymentPurchaseByPointWithDomainId:(NSString *)domainId WithAssetId:(NSString *)assetId WithProductId:(NSString *)productId WithGoodId:(NSString *)goodId WithPrice:(NSString *)price WithCategoryId:(NSString *)categoryId completion:(void (^)(NSArray *preference, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_PurchaseByPoint];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY :[[CMAppManager sharedInstance]getTerminalKeyCheck],
                           @"domainId" : domainId,
                           @"assetId" : assetId,
                           @"productId" : productId,
                           @"goodId" : goodId,
                           @"price" : price,
                           @"categoryId" : categoryId
                           };
    
    NSURLSessionDataTask *task = [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;

}

- (NSURLSessionDataTask *)paymentPurchaseAssetEx2WithProductId:(NSString *)productId WithGoodId:(NSString *)goodId WithUiComponentDomain:(NSString *)uiComponentDomain WithUiComponentId:(NSString *)uiComponentId WithPrice:(NSString *)price completion:(void (^)(NSArray *preference, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_PurchaseAssetEx2];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : @"2",
                           CNM_OPEN_API_TERMINAL_KEY_KEY :[[CMAppManager sharedInstance]getTerminalKeyCheck],
                           @"productId" : productId,
                           @"goodId" : goodId,
                           @"uiComponentDomain" : uiComponentDomain,
                           @"uiComponentId" : uiComponentId,
                           @"price" : price
                           };
    
    NSURLSessionDataTask *task = [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;

}

@end

@implementation CMNetworkManager ( WISH )

- (NSURLSessionDataTask *)wishGetWishListCompletion:(void (^)(NSArray *wish, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetWishList];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : @"1",
                           CNM_OPEN_API_TERMINAL_KEY_KEY :[[CMAppManager sharedInstance]getTerminalKeyCheck],
                           @"userId" : [[CMAppManager sharedInstance] getKeychainUniqueUuid]
                         };
    
    NSURLSessionDataTask *task = [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;

}

// 찜하기
- (NSURLSessionDataTask *)wishAddWishItemWithAssetId:(NSString *)assetId completion:(void (^)(NSArray *wish, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_AddWishItem];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : @"1",
                           CNM_OPEN_API_TERMINAL_KEY_KEY :[[CMAppManager sharedInstance]getTerminalKeyCheck],
                           @"userId" : [[CMAppManager sharedInstance] getKeychainUniqueUuid],
                           @"assetId" : assetId
                           };
    
    NSURLSessionDataTask *task = [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;

}

// 찜삭제하기
- (NSURLSessionDataTask *)wishRemoveWishWithAssetId:(NSString *)assetId completion:(void (^)(NSArray *wish, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_RemoveWishItem];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : @"1",
                           CNM_OPEN_API_TERMINAL_KEY_KEY :[[CMAppManager sharedInstance]getTerminalKeyCheck],
                           @"userId" : [[CMAppManager sharedInstance] getKeychainUniqueUuid],
                           @"assetId" : assetId
                           };
    
    NSURLSessionDataTask *task = [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    [self updateActivityIndicator:task];
    return task;
}


@end

