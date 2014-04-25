//
//  SCSConnectionInfo.m
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-3-31.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSConnectionInfo.h"
#import "SCSOperation.h"
#import "SCSExtensions.h"
#import "SCSMutableConnectionInfo.h"
#import "SCSObject.h"

NSString *SCSDefaultHostString =            @"sinastorage.com";
NSInteger SCSDefaultInsecurePortInteger =   80;
NSInteger SCSDefaultSecurePortInteger =     443;
NSString *SCSInsecureHTTPProtocolString =   @"http";
NSString *SCSSecureHTTPProtocolString =     @"https";

NSString *SCSHeaderACLString =              @"x-amz-acl";
NSString *SCSHeaderPrefixString =           @"x-amz-";
NSString *SCSHeaderPrefixStringSina =       @"x-sina-";


static SCSConnectionInfo *kSharedConnectionInfo = nil;


@interface SCSConnectionInfo (SCSMutableConnectionInfoExtensionMethods)

- (void)setDelegate:(id)delegate;
- (void)setUserInfo:(NSDictionary *)userInfo;
- (void)setSecureConnection:(BOOL)secure;
- (void)setPortNumber:(int)portNumber;
- (void)setVirtuallyHosted:(BOOL)yesOrNo;
- (void)setHostEndpoint:(NSString *)host;

@end

@implementation SCSConnectionInfo

+ (SCSConnectionInfo *)sharedConnectionInfo {
    
    return kSharedConnectionInfo;
}

+ (void)setSharedConnectionInfo:(SCSConnectionInfo *)connectionInfo {
    
    if (connectionInfo == kSharedConnectionInfo) return;
    
    [kSharedConnectionInfo release];
    kSharedConnectionInfo = [connectionInfo retain];
}

- (void)dealloc
{
    [self setUserInfo:nil];
    [self setHostEndpoint:nil];
    
	[super dealloc];
}

- (id)initWithAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey userInfo:(id)userInfo secureConnection:(BOOL)secureConnection portNumber:(int)portNumber virtuallyHosted:(BOOL)virtuallyHosted hostEndpoint:(NSString *)host
{
    self = [super init];
    
    if (self != nil) {

        [self setUserInfo:userInfo];
        [self setSecureConnection:secureConnection];
        [self setPortNumber:portNumber];
        [self setVirtuallyHosted:virtuallyHosted];
        [self setHostEndpoint:host];
        [self setAccessKey:accessKey];
        [self setSecretKey:secretKey];
    }
    return self;
}

- (id)initWithAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey userInfo:(id)userInfo secureConnection:(BOOL)secureConnection portNumber:(int)portNumber virtuallyHosted:(BOOL)virtuallyHosted
{
    return [self initWithAccessKey:accessKey secretKey:secretKey userInfo:userInfo secureConnection:secureConnection portNumber:portNumber virtuallyHosted:virtuallyHosted hostEndpoint:SCSDefaultHostString];
}

- (id)initWithAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey userInfo:(id)userInfo secureConnection:(BOOL)secureConnection portNumber:(int)portNumber
{
    return [self initWithAccessKey:accessKey secretKey:secretKey userInfo:userInfo secureConnection:secureConnection portNumber:portNumber virtuallyHosted:YES];
}

- (id)initWithAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey userInfo:(id)userInfo secureConnection:(BOOL)secureConnection
{
    return [self initWithAccessKey:accessKey secretKey:secretKey userInfo:userInfo secureConnection:secureConnection portNumber:0];
}

- (id)initWithAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey userInfo:(id)userInfo
{
    return [self initWithAccessKey:accessKey secretKey:secretKey userInfo:userInfo secureConnection:NO];
}

- (id)initWithAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey
{
    return [self initWithAccessKey:accessKey secretKey:secretKey userInfo:nil];
}

- (id)init
{
    return [self initWithAccessKey:nil secretKey:nil];
}

