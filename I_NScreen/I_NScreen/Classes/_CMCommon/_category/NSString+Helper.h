//
//  NSString+Helper.h
//  STVN
//
//  Created by lambert on 2014. 10. 29..
//
//

#import <Foundation/Foundation.h>

@interface NSString (Helper)

/**
 *  @brief  URL 인코딩.
 *
 *  @return NSString.
 */
- (NSString *)stringByUrlEncoding;

/**
 *  @brief  URL 디코딩.
 *
 *  @return NSString.
 */
- (NSString *)stringByUrlDecoding;

/**
 *  @brief  문자열 날짜 포맷팅: 20141106 -> 2014-11-06.
 *
 *  @return NSString.
 */
- (NSString *)formatDate;

/**
 *  @brief  랜덤 문자열 생성
 *
 *  @param len 생성할 문자열 길이
 *
 *  @return 문자열
 */
+ (NSString *)genRandStringLength:(int)len;

/**
 *  @brief  문자열에 포함된 숫자만 반한한다.
 *
 *  @return NSString.
 */
- (NSString *)remainOnlyNumber;

/**
 *  @brief  Hex 데이터로 디코딩한다.
 *
 *  @return NSData.
 */
- (NSData *)decodeFromHexidecimal;

/**
 *  @brief   빈 문자열 여부.
 */
- (BOOL)isEmpty;

/**
 *  @brief  트림.
 *
 *  @return NSString.
 */
- (NSString *)trim;

/**
 *  @brief  Base64 인코딩.
 *
 *  @return NSString.
 */
- (NSString *)encodeBase64;

/**
 *  @brief  Base64 디코딩.
 *
 *  @return NSString.
 */
- (NSString *)decodeBase64;

/**
 *  @brief  뎁스가 없는 딕셔너리 정보를 query string문자열로 변환한다.
 *
 *  @param dict 변환할 정보 딕셔너리
 *
 *  @return query 문자열 
 */
+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict;

/**
 *  @brief  쿼리 파라미터를 파싱해서 인코딩한다.
 *
 *  @param param 인코딩할 파라미터
 *
 *  @return 인코딩한 문자열
 */
+ (NSString *)queryParameterEncodingWithParam:(NSString *)param;

/**
 *  @brief  URL의 쿼리를 파싱하여 딕셔너리로 반환한다.
 *
 *  @param query 쿼리 스트링.
 *
 *  @return NSDictionary.
 */
+ (NSDictionary *)parseQueryString:(NSString *)query;

/**
 *  @brief  문자열 포함 여부.
 *
 *  @param aString 문자열.
 *
 *  @return BOOL.
 */
- (BOOL)containsString:(NSString *)aString;


/**
 *  @brief  문자열에 html태그를 제거한다.
 */
-(NSString *) stringByStrippingHTML;

@end
