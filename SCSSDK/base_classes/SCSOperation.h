//
//  SCSOperation.h
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-1.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>


#define SCS_ERROR_RESOURCE_KEY          @"ResourceKey"
#define SCS_ERROR_HTTP_STATUS_KEY       @"HTTPStatusKey"
#define SCS_ERROR_DOMAIN                @"sinastorage"
#define SCS_ERROR_CODE_KEY              @"SCSErrorCode"

extern NSString *SCSOperationKindBucketList;
extern NSString *SCSOperationKindBucketAdd;
extern NSString *SCSOperationKindBucketDelete;
extern NSString *SCSOperationKindObjectAdd;
extern NSString *SCSOperationKindObjectAddRelax;
extern NSString *SCSOperationKindObjectCopy;
extern NSString *SCSOperationKindObjectDelete;
extern NSString *SCSOperationKindObjectDownload;
extern NSString *SCSOperationKindObjectGetInfo;
extern NSString *SCSOperationKindObjectList;
extern NSString *SCSOperationKindObjectUpdate;
extern NSString *SCSOperationKindGetACL;
extern NSString *SCSOperationKindSetACL;

typedef enum _SCSOperationState {
    SCSOperationPending = 0,
    SCSOperationPendingRetry = 1,
    SCSOperationActive = 2,
    SCSOperationCanceled = 3,
    SCSOperationDone = 4,
    SCSOperationRequiresRedirect = 5,
    SCSOperationError = 6,
    SCSOperationRequiresVirtualHostingEnabled = 7,
} SCSOperationState;

@class SCSConnectionInfo;
@class SCSBucket;
@class SCSObject;
@class SCSOperation;
@class SCSTransferRateCalculator;

/*!SCSOperationDelegate */
/*!Delegate to observe the change of the operation status.
 */
@protocol SCSOperationDelegate
- (void)operationInformationalStatusDidChange:(SCSOperation *)o;
- (void)operationInformationalSubStatusDidChange:(SCSOperation *)o;
- (void)operationStateDidChange:(SCSOperation *)o;
@end

@interface NSObject (SCSOperationDelegate)

/*!Get the position of the operation in the operation queue.
 \param o The operation to be checked out.
 \returns The position of the operation in the operation queue.
 */
- (NSUInteger)operationQueuePosition:(SCSOperation *)o;
@end

/*!SCSOperation */
/*!SCSOperation is the basic class of the all SCSSDK's http request method operations.*/
/*!It contains a delegate which observe the operation state.*/
/*!And the SCSConnectionInfo and all the request and response information such as requestHeaders, responseHeaders, responseStatusCode, responseData and so on.*/
/*!And the queue position in the SCSOperationQueue and some other status information of error and the transfer rate calculator, ect.
 */
@interface SCSOperation : NSObject {
    
    NSObject <SCSOperationDelegate> *delegate;
    
    NSDictionary *operationInfo;
    
    SCSConnectionInfo *connectionInfo;
    
    NSDate *_date;
    
    CFReadStreamRef httpOperationReadStream;
    
    NSDictionary *requestHeaders;
    NSDictionary *responseHeaders;
    NSNumber *responseStatusCode;
    NSData *responseData;
    NSFileHandle *responseFileHandle;
    
    SCSOperationState state;
    NSString *informationalStatus;
    NSString *informationalSubStatus;
    
    BOOL allowsRetry;
    
    SCSTransferRateCalculator *rateCalculator;
    
    NSInteger queuePosition;
    
    NSError *error;
}

/*!Initialize a new SCSOperation immediately after memory for it has been allocated.
 \param anOperationInfo The operation info which contains the operation kind and some other informations.
 \returns The initialized SCSOperation.
 */
- (id)initWithOperationInfo:(NSDictionary *)anOperationInfo;

/*!Initialize a new SCSOperation immediately after memory for it has been allocated.
 \returns The initialized SCSOperation.
 */
- (id)init;


/*!Get or set the delegate which used to observe the change of the operation status.*/
@property(readwrite, nonatomic, assign) id delegate;

/*!Get the connectioninfo contained in the operatioin info.*/
@property(readonly, nonatomic, copy) SCSConnectionInfo *connectionInfo;

/*!Get the operation info contained in the operatioin.*/
@property(readonly, nonatomic, copy) NSDictionary *operationInfo;

/*!Get the operation state of operatioin.*/
@property(readonly, nonatomic, assign) SCSOperationState state;

/*!Get the informationalStatus state of operatioin.*/
@property(readonly, nonatomic, copy) NSString *informationalStatus;

/*!Get the informationalSubStatus state of operatioin.*/
@property(readonly, nonatomic, copy) NSString *informationalSubStatus;

