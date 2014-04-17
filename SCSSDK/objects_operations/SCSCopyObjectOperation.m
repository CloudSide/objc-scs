//
//  SCSCopyObjectOperation.m
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSCopyObjectOperation.h"

#import "SCSConnectionInfo.h"
#import "SCSBucket.h"
#import "SCSObject.h"
#import "SCSExtensions.h"


static NSString *SCSOperationInfoCopyObjectOperationSourceObjectKey = @"SCSOperationInfoCopyObjectOperationSourceObjectKey";
static NSString *SCSOperationInfoCopyObjectOperationDestinationObjectKey = @"SCSOperationInfoCopyObjectOperationDestinationObjectKey";

@implementation SCSCopyObjectOperation


- (id)initWithObjectfrom:(SCSObject *)source to:(SCSObject *)destination
{
    NSMutableDictionary *theOperationInfo = [[NSMutableDictionary alloc] init];
    if (source) {
        [theOperationInfo setObject:source forKey:SCSOperationInfoCopyObjectOperationSourceObjectKey];
    }
    if (destination) {
        [theOperationInfo setObject:destination forKey:SCSOperationInfoCopyObjectOperationDestinationObjectKey];
    }
    
    self = [super initWithOperationInfo:theOperationInfo];
    
    [theOperationInfo release];
    
    if (self != nil) {
        
    }
    
	return self;
}

- (SCSObject *)sourceObject
{
    NSDictionary *theOperationInfo = [self operationInfo];
    return [theOperationInfo objectForKey:SCSOperationInfoCopyObjectOperationSourceObjectKey];
}

- (SCSObject *)destinationObject
{
    NSDictionary *theOperationInfo = [self operationInfo];
    return [theOperationInfo objectForKey:SCSOperationInfoCopyObjectOperationDestinationObjectKey];
}

- (NSString *)kind
{
	return @"Object copy";
}

- (NSString *)requestHTTPVerb
{
    return @"PUT";
}

- (NSDictionary *)additionalHTTPRequestHeaders
{
    SCSObject *sourceObject = [self sourceObject];
    SCSObject *destinationObject = [self destinationObject];
    
    NSDictionary *destinationUserMetadata = [destinationObject userDefinedMetadata];
    NSMutableDictionary *additionalMetadata = [NSMutableDictionary dictionary];
    
    if ([destinationUserMetadata count]) {
        [additionalMetadata setObject:@"REPLACE" forKey:@"x-amz-metadata-directive"];
        [additionalMetadata addEntriesFromDictionary:[destinationObject metadata]];
    }
    
    NSString *copySource = [NSString stringWithFormat:@"/%@/%@", [[sourceObject bucket] name], [sourceObject key]];
    NSString *copySourceURLEncoded = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)copySource, NULL, (CFStringRef)@"[]#%?,$+=&@:;()'*!", kCFStringEncodingUTF8) autorelease];
    [additionalMetadata setObject:copySourceURLEncoded forKey:@"x-amz-copy-source"];
    
    return additionalMetadata;
}

- (BOOL)virtuallyHostedCapable
{
	return [[[self destinationObject] bucket] virtuallyHostedCapable];
}

- (NSString *)bucketName
{
    SCSObject *destinationObject = [self destinationObject];
    
    return [[destinationObject bucket] name];
}

- (NSString *)key
{
    SCSObject *destinationObject = [self destinationObject];
    
    return [destinationObject key];
}

- (NSDictionary *)requestQueryItems {
    
    return nil;
}

- (BOOL)didInterpretStateForStreamHavingEndEncountered:(SCSOperationState *)theState
{
    if ([[self responseStatusCode] isEqual:[NSNumber numberWithInt:200]]) {
        
    }
    
    return NO;
}


@end
