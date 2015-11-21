//
//  CMDBDataManager.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMDBDataManager.h"

#import "CMPurchaseAuthorize.h"
#import "CMAreaInfo.h"
#import "CMPairingInfo.h"
#import "CMPrivateKey.h"
#import "CMVodWatchList.h"

@implementation CMDBDataManager

+ (CMDBDataManager *)sharedInstance {
    static CMDBDataManager *sharedInstanced = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstanced = [[self alloc] init];
    });
    return sharedInstanced;
}

- (id)init {
    if (self = [super init]) {
        [self saveDefaultAeraCodeForce:NO];
    }
    return self;
}

- (RLMRealm*)cmRealm {
    RLMRealm *realm = [RLMRealm defaultRealm];
    return realm;
}

//TODO: 테스트 후 적용여부가 결정되면 수정할 것.
- (void)secureRealmDataBase {
    // Use an autorelease pool to close the Realm at the end of the block, so
    // that we can try to reopen it with different keys
    @autoreleasepool {
        RLMRealmConfiguration *configuration = [RLMRealmConfiguration defaultConfiguration];
        configuration.encryptionKey = [self getSecureKey];
        RLMRealm *realm = [RLMRealm realmWithConfiguration:configuration
                                                     error:nil];
        
        [realm beginWriteTransaction];
        CMPurchaseAuthorize *obj = [[CMPurchaseAuthorize alloc] init];
        obj.authorizedNumber = @"abcdefg";
        [realm addObject:obj];
        [realm commitWriteTransaction];
    }
    
    // Opening with wrong key fails since it decrypts to the wrong thing
    @autoreleasepool {
        uint8_t buffer[64];
        SecRandomCopyBytes(kSecRandomDefault, 64, buffer);
        
        NSError *error;
        RLMRealmConfiguration *configuration = [RLMRealmConfiguration defaultConfiguration];
        configuration.encryptionKey = [[NSData alloc] initWithBytes:buffer length:sizeof(buffer)];
        [RLMRealm realmWithConfiguration:configuration
                                   error:&error];
        DDLogError(@"Open with wrong key: %@", error);
    }
    
    // Opening wihout supplying a key at all fails
    @autoreleasepool {
        NSError *error;
        [RLMRealm realmWithConfiguration:[RLMRealmConfiguration defaultConfiguration] error:&error];
        DDLogError(@"Open with no key: %@", error);
    }
    
    // Reopening with the correct key works and can read the data
    @autoreleasepool {
        RLMRealmConfiguration *configuration = [RLMRealmConfiguration defaultConfiguration];
        configuration.encryptionKey = [self getSecureKey];
        RLMRealm *realm = [RLMRealm realmWithConfiguration:configuration
                                                     error:nil];
        
        DDLogInfo(@"Saved object: %@", [[[CMPurchaseAuthorize allObjectsInRealm:realm] firstObject] authorizedNumber]);
    }
}


- (NSData *)getSecureKey {
    static const uint8_t kKeychainIdentifier[] = "io.Realm.CMDB.EncryptionKey";// Identifier for our keychain entry - should be unique for your application
    NSData *tag = [[NSData alloc] initWithBytesNoCopy:(void *)kKeychainIdentifier
                                               length:sizeof(kKeychainIdentifier)
                                         freeWhenDone:NO];
    
    // First check in the keychain for an existing key
    NSDictionary *query = @{(__bridge id)kSecClass: (__bridge id)kSecClassKey,
                            (__bridge id)kSecAttrApplicationTag: tag,
                            (__bridge id)kSecAttrKeySizeInBits: @512,
                            (__bridge id)kSecReturnData: @YES};
    
    CFTypeRef dataRef = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &dataRef);
    if (status == errSecSuccess) {
        return (__bridge NSData *)dataRef;
    }
    
    // No pre-existing key from this application, so generate a new one
    uint8_t buffer[64];
    SecRandomCopyBytes(kSecRandomDefault, 64, buffer);
    NSData *keyData = [[NSData alloc] initWithBytes:buffer length:sizeof(buffer)];
    
    // Store the key in the keychain
    query = @{(__bridge id)kSecClass: (__bridge id)kSecClassKey,
              (__bridge id)kSecAttrApplicationTag: tag,
              (__bridge id)kSecAttrKeySizeInBits: @512,
              (__bridge id)kSecValueData: keyData};
    
    status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    NSAssert(status == errSecSuccess, @"Failed to insert new key in the keychain");
    
    return keyData;
}

#pragma mark - 구매인증번호 관리 (암호화 전)
- (NSString*)purchaseAuthorizedNumber {
    RLMArray* rs = (RLMArray*)[CMPurchaseAuthorize allObjects];
    DDLogDebug(@"realm step 0. : %ld", rs.count);
    if (rs.count > 0) {
        return [((CMPurchaseAuthorize* )rs.lastObject).authorizedNumber copy];
    }
    return @"";
}

