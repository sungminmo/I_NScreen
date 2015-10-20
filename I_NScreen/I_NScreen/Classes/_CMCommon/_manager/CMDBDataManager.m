//
//  CMDBDataManager.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMDBDataManager.h"

#import <Realm/Realm.h>
#import "CMPurchaseAuthorize.h"
#import "CMAreaInfo.h"

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
        setting.areaCode = @"12";
        setting.areaName = @"송파";
        
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

@end
