//
//  SCSSetACLOperation.m
//  SCSSDK
//
//  Created by Littlebox222 on 14-4-11.
//
//

#import "SCSSetACLOperation.h"

#import "SCSConnectionInfo.h"
#import "SCSBucket.h"
#import "SCSObject.h"
#import "SCSExtensions.h"
#import "SCSACL.h"

static NSString *SCSOperationInfoSetACLOperationBucketKey = @"SCSOperationInfoSetACLOperationBucketKey";
static NSString *SCSOperationInfoSetACLOperationObjectKey = @"SCSOperationInfoSetACLOperationObjectKey";
static NSString *SCSOperationInfoSetACLOperationACLKey = @"SCSOperationInfoSetACLOperationACLKey";

@implementation SCSSetACLOperation

- (id)initWithBucket:(SCSBucket *)bucket object:(SCSObject *)object acl:(SCSACL *)acl
{
    NSMutableDictionary *theOperationInfo = [[NSMutableDictionary alloc] init];
    if (bucket) {
        [theOperationInfo setObject:bucket forKey:SCSOperationInfoSetACLOperationBucketKey];
    }
    if (object) {
        [theOperationInfo setObject:object forKey:SCSOperationInfoSetACLOperationObjectKey];
    }
    if (acl) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:acl options:0 error:nil];
        if (jsonData) {
            [theOperationInfo setObject:jsonData forKey:SCSOperationInfoSetACLOperationACLKey];
        }
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
    return [theOperationInfo objectForKey:SCSOperationInfoSetACLOperationBucketKey];
}

- (NSString *)kind
{
	return @"Set acl";
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

- (SCSObject *)object
{
    NSDictionary *theOperationInfo = [self operationInfo];
    return [theOperationInfo objectForKey:SCSOperationInfoSetACLOperationObjectKey];
}

- (NSString *)key
{
    SCSObject *object = [self object];
    return [object key];
}

- (NSDictionary *)requestQueryItems
{
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNull null], @"acl", nil];
}

- (NSData *)requestBodyContentData {
    
    NSDictionary *theOperationInfo = [self operationInfo];
    return [theOperationInfo objectForKey:SCSOperationInfoSetACLOperationACLKey];
}

- (NSUInteger)requestBodyContentLength
{
    if ([self requestBodyContentData] != nil) {
        return [[self requestBodyContentData] length];
    }
    
    return 0;
}

@end
