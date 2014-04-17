//
//  SCSGetACLOperation.m
//  SCSSDK
//
//  Created by Littlebox222 on 14-4-11.
//
//

#import "SCSGetACLOperation.h"

#import "SCSConnectionInfo.h"
#import "SCSBucket.h"
#import "SCSObject.h"
#import "SCSExtensions.h"

static NSString *SCSOperationInfoGetACLOperationBucketKey = @"SCSOperationInfoGetACLOperationBucketKey";
static NSString *SCSOperationInfoGetACLOperationObjectKey = @"SCSOperationInfoGetACLOperationObjectKey";

@implementation SCSGetACLOperation

- (id)initWithBucket:(SCSBucket *)bucket object:(SCSObject *)object
{
    NSMutableDictionary *theOperationInfo = [[NSMutableDictionary alloc] init];
    if (bucket) {
        [theOperationInfo setObject:bucket forKey:SCSOperationInfoGetACLOperationBucketKey];
    }
    if (object) {
        [theOperationInfo setObject:object forKey:SCSOperationInfoGetACLOperationObjectKey];
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
    return [theOperationInfo objectForKey:SCSOperationInfoGetACLOperationBucketKey];
}

- (SCSObject *)object
{
    NSDictionary *theOperationInfo = [self operationInfo];
    return [theOperationInfo objectForKey:SCSOperationInfoGetACLOperationObjectKey];
}

- (NSString *)kind
{
	return @"Get acl";
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

- (NSString *)key
{
    SCSObject *object = [self object];
    return [object key];
}

- (NSDictionary *)requestQueryItems
{
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNull null], @"acl", nil];
    
}

- (SCSACL *)aclInfo
{
    NSError *_error = nil;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:[self responseData] options:kNilOptions error:&_error];
    
    if (json != nil) {
        
        SCSACL *acl = [json objectForKey:@"ACL"];
        
        if (acl != nil) {
            return acl;
        }else {
            return nil;
        }
    }else {
        return nil;
    }
}

@end