- (void)savePurchaseAuthorizedNumber:(NSString*)number {
    
    RLMRealm *realm = [self cmRealm];
    
    if ([self purchaseAuthorizedNumber].length > 0) {
        RLMArray* all = (RLMArray*)[CMPurchaseAuthorize allObjects];
        [realm beginWriteTransaction];
        [realm deleteObjects:all];
        [realm commitWriteTransaction];
    }
    
    CMPurchaseAuthorize *pa =  [[CMPurchaseAuthorize alloc] init];
    pa.authorizedNumber = number;
    
    //1-2. 저장
    [realm beginWriteTransaction];
    [realm addObject:pa];
    [realm commitWriteTransaction];
}

#pragma mark - 프라이빗 터미널 키 저장
- (void)savePrivateTerminalKey:(NSString *)terminalKey
{
    RLMRealm *realm = [self cmRealm];

    if ( [[self getPrivateTerminalKey] length] > 0 )
    {
        RLMArray *all = (RLMArray *)[CMPrivateKey allObjects];
        [realm beginWriteTransaction];
        [realm deleteObjects:all];
        [realm commitWriteTransaction];
    }
    
    CMPrivateKey *pa = [[CMPrivateKey alloc] init];
    pa.authPrivateTerminalKey = terminalKey;
    
    [realm beginWriteTransaction];
    [realm addObject:pa];
    [realm commitWriteTransaction];
}

#pragma mark - 프라이빗 터미널 키 삭제
- (void)removePrivateTerminalKey
{
    RLMRealm *realm = [self cmRealm];
    
    if ( [[self getPrivateTerminalKey] length] > 0 )
    {
        RLMArray *all = (RLMArray *)[CMPrivateKey allObjects];
        [realm beginWriteTransaction];
        [realm deleteObjects:all];
        [realm commitWriteTransaction];
    }
}

#pragma mark - 프라이빗 터미널 키 관리
- (NSString *)getPrivateTerminalKey
{
    RLMArray *rs = (RLMArray *)[CMPrivateKey allObjects];
    if ( rs.count > 0 )
        return [((CMPrivateKey *)rs.lastObject).authPrivateTerminalKey copy];
    return @"";
}



#pragma mark - 페어링 유무 저장 
- (void)setPariringCheck:(BOOL)isParing
{
    RLMRealm *realm = [self cmRealm];
    
    NSString *sSetopbox = [NSString stringWithFormat:@"%@", [self getSetTopBoxKind]];
    
    RLMArray* all = (RLMArray*)[CMPairingInfo allObjects];
    if (all.count > 0) {
        [realm beginWriteTransaction];
        [realm deleteObjects:all];
        [realm commitWriteTransaction];
    }
    
    CMPairingInfo *pa = [[CMPairingInfo alloc] init];
    pa.isPairing = isParing;
    pa.sSetTopBoxKind = sSetopbox;
    
    [realm beginWriteTransaction];
    [realm addObject:pa];
    [realm commitWriteTransaction];
}

#pragma mark - 페어링 유무 체크
- (BOOL)getPairingCheck
{
    RLMArray *rs = (RLMArray *)[CMPairingInfo allObjects];
    if ( rs.count > 0 )
        return [((CMPairingInfo *)rs.lastObject) isPairing];
    return NO;
}

#pragma mark - 페어링 셋탑 종류 저장
- (void)setSetTopBoxKind:(NSString *)kind
{
    RLMRealm *realm = [self cmRealm];
    
    RLMArray* all = (RLMArray*)[CMPairingInfo allObjects];
    if (all.count > 0) {
        [realm beginWriteTransaction];
        [realm deleteObjects:all];
        [realm commitWriteTransaction];
    }

    CMPairingInfo *pairing =  [[CMPairingInfo alloc] init];
    // 지역코드/명 기본값.
    pairing.isPairing = YES;
    pairing.sSetTopBoxKind = kind;
    
    //1-2. 저장
    [realm beginWriteTransaction];
    [realm addObject:pairing];
    [realm commitWriteTransaction];

}

#pragma mark - 페어링 셋탑 종류 체크
- (NSString *)getSetTopBoxKind
{
    RLMArray *rs = (RLMArray *)[CMPairingInfo allObjects];
    if ( rs.count > 0 )
        return [((CMPairingInfo *)rs.lastObject).sSetTopBoxKind copy];
    return @"";
}