- (void)setAccessKey:(NSString *)accessKey {
    
    accessKey = [accessKey copy];
    [_accessKey release];
    _accessKey = accessKey;
}

- (NSString *)accessKey {
    
    return _accessKey;
}

- (void)setSecretKey:(NSString *)secretKey {
    
    secretKey = [secretKey copy];
    [_secretKey release];
    _secretKey = secretKey;
}

- (NSString *)secretKey {

    return _secretKey;
}

- (void)setSecureConnection:(BOOL)secure
{
    if (secure == NO) {
        [self setPortNumber:(int)SCSDefaultInsecurePortInteger];
    } else {
        [self setPortNumber:(int)SCSDefaultSecurePortInteger];
    }
    _secure = secure;
}

- (BOOL)secureConnection
{
    return _secure;
}

- (void)setPortNumber:(int)portNumber
{
    if (portNumber == 0) {
        [self setSecureConnection:[self secureConnection]];
        return;
    }
    _portNumber = portNumber;
}

- (int)portNumber
{
    return _portNumber;
}

- (void)setHostEndpoint:(NSString *)host
{
    host = [host copy];
    [_host release];
    _host = host;
}

- (NSString *)hostEndpoint
{
    return _host;
}

- (void)setVirtuallyHosted:(BOOL)yesOrNo
{
    _virtuallyHosted = yesOrNo;
}

- (BOOL)virtuallyHosted
{
    return _virtuallyHosted;
}

- (void)setUserInfo:(NSDictionary *)userInfo
{
    [userInfo retain];
    [_userInfo release];
    _userInfo = userInfo;
}

- (NSDictionary *)userInfo
{
    return _userInfo;
}

- (NSString *)signature:(NSString *)stringToSign {
    
    return [[[[stringToSign dataUsingEncoding:NSUTF8StringEncoding] sha1HMacWithKey:self.secretKey] encodeBase64] substringWithRange:NSMakeRange(5, 10)];
}

