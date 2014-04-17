//
//  SCSListBucketOperation.m
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSListBucketOperation.h"

#import "SCSOwner.h"
#import "SCSBucket.h"
#import "SCSExtensions.h"

@implementation SCSListBucketOperation

- (id)init
{
    self = [super init];
    
    if (self != nil) {
        
    }
    
    return self;
}

- (NSString *)kind
{
	return @"Bucket list";
}

- (NSString *)requestHTTPVerb
{
    return @"GET";
}

- (NSDictionary *)requestQueryItems
{
    
    return nil;
}

- (id)valueForUndefinedKey:(NSString *)akey
{
    NSLog(@"%@", akey);
    return nil;
}

- (SCSOwner *)owner
{
    NSError *_error = nil;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:[self responseData] options:kNilOptions error:&_error];
    
    if (json != nil) {
        
        NSDictionary *ownerDict = [json objectForKey:@"Owner"];
        
        if (ownerDict != nil) {
            
            SCSOwner *owner = nil;
            owner = [[[SCSOwner alloc] initWithID:[[ownerDict objectForKey:@"ID"] stringValue]
                                      displayName:[[ownerDict objectForKey:@"DisplayName"] stringValue]] autorelease];
            
            return owner;

        }else {
            return nil;
        }
        
    }else {
        return nil;
    }
}

- (NSArray *)bucketList
{
    
    NSError *_error = nil;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:[self responseData] options:kNilOptions error:&_error];
    
    if (json != nil) {
        
        NSArray *buckets = [json objectForKey:@"Buckets"];
        
        if (buckets != nil) {
            
            NSMutableArray *result = [NSMutableArray array];
            
            for (NSDictionary *bucket in buckets) {
                
                SCSBucket *b = [[[SCSBucket alloc] initWithName:[bucket objectForKey:@"Name"]
                                                   creationDate:[bucket objectForKey:@"CreationDate"]
                                                  consumedBytes:[[bucket objectForKey:@"ConsumedBytes"] integerValue]] autorelease];
                
                if (b != nil) {
                    
                    [result addObject:b];
                }
            }
            
            return result;
            
        }else {
            return nil;
        }
        
    }else {
        return nil;
    }
}

@end
