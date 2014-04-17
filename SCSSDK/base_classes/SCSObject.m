//
//  SCSObject.m
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSObject.h"

NSString *SCSObjectFilePathDataSourceKey =           @"SCSObjectFilePathDataSourceKey";
NSString *SCSObjectNSDataSourceKey =                 @"SCSObjectNSDataSourceKey";


NSString *SCSUserDefinedObjectMetadataMissingKey =   @"x-amz-missing-meta";
NSString *SCSObjectMetadataETagKey =                 @"etag";
NSString *SCSObjectMetadataLastModifiedKey =         @"last-modified";
NSString *SCSObjectMetadataOwnerKey =                @"owner";

NSString *SCSObjectMetadataExpireKey =               @"x-sina-expire";
NSString *SCSObjectMetadataDecoveredKey =            @"x-sina-decovered";
NSString *SCSObjectMetadataChownKey =                @"x-sina-chown";
NSString *SCSObjectMetadataInfoKey =                 @"x-sina-info";
NSString *SCSObjectMetadataInfoIntKey =              @"x-sina-info-int";
NSString *SCSObjectMetadataCacheControlKey =         @"cache-control";
NSString *SCSObjectMetadataContentMD5Key =           @"content-md5";
NSString *SCSObjectMetadataContentTypeKey =          @"content-type";
NSString *SCSObjectMetadataContentLengthKey =        @"content-length";
NSString *SCSObjectMetadataSha1Key =                 @"s-sina-sha1";
NSString *SCSObjectMetadataLengthKey =               @"s-sina-length";
NSString *SCSObjectMetadataACLKey =                  @"x-amz-acl";
NSString *SCSObjectMetadataContentDispositionKey =   @"content-disposition";
NSString *SCSObjectMetadataContentEncodingKey =      @"content-encoding";
NSString *SCSUserDefinedObjectMetadataPrefixKey =    @"x-amz-meta-";


NSString *SCSResponseDataObjectMetadataACLKey =         @"acl";
NSString *SCSResponseDataObjectMetadataNameKey =        @"name";
NSString *SCSResponseDataObjectMetadataSha1Key =        @"sha1";
NSString *SCSResponseDataObjectMetadataContentSha1Key = @"content-sha1";
NSString *SCSResponseDataObjectMetadataMD5Key =         @"md5";
NSString *SCSResponseDataObjectMetadataFileNameKey =    @"file-name";
NSString *SCSResponseDataObjectMetadataInfoKey =        @"info";
NSString *SCSResponseDataObjectMetadataInfoIntKey =     @"info-int";
NSString *SCSResponseDataObjectMetadataSizeKey =        @"size";
NSString *SCSResponseDataObjectMetadataTypeKey =        @"type";
NSString *SCSResponseDataObjectMetadataExpireKey =      @"expiration-time";
NSString *SCSResponseDataObjectMetadataFileMetaKey =    @"file-meta";

@interface SCSObject ()

@property(readwrite, retain) SCSBucket *bucket;
@property(readwrite, copy) NSString *key;
@property(readwrite, copy) NSDictionary *userDefinedMetadata;
@property(readwrite, copy) NSDictionary *metadata;
@property(readwrite, copy) NSDictionary *dataSourceInfo;

@end


@implementation SCSObject

@synthesize bucket = _bucket;
@synthesize key = _key;
@synthesize metadata = _metadata;
@synthesize dataSourceInfo = _dataSourceInfo;

@synthesize aclDict = _aclDict;

- (id)initWithBucket:(SCSBucket *)bucket key:(NSString *)key userDefinedMetadata:(NSDictionary *)udmd metadata:(NSDictionary *)md dataSourceInfo:(NSDictionary *)info fastACL:(NSString *)acl {
    
    self = [super init];
    
    if (self != nil) {
        
        [self setKey:key];
        [self setBucket:bucket];
        
        NSMutableDictionary *processedMetadata = [NSMutableDictionary dictionaryWithCapacity:[md count]];
        NSEnumerator *metadataKeyEnumerator = [md keyEnumerator];
        
        NSString *key = nil;
        while (key = [metadataKeyEnumerator nextObject]) {
            
            NSString *cleanedKey = [key lowercaseString];
            id object = [md objectForKey:key];
            [processedMetadata setObject:object forKey:cleanedKey];
        }
        
        if (acl) {
            [self setAclDict:[[NSDictionary dictionaryWithObject:acl forKey:SCSObjectMetadataACLKey] retain]];
            [processedMetadata addEntriesFromDictionary:_aclDict];
        }
        
        [self setMetadata:[NSDictionary dictionaryWithDictionary:processedMetadata]];
        [self setUserDefinedMetadata:udmd];
        [self setDataSourceInfo:info];
        
        
    }
    
    return self;
}

