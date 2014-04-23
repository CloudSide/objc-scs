//
//  SCSAddObjectRelaxOperation.m
//  SCSSDK
//
//  Created by Littlebox222 on 14-4-16.
//
//

#import "SCSAddObjectRelaxOperation.h"

#import "SCSConnectionInfo.h"
#import "SCSBucket.h"
#import "SCSObject.h"
#import "SCSExtensions.h"

static NSString *SCSOperationInfoAddObjectRelaxOperationObjectKey = @"SCSOperationInfoAddObjectRelaxOperationObjectKey";
static NSString *SCSOperationInfoAddObjectRelaxOperationSha1Key = @"SCSOperationInfoAddObjectRelaxOperationSha1Key";
static NSString *SCSOperationInfoAddObjectRelaxOperationFileSizeKey = @"SCSOperationInfoAddObjectRelaxOperationFileSizeKey";

@implementation SCSAddObjectRelaxOperation

- (id)initWithObject:(SCSObject *)o fileSha1:(NSString *)sha1 fileSize:(NSString *)fileSize
{
    NSMutableDictionary *theOperationInfo = [[NSMutableDictionary alloc] init];
    if (o) {
        [theOperationInfo setObject:o forKey:SCSOperationInfoAddObjectRelaxOperationObjectKey];
    }
    if (sha1) {
        [theOperationInfo setObject:sha1 forKey:SCSOperationInfoAddObjectRelaxOperationSha1Key];
    }
    if (fileSize) {
        [theOperationInfo setObject:fileSize forKey:SCSOperationInfoAddObjectRelaxOperationFileSizeKey];
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
    return [theOperationInfo objectForKey:SCSOperationInfoAddObjectRelaxOperationObjectKey];
}

- (NSString *)sha1
{
    NSDictionary *theOperationInfo = [self operationInfo];
    return [theOperationInfo objectForKey:SCSOperationInfoAddObjectRelaxOperationSha1Key];
}

- (NSString *)fileSize
{
    NSDictionary *theOperationInfo = [self operationInfo];
    return [theOperationInfo objectForKey:SCSOperationInfoAddObjectRelaxOperationFileSizeKey];
}

- (NSString *)kind
{
	return SCSOperationKindObjectAddRelax;
}

- (NSString *)requestHTTPVerb
{
    return @"PUT";
}

- (NSDictionary *)additionalHTTPRequestHeaders
{
//    SCSObject *object = [self object];
    
    NSMutableDictionary *additionalMetadata = [NSMutableDictionary dictionary];
    
    [additionalMetadata setObject:[self sha1] forKey:@"s-sina-sha1"];
    [additionalMetadata setObject:[self fileSize] forKey:@"s-sina-length"];
    
    return additionalMetadata;
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
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNull null], @"relax", nil];
}

- (NSUInteger)requestBodyContentLength
{
    return 0;
}

@end
