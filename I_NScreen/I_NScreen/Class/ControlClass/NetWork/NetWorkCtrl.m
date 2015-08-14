//
//  NetWorkCtrl.m
//  WaitingNumber
//
//  Created by Chang Youl Lee on 12. 4. 4..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "NetWorkCtrl.h"

@interface NetWorkCtrl ()

@end

@implementation NetWorkCtrl

@synthesize delegate;

- (id)init {
    self = [super init];
    if (self) {
        connection = [[NSURLConnection alloc] init];
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


#pragma mark -긴급공지 팝업 위한 전문
//// 긴급공지 팝업 위한 전문
//- (void)requestWithDataMSW0106:(TransactionData *)pData
//{
//    [self SendBuffer:@"" setUrlHeader:@"msw0106_01.do"];
//}


// 전문을 보내기 위해서 공통으로 사용중인 클래스, 전문에 들어갈 값과 서버 명령어를 넣어주면 된다.
// 전문 값         strData
// 서버 명령어      strUrl
#pragma mark -전문을 보내기 위해서 공통으로 사용중인 클래스, 전문에 들어갈 값과 서버 명령어를 넣어주면 된다.
- (void)SendBuffer:(NSString *)strData setUrlHeader:(NSString *)strUrl
{
//    NSString *XmlData = [NSString stringWithFormat:@"%@", strData];
//    //    XmlData = [XmlData stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *httpBody = [NSString stringWithFormat:@"%@",XmlData];
//    
//    NSMutableString *strUrlHeader = [NSMutableString stringWithFormat:@"%@%@/%@?",SERVER_IP, SERVER_PATH, strUrl];
//    NSURL *url = [NSURL URLWithString:strUrlHeader];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0f];
//    
//    NSLog(@"httpBody : [%@], strUrlHeader : [%@]", httpBody , strUrlHeader);
//    
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:[NSData dataWithBytes:[httpBody UTF8String] length:[httpBody length]]];
//    
//    [request setValue:@"iPhone Simulator" forHTTPHeaderField:@"User-Agent"];
//    [request setValue:[self getHanaUserAgent] forHTTPHeaderField:@"CUSTOM_USER_AGENT"];
//    [request setValue:@"application/x-www-form-urlencoded; charset=euc-kr" forHTTPHeaderField:@"Content-Type"];
//    
//    connection = [NSURLConnection connectionWithRequest:request delegate:self];
//    
//    if(connection)
//    {
//        [recvData release];
//        recvData = nil;
//        recvData = [[NSMutableData alloc] init];
//    }
//    
//    [request release];
}

#pragma mark - 외부에서 전문을 받아서 처리하는 모듈 requestWithData를 기준으로 분기한다.
// 외부에서 전문 요청 데이터를 넘김
- (void)requestWithData:(TransactionData *)pData
{
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivityIndicatorShow" object:nil userInfo:nil];
    //    [[DataManager getInstance].p_gUserClass showLoading:YES];
    
    m_nTrCode = pData.nTrCode;
    
    //    NSLog(@"\n\n\n NetWorkCtrl m_nTrCode : [%d]\n\n\n",m_nTrCode);
    
    switch (m_nTrCode) {
            
//        case TRINFO_SEARCH_ITEM:
//        {
//            [self requestWithDataSearchItem:pData];
//        }break;
    }
}

#pragma mark - 네트워크 통신 처리
//// 통신헤더 처리
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//    NSDictionary *headerDic = [httpResponse allHeaderFields];
//    
//    NSString *strEncoding = [headerDic objectForKey:@"Transfer-Encoding"];
//    
//    if([strEncoding length] > 0)
//    {
//        return;
//    }
//}

// 네트워크 에러시
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    NSLog(@"error : [%@]", error);
//    
//    //    if([error code] == kCFURLErrorNotConnectedToInternet)
//    //    {
//    //        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"연결 실패" forKey:NSLocalizedDescriptionKey];
//    //
//    //        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain code:kCFURLErrorNotConnectedToInternet userInfo:userInfo];
//    //
//    //        NSLog(@"연결실패 : [%@]", error);
//    //
//    //        [self FailWithError:noConnectionError];
//    //    }
//    //    else {
//    //        NSLog(@"연결실패 이외의 에러 : [%@]", error);
//    [self FailWithError:error];
//    //    }
//}
//
//-(void)FailWithError:(NSError *)error
//{
//    NSString *errorMsg = [error localizedDescription];
//    UIAlertView *alert = [[UIAlertView alloc] init];
//    [alert setTitle:@"연결 실패"];
//    
//    if([errorMsg isEqualToString:@"The request timed out."])
//    {
////        [alert setMessage:MSG109];
//    }
//    else
//    {
//        [alert setMessage:errorMsg];
//    }
//    [alert setDelegate:self];
//    [alert addButtonWithTitle:@"확인"];
//    [alert show];
//    [alert release];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivityIndicatorHide" object:nil userInfo:nil];
//    
//    [delegate ResponeError:m_nTrCode netwrokID:m_nTagCode];
//}

//// 서버에 접속 전문요청이 오는 데이터를 저장
//-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    //    NSLog(@"didReceiveData : [%@] \n\n\n", data);
//    [recvData appendData:data];
//}

//// 서버에서 전문 데이터를 다 받았을때
//-(void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    NSString *responseString = [[NSString alloc] initWithBytes:[recvData bytes]
//                                                        length:[recvData length]
//                                                      encoding:NSUTF8StringEncoding];
//    NSLog(@"다운로드 FinishedData 변환후 : [%@] \n\n\n", responseString);
//    
//    NSMutableArray *pArray = nil;
//    NSMutableDictionary *pDic = nil;
//    
//    SBJsonParser *json = [[SBJsonParser new] autorelease];
//    id ConvertJSon = [json objectWithString:responseString error:nil];
//    
//    NSLog(@"class name : [%@]", [ConvertJSon class]);
//    
////    [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivityIndicatorHide" object:nil userInfo:nil];
//    
//    if ( [ConvertJSon isKindOfClass:[NSDictionary class]] )
//    {
//        pDic = (NSMutableDictionary*)ConvertJSon;
//        NSLog(@"NSDictionary : [%@]", pDic);
//    }
//    else if ( [ConvertJSon isKindOfClass:[NSArray class]] )
//    {
//        pArray = (NSMutableArray*)ConvertJSon;
//        
//        pDic = [pArray objectAtIndex:0];
//        NSLog(@"__NSArrayM : [%@]", pDic);
//    }
//    else
//    {
//        NSLog(@"what???? : %@", NSStringFromClass([ConvertJSon class]));
//    }
//    
//    NSLog(@"errorCode : [%@]", [pDic objectForKey:@"errorCode"]);
//    
//    BOOL        bNullCheck = FALSE;
//    
//    id val = [pDic objectForKey:@"errorCode"];
//    if ( [val isKindOfClass:[NSString class]] ) {
//        if ( [(NSString *)val isEqualToString:@"null"] ) {
//            // null
//            bNullCheck = YES;
//        }
//        else {
//            // string, not null
//            bNullCheck = FALSE;
//        }
//    }
//    else
//    {
//        // null
//        bNullCheck = YES;
//    }
//    
//    if(pDic == nil)
//    {
//        //        UIAlertView *alert = [[UIAlertView alloc] init];
//        //        [alert setTitle:@"연결 실패"];
//        ////        [alert setMessage:@"서버와의 연결이 원할하지 않습니다.\n다시 시도해 주세요."];
//        //        [alert setMessage:@"일시적인 통신 장애가 발생 하였습니다.\n잠시후 다시 이용해 주시기 바랍니다."];
//        //        [alert setDelegate:self];
//        //        [alert addButtonWithTitle:@"확인"];
//        //        [alert show];
//        //        [alert release];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivityIndicatorNetworkErrorShow" object:nil userInfo:nil];
//        
//        [delegate ResponeError:m_nTrCode netwrokID:m_nTagCode];
//        return;
//    }
//    
//    if([[pDic objectForKey:@"errorCode"] isEqualToString:@"exception"])
//    {
//        // 원투원 마케팅에서 예외처리가 발생했을때 처리
//        [delegate ResponeError:m_nTrCode netwrokID:m_nTagCode];
//    }
//    else if([responseString length] > 0)
//    {
//        switch (m_nTrCode) {
////            case TRINFO_MSW0013:
////            {
////                // 로그인 승인 데이터 정보 파싱
////                [self traverseMSW0013:responseString];
////            }break;
//        }
//    }
//    else
//    {
//        NSLog(@"전문 정보가 하나도 없음");
//        [delegate ResponeError:m_nTrCode netwrokID:m_nTagCode];
//    }
//    
//    [responseString release];
//}


#pragma mark - SSL 무시하는 코드 시작

/**************************
 SSL 무시하는 코드 시작
 **************************/
//- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
//    
//    //    NSLog(@"canAuthenticateAgainstProtectionSpace");
//    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//    
//    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
//        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
//    }
//    
//    //     NSLog(@"challenge.protectionSpace.host := %@", challenge.protectionSpace.host);
//    
//    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
//}

/**************************
 SSL 무시하는 코드 끝
 **************************/



#pragma mark - JSON파싱

#pragma mark -로그인 승인 데이터 정보 파싱
//// 로그인 승인 데이터 정보 파싱
//- (void)traverseMSW0013:(NSString *)element;
//{
//}



// 서버에서 전문이 잘못되었을 경우 리턴되는 메시지를 정의한다.
//- (void)ReturnErrorMsg
//{
//    //    UIAlertView *alert = [[UIAlertView alloc] init];
//    //    [alert setTitle:@"알림"];
//    //    [alert setMessage:MSG1];
//    //    [alert setDelegate:self];
//    //    [alert addButtonWithTitle:@"확인"];
//    //    [alert show];
//    //    [alert release];
//    
//    [delegate ResponeError:m_nTrCode netwrokID:m_nTagCode];
//}

@end