- (id)initWithBucket:(SCSBucket *)bucket key:(NSString *)key userDefinedMetadata:(NSDictionary *)udmd metadata:(NSDictionary *)md dataSourceInfo:(NSDictionary *)info
{
    return [self initWithBucket:bucket key:key userDefinedMetadata:udmd metadata:md dataSourceInfo:info fastACL:nil];
}

- (id)initWithBucket:(SCSBucket *)bucket key:(NSString *)key userDefinedMetadata:(NSDictionary *)udmd metadata:(NSDictionary *)md
{
    return [self initWithBucket:bucket key:key userDefinedMetadata:udmd metadata:md dataSourceInfo:nil];
}

- (id)initWithBucket:(SCSBucket *)bucket key:(NSString *)key userDefinedMetadata:(NSDictionary *)udmd
{
    return [self initWithBucket:bucket key:key userDefinedMetadata:udmd metadata:nil];
}

- (id)initWithBucket:(SCSBucket *)bucket key:(NSString *)key
{
    return [self initWithBucket:bucket key:key userDefinedMetadata:nil];
}

- (void)dealloc
{
	[_bucket release];
    [_key release];
	[_dataSourceInfo release];
	[_metadata release];
	[super dealloc];
}

- (NSDictionary *)userDefinedMetadata
{
    NSMutableDictionary *mutableDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSString *metadataKey = nil;
    NSEnumerator *metadataKeyEnumerator = [[self metadata] keyEnumerator];
    NSRange notFoundRange = NSMakeRange(NSNotFound, 0);
    
    while (metadataKey = [metadataKeyEnumerator nextObject]) {
        
        NSRange foundRange = [metadataKey rangeOfString:SCSUserDefinedObjectMetadataPrefixKey options:NSAnchoredSearch];
        
        if ([metadataKey isKindOfClass:[NSString class]] == YES && NSEqualRanges(foundRange, notFoundRange) == NO) {
            
            id object = [[self metadata] objectForKey:metadataKey];
            NSString *userDefinatedMetadataKey = [metadataKey stringByReplacingCharactersInRange:foundRange withString:@""];
            [mutableDictionary setObject:object forKey:userDefinatedMetadataKey];
        }
    }
    return [[mutableDictionary copy] autorelease];
}

- (void)setUserDefinedMetadata:(NSDictionary *)md
{
    NSMutableDictionary *mutableMetadata = [[self metadata] mutableCopy];
    NSString *metadataKey = nil;
    NSEnumerator *metadataKeyEnumerator = [md keyEnumerator];
    while (metadataKey = [metadataKeyEnumerator nextObject]) {
        if ([metadataKey isKindOfClass:[NSString class]] == YES) {
            id object = [md objectForKey:metadataKey];
            NSString *modifiedMetadataKey = [NSString stringWithFormat:@"%@%@", SCSUserDefinedObjectMetadataPrefixKey, metadataKey];
            [mutableMetadata setObject:object forKey:modifiedMetadataKey];
        }
    }
    [self setMetadata:mutableMetadata];
}

- (id)valueForUndefinedKey:(NSString *)key
{
    id o = [[self metadata] objectForKey:key];
	if (o != nil) {
		return o;
    }
    
    return [super valueForUndefinedKey:key];
}

- (void)setAclDict:(NSDictionary *)aclDict {
    
    [_aclDict release];
    _aclDict = aclDict;
}

- (NSDictionary *)aclDict {
    
    return _aclDict;
}

- (NSString *)acl
{
    if ([[self metadata] objectForKey:SCSObjectMetadataACLKey]) {
        return [[self metadata] objectForKey:SCSObjectMetadataACLKey];
    }else if ([[self metadata] objectForKey:SCSResponseDataObjectMetadataACLKey]) {
        return [[self metadata] objectForKey:SCSResponseDataObjectMetadataACLKey];
    }else {
        return nil;
    }
}

