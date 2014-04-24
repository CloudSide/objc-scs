//
//  SCSAddObjectOperation.m
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSAddObjectOperation.h"

#import "SCSConnectionInfo.h"
#import "SCSBucket.h"
#import "SCSObject.h"
#import "SCSExtensions.h"

static NSString *SCSOperationInfoAddObjectOperationObjectKey = @"SCSOperationInfoAddObjectOperationObjectKey";

@implementation SCSAddObjectOperation


- (id)initWithObject:(SCSObject *)o
{
    NSMutableDictionary *theOperationInfo = [[NSMutableDictionary alloc] init];
    if (o) {
        [theOperationInfo setObject:o forKey:SCSOperationInfoAddObjectOperationObjectKey];
    }
    
    self = [super initWithOperationInfo:theOperationInfo];
    
    [theOperationInfo release];
    
    if (self != nil) {
        
    }
    
	return self;
}

- (SCSObject *)object
{
    NSDictionary *theOperationInfo = [self operationInfo];
    return [theOperationInfo objectForKey:SCSOperationInfoAddObjectOperationObjectKey];
}

- (NSString *)kind
{
	return SCSOperationKindObjectAdd;
}

- (NSString *)requestHTTPVerb
{
    return @"PUT";
}

- (NSDictionary *)additionalHTTPRequestHeaders
{
    SCSObject *object = [self object];
    
    return [object metadata];
}

- (BOOL)virtuallyHostedCapable
{
	return [[[self object] bucket] virtuallyHostedCapable];
}

- (NSString *)bucketName
{
    SCSObject *object = [self object];
    
    return [[object bucket] name];
}

- (NSString *)key
{
    SCSObject *object = [self object];
    
    return [object key];
}

- (NSDictionary *)requestQueryItems
{
    return nil;
}

- (NSString *)requestBodyContentMD5
{
    SCSObject *object = [self object];
    
    return [[object metadata] objectForKey:SCSObjectMetadataContentMD5Key];
}

- (NSData *)requestBodyContentData
{
    SCSObject *object = [self object];
    
    return [[object dataSourceInfo] objectForKey:SCSObjectNSDataSourceKey];
}

- (NSString *)requestBodyContentFilePath
{
    SCSObject *object = [self object];
    
    return [[object dataSourceInfo] objectForKey:SCSObjectFilePathDataSourceKey];
}

- (NSString *)requestBodyContentType
{
    SCSObject *object = [self object];
    
    return [[object metadata] objectForKey:SCSObjectMetadataContentTypeKey];
}

- (NSUInteger)requestBodyContentLength
{
    SCSObject *object = [self object];
    
    NSNumber *length = [[object metadata] objectForKey:SCSObjectMetadataContentLengthKey];
    if (length != nil) {
        return [length unsignedIntegerValue];
    }
    
    if ([self requestBodyContentData] != nil) {
        return [[self requestBodyContentData] length];
    } else if ([self requestBodyContentFilePath] != nil) {
        return [[[self requestBodyContentFilePath] fileSizeForPath] unsignedIntegerValue];
    }
    
    return 0;
}

@end
