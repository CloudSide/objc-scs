//
//  SCSDeleteObjectOperation.m
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSDeleteObjectOperation.h"

#import "SCSConnectionInfo.h"
#import "SCSBucket.h"
#import "SCSObject.h"

static NSString *SCSOperationInfoDeleteObjectOperationObjectKey = @"SCSOperationInfoDeleteObjectOperationObjectKey";

@implementation SCSDeleteObjectOperation


- (id)initWithObject:(SCSObject *)o
{
    NSMutableDictionary *theOperationInfo = [[NSMutableDictionary alloc] init];
    if (o) {
        [theOperationInfo setObject:o forKey:SCSOperationInfoDeleteObjectOperationObjectKey];
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
    return [theOperationInfo objectForKey:SCSOperationInfoDeleteObjectOperationObjectKey];
}

- (NSString *)kind
{
	return @"Object deletion";
}

- (NSString *)requestHTTPVerb
{
    return @"DELETE";
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

@end