- (CFHTTPMessageRef)newCFHTTPMessageRefFromOperation:(SCSOperation *)operation
{
    // Build string to sign
    NSMutableString *stringToSign = [NSMutableString string];
    
    //HTTP Verb
    [stringToSign appendFormat:@"%@\n", ([operation requestHTTPVerb] ? [operation requestHTTPVerb] : @"")];
    
    //Content MD5
    NSString *sinaSha1 = [[operation additionalHTTPRequestHeaders] objectForKey:SCSObjectMetadataSha1Key];
    NSString *md5 = [[operation additionalHTTPRequestHeaders] objectForKey:SCSObjectMetadataContentMD5Key];
    
    if (sinaSha1 == nil) {
        if (md5 == nil) {
            md5 = [operation requestBodyContentMD5];
            [stringToSign appendFormat:@"%@\n", md5 ? md5 : @""];
        }else {
            [stringToSign appendFormat:@"%@\n", md5];
        }
    }else  {
        [stringToSign appendFormat:@"%@\n", sinaSha1];
    }
    
    //Content Type
    NSString *contentType = [[operation additionalHTTPRequestHeaders] objectForKey:SCSObjectMetadataContentTypeKey];
    if (contentType == nil) {
        contentType = [operation requestBodyContentType];
    }
    [stringToSign appendFormat:@"%@\n", (contentType ? contentType : @"")];
    
    //Date
    [stringToSign appendFormat:@"%@\n", [[operation date] stringWithRFC822Format]];

    //CanonicalizedAmzHeaders
    NSEnumerator *e = [[[[operation additionalHTTPRequestHeaders] allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
    NSString *key = nil;
	while (key = [e nextObject])
	{
		id object = [[operation additionalHTTPRequestHeaders] objectForKey:key];
        NSString *lowerCaseKey = [key lowercaseString];
		if ([key hasPrefix:SCSHeaderPrefixString] || [key hasPrefix:SCSHeaderPrefixStringSina]) {
			[stringToSign appendFormat:@"%@:%@\n", lowerCaseKey, object];
        }
	}
    
    //CanonicalizedResourse
    NSURL *requestURL = [operation url];
    NSString *requestQuery = [requestURL query];
    NSString *requestPath = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)[requestURL path], NULL, (CFStringRef)@"[]#%?,$+=&@:;()'*!", kCFStringEncodingUTF8) autorelease];
    NSString *absoluteString = [requestURL absoluteString];
    if (requestQuery != nil) {
        NSString *withoutQuery = [absoluteString stringByReplacingOccurrencesOfString:requestQuery withString:@""];
        if ([requestPath hasSuffix:@"/"] == NO && [withoutQuery hasSuffix:@"/?"] == YES) {
            requestPath = [NSString stringWithFormat:@"%@/", requestPath];
        }
    } else if ([requestPath hasSuffix:@"/"] == NO && [absoluteString hasSuffix:@"/"] == YES) {
        requestPath = [NSString stringWithFormat:@"%@/", requestPath];
    }
    
    if (([operation isRequestOnService] == NO) && ([self virtuallyHosted] == YES) && [operation virtuallyHostedCapable]) {
        requestPath = [NSString stringWithFormat:@"/%@%@", [operation bucketName], requestPath];
    }
    
    [stringToSign appendString:requestPath];

    NSString *requestURLQueryLower = [[requestURL query] lowercaseString];
    
    if ([requestURLQueryLower hasPrefix:@"acl"]) {
        [stringToSign appendString:@"?acl"];
    } else if ([requestURLQueryLower  hasPrefix:@"torrent"]) {
        [stringToSign appendString:@"?torrent"];
    } else if ([requestURLQueryLower  hasPrefix:@"location"]) {
        [stringToSign appendString:@"?location"];
    } else if ([requestURLQueryLower  hasPrefix:@"logging"]) {
        [stringToSign appendString:@"?logging"];
    } else if ([requestURLQueryLower  hasPrefix:@"relax"]) {
        [stringToSign appendString:@"?relax"];
    } else if ([requestURLQueryLower  hasPrefix:@"meta"]) {
        [stringToSign appendString:@"?meta"];
    } else if ([requestURLQueryLower  hasPrefix:@"uploads"]) {
        [stringToSign appendString:@"?uploads"];
    } else if ([requestURLQueryLower  hasPrefix:@"part"]) {
        [stringToSign appendString:@"?part"];
    } else if ([requestURLQueryLower  hasPrefix:@"copy"]) {
        [stringToSign appendString:@"?copy"];
    } else if ([requestURLQueryLower  hasPrefix:@"website"]) {
        [stringToSign appendString:@"?website"];
    } else if ([requestURLQueryLower  hasPrefix:@"multipart"]) {
        [stringToSign appendString:@"?multipart"];
    }
    
    
    NSArray *array = [stringToSign componentsSeparatedByString:@"?"];
    
    if ([array count] == 1) {
        
        //without acl...
        
        NSArray *qa = [requestURLQueryLower componentsSeparatedByString:@"&"];
        NSArray *resultArray = [qa sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            NSComparisonResult result = [obj1 compare:obj2];
            return result == NSOrderedDescending; // 升序
            //return result == NSOrderedAscending;// 降序
        }];
        
        for (NSString *str in resultArray) {
            
            if ([str hasPrefix:@"ip"] || [str hasPrefix:@"uploadid"] || [str hasPrefix:@"partnumber"]) {
                [stringToSign appendString:str];
            }
        }
        
    }else {
        
        NSString *ps = [array objectAtIndex:1];
        requestURLQueryLower = [requestURLQueryLower substringWithRange:NSMakeRange([ps length], [requestURLQueryLower length]-[ps length])];
        
        NSArray *qa = [requestURLQueryLower componentsSeparatedByString:@"&"];
        NSArray *resultArray = [qa sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            NSComparisonResult result = [obj1 compare:obj2];
            return result == NSOrderedDescending; // 升序
            //return result == NSOrderedAscending;// 降序
        }];
        
        for (NSString *str in resultArray) {
            if ([str hasPrefix:@"ip"] || [str hasPrefix:@"uploadid"] || [str hasPrefix:@"partnumber"]) {
                [stringToSign appendString:str];
            }
        }
    }
    
    NSLog(@"%@", stringToSign);
    
    CFHTTPMessageRef httpRequest = NULL;
    NSString *authorization = nil;
    
        
    NSString *accessKey = [self accessKey];
    NSString *secretAccessKey = [self secretKey];
    
    if (accessKey == nil || secretAccessKey == nil) {
        return NULL;
    }
    
    NSString *signature = [self signature:stringToSign];
    secretAccessKey = nil;
    authorization = [NSString stringWithFormat:@"SINA %@:%@", accessKey, signature];
    
    
    httpRequest = CFHTTPMessageCreateRequest(kCFAllocatorDefault, (CFStringRef)[operation requestHTTPVerb], (CFURLRef)requestURL, kCFHTTPVersion1_1);
    e = [[[operation additionalHTTPRequestHeaders] allKeys] objectEnumerator];
    key = nil;
	while (key = [e nextObject])
	{
		id object = [[operation additionalHTTPRequestHeaders] objectForKey:key];
        CFHTTPMessageSetHeaderFieldValue(httpRequest, (CFStringRef)key, (CFStringRef)[NSString stringWithFormat:@"%@", object]);
	}
    
    if ([[operation additionalHTTPRequestHeaders] objectForKey:SCSObjectMetadataContentLengthKey] == nil) {
        NSNumber *contentLength = [NSNumber numberWithLongLong:[operation requestBodyContentLength]];
        CFHTTPMessageSetHeaderFieldValue(httpRequest, (CFStringRef)SCSObjectMetadataContentLengthKey, (CFStringRef)[contentLength stringValue]);
    }
    
    if ([[operation additionalHTTPRequestHeaders] objectForKey:SCSObjectMetadataContentTypeKey] == nil) {
        if (contentType != nil) {
            CFHTTPMessageSetHeaderFieldValue(httpRequest, (CFStringRef)SCSObjectMetadataContentTypeKey, (CFStringRef)contentType);
        }
    }
    
    if ([[operation additionalHTTPRequestHeaders] objectForKey:SCSObjectMetadataContentMD5Key] == nil) {
        if (md5 != nil) {
            CFHTTPMessageSetHeaderFieldValue(httpRequest, (CFStringRef)SCSObjectMetadataContentMD5Key, (CFStringRef)md5);
        }
    }
    
    // Add the "Expect: 100-continue" header
    CFHTTPMessageSetHeaderFieldValue(httpRequest, (CFStringRef)@"Expect", (CFStringRef)@"100-continue");
    
    CFHTTPMessageSetHeaderFieldValue(httpRequest, (CFStringRef)@"Date", (CFStringRef)[[operation date] stringWithRFC822Format]);
    CFHTTPMessageSetHeaderFieldValue(httpRequest, (CFStringRef)@"Authorization", (CFStringRef)authorization);
    
    
    return httpRequest;
}

