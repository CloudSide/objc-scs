//
//  SCSInitiateMultipartUploadOperation.m
//  SCSSDK
//
//  Created by Littlebox222 on 14-4-25.
//
//

#import "SCSInitiateMultipartUploadOperation.h"

#import "SCSConnectionInfo.h"
#import "SCSBucket.h"
#import "SCSObject.h"
#import "SCSExtensions.h"

static NSString *SCSOperationInfoInitiateMultipartUploadOperationKey = @"SCSOperationInfoInitiateMultipartUploadOperationKey";

@implementation SCSInitiateMultipartUploadOperation

- (id)initWithObject:(SCSObject *)o
{
    NSMutableDictionary *theOperationInfo = [[NSMutableDictionary alloc] init];
    if (o) {
        [theOperationInfo setObject:o forKey:SCSOperationInfoInitiateMultipartUploadOperationKey];
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
    return [theOperationInfo objectForKey:SCSOperationInfoInitiateMultipartUploadOperationKey];
}

- (NSString *)kind
{
	return SCSOperationKindInitiateMultipartUpload;
}

- (NSString *)requestHTTPVerb
{
    return @"POST";
}

- (NSDictionary *)additionalHTTPRequestHeaders
{
    SCSObject *object = [self object];
    
    return [object metadata];
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
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNull null], @"multipart", nil];
    
}

- (NSString *)requestBodyContentMD5
{
    SCSObject *object = [self object];
    
    return [[object metadata] objectForKey:SCSObjectMetadataContentMD5Key];
}

@end