#pragma mark - 지역/상품 설정 관련 기본세팅
- (void)saveDefaultAeraCodeForce:(BOOL)isForce {
    
    BOOL isEmpty = YES;
    
    RLMRealm *realm = [self cmRealm];
    
    
    RLMArray* all = (RLMArray*)[CMAreaInfo allObjects];
    if (all.count > 0) {
        isEmpty = NO;
        if (isForce) {
            [realm beginWriteTransaction];
            [realm deleteObjects:all];
            [realm commitWriteTransaction];
        }
    }
    
    if (isForce || isEmpty) {
        CMAreaInfo *setting =  [[CMAreaInfo alloc] init];
        // 지역코드/명 기본값.
        setting.areaCode = @"0";
        setting.areaName = @"CnM";
        
        //1-2. 저장
        [realm beginWriteTransaction];
        [realm addObject:setting];
        [realm commitWriteTransaction];
    }
}

- (void)saveAreaCode:(NSString*)code name:(NSString*)name {
    if (code.length == 0 || name.length == 0) {
        return;
    }
    
    RLMRealm *realm = [self cmRealm];
    RLMArray* all = (RLMArray*)[CMAreaInfo allObjects];
    if (all.count > 0) {
        [realm beginWriteTransaction];
        [realm deleteObjects:all];
        [realm commitWriteTransaction];
    }
    CMAreaInfo *setting =  [[CMAreaInfo alloc] init];
    // 지역코드/명 기본값.
    setting.areaCode = code;
    setting.areaName = name;
    
    //1-2. 저장
    [realm beginWriteTransaction];
    [realm addObject:setting];
    [realm commitWriteTransaction];
}

- (CMAreaInfo*)currentAreaInfo {
    RLMArray* all = (RLMArray*)[CMAreaInfo allObjects];
    if (all.count > 0) {
        return all.lastObject;
    }
    return nil;
}

- (void)setFavorChannel:(NSDictionary *)data
{
    RLMRealm *realm = [self cmRealm];
    CMFavorChannelInfo *favorChannel = [[CMFavorChannelInfo alloc] init];

    favorChannel.pChannelId = [NSString stringWithFormat:@"%@", [data objectForKey:@"channelId"]];
    favorChannel.pChannelName = [NSString stringWithFormat:@"%@", [data objectForKey:@"channelName"]];
    favorChannel.pChannelNumber = [NSString stringWithFormat:@"%@", [data objectForKey:@"channelNumber"]];
    
    [realm beginWriteTransaction];
    [realm addObject:favorChannel];
    [realm commitWriteTransaction];
}

- (RLMArray *)getFavorChannel
{
    RLMArray *rs = (RLMArray *)[CMFavorChannelInfo allObjects];
    
    return rs;
}

- (void)removeFavorChannel:(int)index
{
    RLMRealm *realm = [self cmRealm];
    
    if ( [[self getFavorChannel] count] > 0 )
    {
        RLMArray *all = (RLMArray *)[CMFavorChannelInfo allObjects];
        [realm beginWriteTransaction];
        [realm deleteObject:[all objectAtIndex:index]];
        [realm commitWriteTransaction];
    }

}

- (void)setVodWatchList:(NSDictionary *)data
{
    NSString *sDataAsset = [NSString stringWithFormat:@"%@", [data objectForKey:@"assetId"]];
    
    RLMArray *rs = (RLMArray *)[CMVodWatchList allObjects];
    
    BOOL isCheck = NO;
    for ( CMVodWatchList *info in rs )
    {
        NSString *sAsset = [NSString stringWithFormat:@"%@", info.pAssetIdStr];
        
        if ( [sDataAsset isEqualToString:sAsset] )
            isCheck = YES;
    }
    
    if ( isCheck == NO )
    {
        RLMRealm *realm = [self cmRealm];
        CMVodWatchList *vodList = [[CMVodWatchList alloc] init];
        
        vodList.pAssetIdStr = [NSString stringWithFormat:@"%@", [data objectForKey:@"assetId"]];
        vodList.pTitleStr = [NSString stringWithFormat:@"%@", [data objectForKey:@"title"]];
        vodList.pWatchDateStr = [NSString stringWithFormat:@"%@", [data objectForKey:@"date"]];
        
        [realm beginWriteTransaction];
        [realm addObject:vodList];
        [realm commitWriteTransaction];
    }
}

- (RLMArray *)getVodWatchList
{
    RLMArray *rs = (RLMArray *)[CMVodWatchList allObjects];
    
    return rs;
}

- (void)removeVodWatchList:(int)index
{
    RLMRealm *realm = [self cmRealm];
    
    if ( [[self getVodWatchList] count] > 0 )
    {
        RLMArray *all = (RLMArray *)[CMVodWatchList allObjects];
        [realm beginWriteTransaction];
        [realm deleteObject:[all objectAtIndex:index]];
        [realm commitWriteTransaction];
    }

}

@end