#pragma mark -
#pragma mark Copying Protocol Methods

- (id)copyWithZone:(NSZone *)zone
{
    SCSConnectionInfo *newObject = [[SCSConnectionInfo allocWithZone:zone] initWithAccessKey:[self accessKey]
                                                                                   secretKey:[self secretKey]
                                                                                    userInfo:[self userInfo]
                                                                            secureConnection:[self secureConnection]
                                                                                  portNumber:[self portNumber]
                                                                             virtuallyHosted:[self virtuallyHosted]
                                                                                hostEndpoint:[self hostEndpoint]];
    return newObject;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    SCSMutableConnectionInfo *newObject = [[SCSMutableConnectionInfo allocWithZone:zone] initWithAccessKey:[self accessKey]
                                                                                                 secretKey:[self secretKey]
                                                                                                  userInfo:[self userInfo]
                                                                                          secureConnection:[self secureConnection]
                                                                                                portNumber:[self portNumber]
                                                                                           virtuallyHosted:[self virtuallyHosted]
                                                                                              hostEndpoint:[self hostEndpoint]];
    return newObject;
}

#pragma mark -
#pragma mark Equality Methods

- (BOOL)isEqual:(id)anObject
{
    if (anObject && [anObject isKindOfClass:[SCSConnectionInfo class]]) {
        if ([anObject accessKey] == [self accessKey] &&
            [anObject secretKey] == [self secretKey] &&
            (([anObject userInfo] == nil && [self userInfo] == nil) ||
             [[anObject userInfo] isEqual:[self userInfo]]) &&
            [anObject secureConnection] == [self secureConnection] &&
            [anObject portNumber] == [self portNumber] &&
            [anObject virtuallyHosted] == [self virtuallyHosted] &&
            (([anObject hostEndpoint] == nil && [self hostEndpoint] == nil) ||
             [[anObject hostEndpoint] isEqual:[self hostEndpoint]])) {
                return YES;
            }
    }
    
    return NO;
}


