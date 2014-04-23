//
//  SCSGetInfoObjectOperation.m
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-10.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSGetInfoObjectOperation.h"

#import "SCSConnectionInfo.h"
#import "SCSBucket.h"
#import "SCSObject.h"
#import "SCSExtensions.h"

static NSString *SCSOperationInfoGetInfoObjectOperationObjectKey = @"SCSOperationInfoGetInfoObjectOperationObjectKey";

@implementation SCSGetInfoObjectOperation

- (id)initWithObject:(SCSObject *)o
{
    NSMutableDictionary *theOperationInfo = [[NSMutableDictionary alloc] init];
    if (o) {
        [theOperationInfo setObject:o forKey:SCSOperationInfoGetInfoObjectOperationObjectKey];
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
    return [theOperationInfo objectForKey:SCSOperationInfoGetInfoObjectOperationObjectKey];
}

- (NSString *)kind
{
	return SCSOperationKindObjectGetInfo;
}

- (NSString *)requestHTTPVerb
{
    return @"GET";
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

- (SCSObject *)objectInfo
{
    NSError *_error = nil;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:&_error];
    
    SCSObject *object = [[[SCSObject alloc] initWithBucket:nil
                                                       key:[self key]
                                       userDefinedMetadata:nil
                                                  metadata:json
                                            dataSourceInfo:nil] autorelease];

    
    return object;
}


@end
