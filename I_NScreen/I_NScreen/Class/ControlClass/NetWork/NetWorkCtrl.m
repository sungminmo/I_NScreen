//
//  NetWorkCtrl.m
//  WaitingNumber
//
//  Created by Chang Youl Lee on 12. 4. 4..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "NetWorkCtrl.h"
#import "DWHTTPStreamSessionManager.h"
#import "DWHTTPJSONItemSerializer.h"
#import "DWDummyHTTPResponseSerializer.h"

#import "SBJson4Parser.h"

@interface NetWorkCtrl ()

@property (nonatomic, strong) DWHTTPStreamSessionManager *manager;

@end

@implementation NetWorkCtrl

@synthesize delegate;

- (id) init
{
    self = [super init];

    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

// 풀링에 사용할 데이터
- (void)SetTag:(int)nTagCode
{
    m_nTagCode = nTagCode;
}

- (int)GetTag
{
    return m_nTagCode;
}

- (void)SetFinish:(BOOL)bFinishCheck
{
    m_bFinishCheck = bFinishCheck;
}

- (BOOL)GetFinish
{
    return m_bFinishCheck;
}

#pragma mark - 전문
#pragma mark - 전문 테스트 get
- (void)requestWithDataTest:(TransactionData *)pData
{
    NSDictionary *bodyDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"i", @"app_tp",
                                 @"323ab1add4113f965f561c9b676fb1bbff853155b4218954b44559d6a928e3a5", @"push_id",
                                 @"+9", @"push_gmt",
                                 nil];
    
    [self SendGetBuffer:bodyDataDic setUrlHeader:@"appapi/saveset"];
}

// 전문을 보내기 위해서 공통으로 사용중인 클래스, 전문에 들어갈 값과 서버 명령어를 넣어주면 된다.
// 전문 값         strData
// 서버 명령어      strUrl
#pragma mark -전문을 보내기 위해서 공통으로 사용중인 클래스, 전문에 들어갈 값과 서버 명령어를 넣어주면 된다.
#pragma mark - Get 방식
- (void)SendGetBuffer:(NSDictionary *)strData setUrlHeader:(NSString *)strUrl
{
    NSURL *url = [NSURL URLWithString:DEV_HOST];
    self.manager = [[DWHTTPStreamSessionManager alloc] initWithBaseURL:url];
    self.manager.itemSerializerProvider = [[DWHTTPJSONItemSerializerProvider alloc] init];
    self.manager.responseSerializer = [[DWDummyHTTPResponseSerializer alloc] init];
    
    responseDataArr = [[NSMutableArray alloc] init];
    responseDataDic = [[NSMutableDictionary alloc] init];
   
    [self.manager GET:strUrl
           parameters:strData
                 data:^(NSURLSessionDataTask *task, id chunk) {
                     
                     if ( [chunk isKindOfClass:[NSDictionary class]] )
                     {
                         [responseDataDic setDictionary:chunk];
                         NSLog(@"__NSDictionary : [%@]", responseDataDic);
                     }
                     else if ( [chunk isKindOfClass:[NSArray class]] )
                     {
                         responseDataArr = (NSMutableArray*)chunk;
                         NSLog(@"__NSArrayM : [%@]", responseDataArr);
                     }
                     else
                     {
                         NSLog(@"what???? : %@", NSStringFromClass([chunk class]));
                     }
                     
                 } success:^(NSURLSessionDataTask *task) {
                     
                     NSLog(@"response sucess");

                     switch (m_nTrCode) {
                         case TRINFO_TEST:
                         {
                             [self traverseTest:responseDataDic];
                         }break;
                     }
                     
                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                     
                     NSLog(@"response fail");
                     [delegate ResponeError:m_nTrCode netwrokID:m_nTagCode];
                 }];
}

#pragma mark - Post 방식
- (void)SendPostBuffer:(NSDictionary *)strData setUrlHeader:(NSString *)strUrl
{
    NSURL *url = [NSURL URLWithString:DEV_HOST];
    self.manager = [[DWHTTPStreamSessionManager alloc] initWithBaseURL:url];
    self.manager.itemSerializerProvider = [[DWHTTPJSONItemSerializerProvider alloc] init];
    self.manager.responseSerializer = [[DWDummyHTTPResponseSerializer alloc] init];
    
    responseDataArr = [[NSMutableArray alloc] init];
    responseDataDic = [[NSMutableDictionary alloc] init];
    
    [self.manager POST:strUrl
           parameters:strData
                 data:^(NSURLSessionDataTask *task, id chunk) {
                     
                     if ( [chunk isKindOfClass:[NSDictionary class]] )
                     {
                         [responseDataDic setDictionary:chunk];
                         NSLog(@"__NSDictionary : [%@]", responseDataDic);
                     }
                     else if ( [chunk isKindOfClass:[NSArray class]] )
                     {
                         responseDataArr = (NSMutableArray*)chunk;
                         NSLog(@"__NSArrayM : [%@]", responseDataArr);
                     }
                     else
                     {
                         NSLog(@"what???? : %@", NSStringFromClass([chunk class]));
                     }
                     
                 } success:^(NSURLSessionDataTask *task) {
                     
                     NSLog(@"response sucess");
                     
                     switch (m_nTrCode) {
                         case TRINFO_TEST:
                         {
                             [self traverseTest:responseDataDic];
                         }break;
                     }
                     
                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                     
                     NSLog(@"response fail");
                     [delegate ResponeError:m_nTrCode netwrokID:m_nTagCode];
                 }];
}


#pragma mark - 외부에서 전문을 받아서 처리하는 모듈 requestWithData를 기준으로 분기한다.
#pragma mark - 외부에서 전문 요청 데이터를 넘김
- (void)requestWithData:(TransactionData *)pData
{
    m_nTrCode = pData.nTrCode;
    
    switch (m_nTrCode) {
            
        case TRINFO_TEST:
        {
            [self requestWithDataTest:pData];
        }break;
    }
}



#pragma mark - 전문 응답
#pragma mark - 테스트 전문 결과
- (void)traverseTest:(NSDictionary *)pDic
{
    NSLog(@"설정 정보 업데이트 결과 = [%@]", pDic);

    [[DataManager getInstance].p_gTestDic removeAllObjects];
    [[DataManager getInstance].p_gTestDic setDictionary:pDic];
    
    [delegate ResponeFinish:TRINFO_TEST netwrokID:m_nTagCode];
}

@end



