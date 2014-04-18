//
//  SCSDownloadObjectOperation.m
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSDownloadObjectOperation.h"

#import "SCSConnectionInfo.h"
#import "SCSBucket.h"
#import "SCSObject.h"

static NSString *SCSOperationInfoDownloadObjectOperationObjectKey = @"SCSOperationInfoDownloadObjectOperationObjectKey";
static NSString *SCSOperationInfoDownloadObjectOperationFilePathKey = @"SCSOperationInfoDownloadObjectOperationFilePathKey";


@implementation SCSDownloadObjectOperation


- (id)initWithObject:(SCSObject *)o saveTo:(NSString *)filePath
{
    
    NSMutableDictionary *theOperationInfo = [[NSMutableDictionary alloc] init];
    
    if (o) {
        [theOperationInfo setObject:o forKey:SCSOperationInfoDownloadObjectOperationObjectKey];
    }
    if (filePath) {
        [theOperationInfo setObject:filePath forKey:SCSOperationInfoDownloadObjectOperationFilePathKey];
    }

    
    self = [super initWithOperationInfo:theOperationInfo];
    
    [theOperationInfo release];
    
    if (self != nil) {
        
    }
    
    return self;
}

- (id)initWithObject:(SCSObject *)o
{
    return [self initWithObject:o saveTo:nil];
}

- (SCSObject *)object
{
    NSDictionary *theOperationInfo = [self operationInfo];
    return [theOperationInfo objectForKey:SCSOperationInfoDownloadObjectOperationObjectKey];
}

- (NSString *)filePath
{
    NSDictionary *theOperationInfo = [self operationInfo];
    return [theOperationInfo objectForKey:SCSOperationInfoDownloadObjectOperationFilePathKey];
}

- (NSString *)kind
{
	return SCSOperationKindObjectDownload;
}

- (NSString *)requestHTTPVerb
{
    return @"GET";
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
    
//    
//    NSMutableDictionary *queryItems = [NSMutableDictionary dictionary];
//    
//    NSString *kid = [self kid];
//    
//    if (kid == nil) {
//        return nil;
//    }
//    
//    NSString *expires = [self expires];
//    
//    [self.connectionInfo newCFHTTPMessageRefFromOperation:self];
//    NSString *ssig = [[self connectionInfo] ssig];
//    NSString *ip = [self ip];
//    
//    if (kid != nil) {
//        [queryItems addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:kid, @"KID", nil]];
//    }
//    if (expires != nil) {
//        [queryItems addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:expires, @"Expires", nil]];
//    }
//    if (ssig != nil) {
//        [queryItems addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:ssig, @"ssig", nil]];
//    }
//    if (ip != nil) {
//        [queryItems addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:ip, @"ip", nil]];
//    }
//    
//    return queryItems;
    
    return nil;
}

- (NSDictionary *)additionalHTTPRequestHeaders {
    
    return nil;
}

- (NSString *)responseBodyContentFilePath
{
    return [self filePath];
}

- (long long)responseBodyContentExepctedLength
{
    SCSObject *object = [self object];
    
    NSString *lengthString = [[object metadata] objectForKey:SCSObjectMetadataContentLengthKey];
    long long lengthNumber = 0;
    if (lengthString != nil) {
        lengthNumber = [lengthString longLongValue];
    }
    
    return lengthNumber;
}

@end
