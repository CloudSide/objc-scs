//
//  SCSUpdateObjectOperation.m
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-9.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSUpdateObjectOperation.h"

#import "SCSConnectionInfo.h"
#import "SCSBucket.h"
#import "SCSObject.h"
#import "SCSExtensions.h"

static NSString *SCSOperationInfoUpdateObjectOperationObjectKey = @"SCSOperationInfoUpdateObjectOperationObjectKey";

@implementation SCSUpdateObjectOperation

- (id)initWithObject:(SCSObject *)o
{
    NSMutableDictionary *theOperationInfo = [[NSMutableDictionary alloc] init];
    if (o) {
        [theOperationInfo setObject:o forKey:SCSOperationInfoUpdateObjectOperationObjectKey];
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
    return [theOperationInfo objectForKey:SCSOperationInfoUpdateObjectOperationObjectKey];
}

- (NSString *)kind
{
	return @"Object update";
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
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNull null], @"meta", nil];
    
}

- (NSString *)requestBodyContentMD5
{
    SCSObject *object = [self object];
    
    return [[object metadata] objectForKey:SCSObjectMetadataContentMD5Key];
}

@end