/*!Get the date of operatioin.*/
@property(readonly, nonatomic, copy) NSDate *date;

/*!Get the requestHeaders of operatioin.*/
@property(readonly, nonatomic, copy) NSDictionary *requestHeaders;

/*!Get the responseHeaders of operatioin.*/
@property(readonly, nonatomic, copy) NSDictionary *responseHeaders;

/*!Get the responseStatusCode of operatioin.*/
@property(readonly, nonatomic, copy) NSNumber *responseStatusCode;

/*!Get the responseData of operatioin.*/
@property(readonly, nonatomic, copy) NSData *responseData;

/*!Check whether the operation is on the service.
 \returns The bool value of whether the operation is on the service.
 */
- (BOOL)isRequestOnService;

/*!Start the operation in the operation queue.*/
- (void)start:(id)sender;

/*!Stop the operation in the operation queue.*/
- (void)stop:(id)sender;

/*!Check whether the operation is active.
 \returns The bool value of whether the operation is active.
 */
- (BOOL)active;

/*!Check whether the operation is success.
 \returns The bool value of whether the operation is success.
 */
- (BOOL)success;

/*!Get the built url from the SCSHTTPURLBuilder for the request.
 \returns The built url.
 */
- (NSURL *)url;

/*!Get the kind of the operation. This method must be implemented by subclasses.
 \returns The operation kind. A short human readable description of the operation.
 */
- (NSString *)kind;

/*!Get the http verb of the operation. This method must be implemented by subclasses.
 \returns The http verb. May not return nil. Must comply with HTTP 1.1 available verbs
 */
- (NSString *)requestHTTPVerb;

/*!Get the bucket name of the operation performed on. This method is optionally implemented by subclasses.
 \returns The bucket name. May return nil.
 */
- (NSString *)bucketName;

/*!Get the key of the object the operation performed on. This method is optionally implemented by subclasses.
 \returns The key of object. May return nil.
 */
- (NSString *)key;

/*!Get the request query items of the operation. This method is optionally implemented by subclasses.
 \returns The request query items. May return nil.
 */
- (NSDictionary *)requestQueryItems;

/*!Get whether the operation capable for virtually host. This method is optionally implemented by subclasses.
 \returns The bool value of whether the operation virtually hosted capable.
 */
- (BOOL)virtuallyHostedCapable;

/*!This method is for subclassers to add additional HTTP headers to the request than is normally generated.
 \returns The additional http request headers. May return nil. Allows subclassers to return custom headers.
 */
- (NSDictionary *)additionalHTTPRequestHeaders;

/*!This method provide optional information for the request body content md5. This item can be placed in the -additionalHTTPRequestHeaders:.*/
/*!If it is not in the -additionalHTTPRequestHeaders: the request will try to retrieve the values from this methods as appropriate.
 \returns The request body content md5.
 */
- (NSString *)requestBodyContentMD5;

/*!This method provide optional information for the request body content type. This item can be placed in the -additionalHTTPRequestHeaders:.*/
/*!If it is not in the -additionalHTTPRequestHeaders: the request will try to retrieve the values from this methods as appropriate.
 \returns The request body content type.
 */
- (NSString *)requestBodyContentType;

/*!This method provide optional information for the request body content length. This item can be placed in the -additionalHTTPRequestHeaders:.*/
/*!If it is not in the -additionalHTTPRequestHeaders: the request will try to retrieve the values from this methods as appropriate.
 \returns The request body content length.
 */
- (NSUInteger)requestBodyContentLength;

/*!This method provide the request body content data for the operation if needed.
 \returns The request body content data.
 */
- (NSData *)requestBodyContentData;

/*!This method provide the request body content file path for the operation if needed.
 \returns The request body content file path.
 */
- (NSString *)requestBodyContentFilePath;

/*!-responseBodyContentFilePath should be a writeable file path that the operation can use to write the response body content instead of storing the response data in the operation.
 \returns The response body content file path.
 */
- (NSString *)responseBodyContentFilePath;

/*!This method provide the exepcted length for the response body content.
 \returns The exepcted length for the response body content.
 */
- (long long)responseBodyContentExepctedLength;

/*! This method is implemented in rare instances by the subclass when the operation requires special knowledge to set the operation state.*/
/*! If the subclass wishes to set the state then it should dereference the state and set its value to what the new state value should be and YES should be returned.
 \returns NO by default by the base class.
 */
- (BOOL)didInterpretStateForStreamHavingEndEncountered:(SCSOperationState *)theState;

/*!Calculate current locale date.
 \returns Current locale date.
 */
- (NSDate *)currentLocaleDate;

@end
