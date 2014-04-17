//
//  SCSDeleteBucketOperation.m
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSDeleteBucketOperation.h"

static NSString *SCSOperationInfoDeleteBucketOperationBucketKey = @"SCSOperationInfoDeleteBucketOperationBucketKey";

@implementation SCSDeleteBucketOperation

@dynamic bucket;


- (id)initWithBucket:(SCSBucket *)b
{
    NSMutableDictionary *theOperationInfo = [[NSMutableDictionary alloc] init];
    
    if (b) {
        [theOperationInfo setObject:b forKey:SCSOperationInfoDeleteBucketOperationBucketKey];
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
    return [theOperationInfo objectForKey:SCSOperationInfoDeleteBucketOperationBucketKey];
}

- (NSString*)kind
{
	return @"Bucket deletion";
}

- (NSString *)requestHTTPVerb
{
    return @"DELETE";
}

- (BOOL)virtuallyHostedCapable
{
	return [[self bucket] virtuallyHostedCapable];
}

- (NSString *)bucketName
{
    return [[self bucket] name];
}

@end
