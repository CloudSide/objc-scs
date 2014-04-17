//
//  SCSAddBucketOperation.m
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSAddBucketOperation.h"
#import "SCSBucket.h"

static NSString *SCSOperationInfoAddBucketOperationBucketKey = @"SCSOperationInfoAddBucketOperationBucketKey";

@implementation SCSAddBucketOperation

@dynamic bucket;

- (id)initWithBucket:(SCSBucket *)b;
{
    NSMutableDictionary *theOperationInfo = [[NSMutableDictionary alloc] init];
    
    if (b) {
        [theOperationInfo setObject:b forKey:SCSOperationInfoAddBucketOperationBucketKey];
    }
    
    self = [super initWithOperationInfo:theOperationInfo];
    
    [theOperationInfo release];
    
    if (self != nil) {
        
    }
    
	return self;
}

- (SCSBucket *)bucket
{
    NSDictionary *theOperationInfo = [self operationInfo];
    return [theOperationInfo objectForKey:SCSOperationInfoAddBucketOperationBucketKey];
}

- (NSString *)kind
{
	return @"Bucket addition";
}

- (NSString *)requestHTTPVerb
{
    return @"PUT";
}

- (BOOL)virtuallyHostedCapable
{
	return [[self bucket] virtuallyHostedCapable];
}

- (NSString *)bucketName
{
    return [[self bucket] name];
}

- (NSDictionary *)additionalHTTPRequestHeaders {

    return [[self bucket] aclDict];
}

- (NSData *)requestBodyContentData
{
    return nil;
}

- (NSUInteger)requestBodyContentLength
{
    NSData *contents = [self requestBodyContentData];
    if (!contents) {
        return 0;
    }
    return [contents length];
}

@end