- (NSUInteger)hash
{
    NSUInteger value = 0;
    
    value += value * 37 + [[self accessKey] hash];
    value += value * 37 + [[self secretKey] hash];
    value += value * 37 + [[self userInfo] hash];
    value += value * 37 + ([self secureConnection] ? 1 : 2);
    
    return value;
}

#pragma mark -
#pragma mark Description Method

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: -\n accessKey:%@\n secretKey:%@\n userInfo:%@\n secureConnection:%d\n portNumber:%d\n virtuallyHosted:%d\n hostEndpoint:%@\n>", [self class], [self accessKey], [self secretKey], [self userInfo], [self secureConnection], [self portNumber], [self virtuallyHosted], [self hostEndpoint]];
}

#pragma mark -
#pragma mark Sign

- (NSURL *)publicURLWithBucket:(NSString *)bucket object:(NSString *)object security:(BOOL)security {

    NSString *urlString = [NSString stringWithFormat:@"%@://%@.%@/%@?formatter=json", security ? SCSSecureHTTPProtocolString : SCSInsecureHTTPProtocolString,
                                                                                     bucket,
                                                                                     SCSDefaultHostString,
                                                                                     object ? [object stringByEscapingHTTPReserved] : @""];
    
    return [NSURL URLWithString:urlString];
}

- (NSURL *)authorizationURLWithBucket:(NSString *)bucket object:(NSString *)object expires:(NSDate *)expires ip:(NSString *)ip security:(BOOL)security {

    
    NSString *kid = [NSString stringWithFormat:@"sina,%@", self.accessKey];
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@://%@.%@/%@?formatter=json&Expires=%ld&KID=%@", security ? SCSSecureHTTPProtocolString : SCSInsecureHTTPProtocolString,
                                                                bucket,
                                                                SCSDefaultHostString,
                                                                object ? [object stringByEscapingHTTPReserved] : @"",
                                                                (long)[expires timeIntervalSince1970],
                                                                kid];

    
    // Build string to sign
    NSMutableString *stringToSign = [NSMutableString stringWithFormat:@"GET\n\n\n%ld\n", (long)[expires timeIntervalSince1970]];
    
    [stringToSign appendFormat:@"/%@/%@", bucket, object ? [object stringByEscapingHTTPReserved] : @""];
    
    if (ip && [ip isKindOfClass:[NSString class]] && [ip length] > 0) {
        
        [stringToSign appendFormat:@"?ip=%@", ip];
        [urlString appendFormat:@"&ip=%@", ip];
    }
    
    [urlString appendFormat:@"&ssig=%@", [[self signature:stringToSign] URLEncodedString]];
    
    return [NSURL URLWithString:urlString];
}


@end
