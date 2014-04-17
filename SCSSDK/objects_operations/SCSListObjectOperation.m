//
//  SCSListObjectOperation.m
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSListObjectOperation.h"

#import "SCSExtensions.h"
#import "SCSOwner.h"
#import "SCSBucket.h"
#import "ScSObject.h"

static NSString *SCSOperationInfoListObjectOperationBucketKey = @"SCSOperationInfoListObjectOperationBucketKey";
static NSString *SCSOperationInfoListObjectOperationMarkerKey = @"SCSOperationInfoListObjectOperationMarkerKey";
static NSString *SCSOperationInfoListObjectOperationPrefixKey = @"SCSOperationInfoListObjectOperationPrefixKey";
static NSString *SCSOperationInfoListObjectOperationMaxKeysKey = @"SCSOperationInfoListObjectOperationMaxKeysKey";
static NSString *SCSOperationInfoListObjectOperationDelimiterKey = @"SCSOperationInfoListObjectOperationDelimiterKey";

@implementation SCSListObjectOperation

- (id)initWithBucket:(SCSBucket *)theBucket
              marker:(NSString *)theMarker
              prefix:(NSString *)thePrefix
             maxKeys:(NSInteger)theMaxKeys
           delimiter:(NSString *)theDelimiter {
    
    NSMutableDictionary *theOperationInfo = [[NSMutableDictionary alloc] init];
    
    if (theBucket) {
        [theOperationInfo setObject:theBucket forKey:SCSOperationInfoListObjectOperationBucketKey];
    }
    if (theMarker) {
        [theOperationInfo setObject:theMarker forKey:SCSOperationInfoListObjectOperationMarkerKey];
    }
    if (thePrefix) {
        [theOperationInfo setObject:thePrefix forKey:SCSOperationInfoListObjectOperationPrefixKey];
    }
    if (theMaxKeys) {
        [theOperationInfo setObject:[NSString stringWithFormat:@"%ld", theMaxKeys] forKey:SCSOperationInfoListObjectOperationMaxKeysKey];
    }
    if (theDelimiter) {
        [theOperationInfo setObject:theDelimiter forKey:SCSOperationInfoListObjectOperationDelimiterKey];
    }
    
    self = [super initWithOperationInfo:theOperationInfo];
    
    [theOperationInfo release];
    
    if (self != nil) {
        
    }
    
	return self;
}

- (id)initWithBucket:(SCSBucket *)theBucket marker:(NSString *)theMarker
{
    return [self initWithBucket:theBucket marker:theMarker prefix:nil maxKeys:0 delimiter:nil];
}

- (id)initWithBucket:(SCSBucket *)theBucket
{
    return [self initWithBucket:theBucket marker:nil];
}

- (SCSBucket *)bucket
{
    NSDictionary *theOperationInfo = [self operationInfo];
    return [theOperationInfo objectForKey:SCSOperationInfoListObjectOperationBucketKey];
}

- (NSString *)marker
{
    NSDictionary *theOperationInfo = [self operationInfo];
    return [theOperationInfo objectForKey:SCSOperationInfoListObjectOperationMarkerKey];
}

- (NSString *)prefix
{
    NSDictionary *theOperationInfo = [self operationInfo];
    return [theOperationInfo objectForKey:SCSOperationInfoListObjectOperationPrefixKey];
}

- (NSString *)maxKeys
{
    NSDictionary *theOperationInfo = [self operationInfo];
    return [theOperationInfo objectForKey:SCSOperationInfoListObjectOperationMaxKeysKey];
}

- (NSString *)delimiter
{
    NSDictionary *theOperationInfo = [self operationInfo];
    return [theOperationInfo objectForKey:SCSOperationInfoListObjectOperationDelimiterKey];
}

- (NSString *)kind
{
	return @"Bucket content";
}

- (NSString *)requestHTTPVerb
{
    return @"GET";
}

- (BOOL)virtuallyHostedCapable
{
	return [[self bucket] virtuallyHostedCapable];
}

- (NSString *)bucketName
{
    return [[self bucket] name];
}

- (NSDictionary *)requestQueryItems
{
    NSMutableDictionary *queryItems = [NSMutableDictionary dictionary];
    
    NSString *marker = [self marker];
    NSString *prefix = [self prefix];
    NSString *maxKeys = [self maxKeys];
    NSString *delimiter = [self delimiter];
    
    if (marker != nil) {
        [queryItems addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:marker, @"marker", nil]];
    }
    if (prefix != nil) {
        [queryItems addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:prefix, @"prefix", nil]];
    }
    if (maxKeys != nil) {
        [queryItems addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:maxKeys, @"max-keys", nil]];
    }
    if (delimiter != nil) {
        [queryItems addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:delimiter, @"delimiter", nil]];
    }

    return queryItems;
}

- (NSMutableDictionary *)metadata
{
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    NSError *_error = nil;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:&_error];
	
    if (_error == nil && json != nil) {
        
        [dictionary addEntriesFromDictionary:json];
    }
	
	return dictionary;
}

- (NSArray *)objects
{
    NSError *_error = nil;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:&_error];
    
    NSMutableArray *result = [NSMutableArray array];
    
    if (_error == nil && json != nil) {
        
        for (id md in [json objectForKey:@"Contents"]) {
            
            SCSObject *object = [[[SCSObject alloc] initWithBucket:[self bucket]
                                                               key:[md valueForKey:@"Name"]
                                               userDefinedMetadata:nil
                                                          metadata:md
                                                    dataSourceInfo:nil] autorelease];
            
            [result addObject:object];
        }
    }
    
    return result;
}

- (SCSListObjectOperation *)operationForNextChunk
{
    NSDictionary *d = [self metadata];
    if (![[d objectForKey:@"IsTruncated"] isEqualToString:@"true"])
        return nil;
    
    NSString *nm = [d objectForKey:@"NextMarker"];
    if (nm==nil)
    {
        NSArray *objs = [self objects];
        nm = [[objs objectAtIndex:([objs count]-1)] key];
    }
    
    if (nm==nil)
        return nil;
    
    SCSBucket *bucket = [self bucket];
    SCSListObjectOperation *op = [[[SCSListObjectOperation alloc] initWithBucket:bucket
                                                                          marker:nm
                                                                          prefix:[self prefix]
                                                                         maxKeys:[[self maxKeys] integerValue]
                                                                       delimiter:[self delimiter]] autorelease];
    
    return op;
}

@end