- (NSString *)contentMD5
{
    if ([[self metadata] objectForKey:SCSObjectMetadataContentMD5Key]) {
        return [[self metadata] objectForKey:SCSObjectMetadataContentMD5Key];
    }else if ([[self metadata] objectForKey:SCSResponseDataObjectMetadataMD5Key]) {
        return [[self metadata] objectForKey:SCSResponseDataObjectMetadataMD5Key];
    }else {
        return nil;
    }
}

- (NSString *)contentType
{
    if ([[self metadata] objectForKey:SCSObjectMetadataContentTypeKey]) {
        return [[self metadata] objectForKey:SCSObjectMetadataContentTypeKey];
    }else if ([[self metadata] objectForKey:SCSResponseDataObjectMetadataTypeKey]) {
        return [[self metadata] objectForKey:SCSResponseDataObjectMetadataTypeKey];
    }else {
        return nil;
    }
}

- (NSString *)contentLength
{
    if ([[self metadata] objectForKey:SCSObjectMetadataContentLengthKey]) {
        return [[self metadata] objectForKey:SCSObjectMetadataContentLengthKey];
    }else if ([[self metadata] objectForKey:SCSResponseDataObjectMetadataSizeKey]) {
        return [[self metadata] objectForKey:SCSResponseDataObjectMetadataSizeKey];
    }else {
        return nil;
    }
}

- (NSString *)etag
{
    return [[self metadata] objectForKey:SCSObjectMetadataETagKey];
}

- (NSString *)lastModified
{
    return [[self metadata] objectForKey:SCSObjectMetadataLastModifiedKey];
}

- (SCSOwner *)owner
{
    return [[self metadata] objectForKey:SCSObjectMetadataOwnerKey];
}

- (BOOL)missingMetadata;
{
    id object = [[self metadata] objectForKey:SCSUserDefinedObjectMetadataMissingKey];
    return (object == nil ? NO : YES);
}

- (NSString *)sha1
{
    if ([[self metadata] objectForKey:SCSObjectMetadataSha1Key]) {
        return [[self metadata] objectForKey:SCSObjectMetadataSha1Key];
    }else if ([[self metadata] objectForKey:SCSResponseDataObjectMetadataSha1Key]) {
        return [[self metadata] objectForKey:SCSResponseDataObjectMetadataSha1Key];
    }else if ([[self metadata] objectForKey:SCSResponseDataObjectMetadataContentSha1Key]) {
        return [[self metadata] objectForKey:SCSResponseDataObjectMetadataContentSha1Key];
    }else {
        return nil;
    }
}

- (NSString *)expire
{
    if ([[self metadata] objectForKey:SCSObjectMetadataExpireKey]) {
        return [[self metadata] objectForKey:SCSObjectMetadataExpireKey];
    }else if ([[self metadata] objectForKey:SCSResponseDataObjectMetadataExpireKey]) {
        return [[self metadata] objectForKey:SCSResponseDataObjectMetadataExpireKey];
    }else {
        return nil;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self retain];
}

- (NSString *)description {
    
    NSString *metadataKey = nil;
    NSEnumerator *metadataKeyEnumerator = [[[self metadata] objectForKey:SCSResponseDataObjectMetadataFileMetaKey] keyEnumerator];
    NSRange notFoundRange = NSMakeRange(NSNotFound, 0);
    
    NSMutableString *userDefinedPropString = [[[NSMutableString alloc] init] autorelease];
    
    while (metadataKey = [metadataKeyEnumerator nextObject]) {
        
        NSRange foundRange = [metadataKey rangeOfString:SCSUserDefinedObjectMetadataPrefixKey options:NSAnchoredSearch];
        
        if ([metadataKey isKindOfClass:[NSString class]] == YES && NSEqualRanges(foundRange, notFoundRange) == NO) {
            
            [userDefinedPropString appendString:[NSString stringWithFormat:@"Object %@ : %@\n", metadataKey, [[[self metadata] objectForKey:SCSResponseDataObjectMetadataFileMetaKey] objectForKey:metadataKey]]];
        }
    }
    
    return [NSString stringWithFormat:@"Object key: %@\nObject type : %@\nObject creationDate: %@\nObject size : %@\nObject owner : %@\nObject MD5 : %@\nObject sha1 : %@\nObject expirationTime : %@\nUserDefined :\n%@\n", [self key], [self contentType], [self lastModified], [self contentLength], [self owner], [self contentMD5], [self sha1], [self expire], userDefinedPropString];
}

@end
