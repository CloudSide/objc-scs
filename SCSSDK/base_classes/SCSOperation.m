//
//  SCSOperation.m
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-1.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSOperation.h"
#import "SCSHTTPURLBuilder.h"
#import "SCSConnectionInfo.h"
#import "SCSTransferRateCalculator.h"
#import "SCSPersistentCFReadStreamPool.h"

NSString *SCSOperationKindBucketList =          @"Bucket list";
NSString *SCSOperationKindBucketAdd =           @"Bucket addition";
NSString *SCSOperationKindBucketDelete =        @"Bucket deletion";
NSString *SCSOperationKindObjectAdd =           @"Object upload";
NSString *SCSOperationKindObjectAddRelax =      @"Object upload relax";
NSString *SCSOperationKindObjectCopy =          @"Object copy";
NSString *SCSOperationKindObjectDelete =        @"Object deletion";
NSString *SCSOperationKindObjectDownload =      @"Object download";
NSString *SCSOperationKindObjectGetInfo =       @"Object get info";
NSString *SCSOperationKindObjectList =          @"Bucket content";
NSString *SCSOperationKindObjectUpdate =        @"Object update";
NSString *SCSOperationKindGetACL =              @"Get acl";
NSString *SCSOperationKindSetACL =              @"Set acl";

@interface SCSOperation (SCSOperationPrivateAPI)

- (void)handleNetworkEvent:(CFStreamEventType)eventType;

- (NSString *)protocolScheme;
- (int)portNumber;
- (NSString *)host;
- (NSString *)operationKey;

- (void)updateInformationalStatus;
- (void)updateInformationalSubStatus;

@end

@interface SCSOperation ()
@property(readwrite, nonatomic, copy) SCSConnectionInfo *connectionInfo;
@property(readwrite, nonatomic, copy) NSDictionary *operationInfo;

@property(readwrite, nonatomic, assign) BOOL allowsRetry;

@property(readwrite, nonatomic, assign) SCSOperationState state;
@property(readwrite, nonatomic, copy) NSString *informationalStatus;
@property(readwrite, nonatomic, copy) NSString *informationalSubStatus;

@property(readwrite, nonatomic, copy) NSDictionary *requestHeaders;

@property(readwrite, nonatomic, copy) NSDate *date;
@property(readwrite, nonatomic, copy) NSDictionary *responseHeaders;
@property(readwrite, nonatomic, copy) NSNumber *responseStatusCode;
@property(readwrite, nonatomic, copy) NSData *responseData;
@property(readwrite, nonatomic, retain) NSFileHandle *responseFileHandle;
@property(readwrite, nonatomic, copy) NSError *error;
@property(readwrite, nonatomic, assign) NSInteger queuePosition;

@end


#pragma mark -
#pragma mark Constants & Globals

static const CFOptionFlags SCSOperationNetworkEvents =   kCFStreamEventOpenCompleted | kCFStreamEventHasBytesAvailable | kCFStreamEventEndEncountered | kCFStreamEventErrorOccurred;


#pragma mark -
#pragma mark Static Functions

static void ReadStreamClientCallBack(CFReadStreamRef stream, CFStreamEventType type, void *clientCallBackInfo) {
    
    // Pass off to the object to handle
    [((SCSOperation *)clientCallBackInfo) handleNetworkEvent:type];
}


#pragma mark -

@implementation SCSOperation

@synthesize delegate;
@synthesize allowsRetry;

@synthesize state;
@synthesize connectionInfo;
@synthesize operationInfo;
@synthesize informationalStatus;
@synthesize informationalSubStatus;

@synthesize requestHeaders;

@synthesize date = _date;
@synthesize responseHeaders;
@synthesize responseStatusCode;
@synthesize responseData;
@synthesize responseFileHandle;
@synthesize error;
@synthesize queuePosition;

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"informationalStatus"];
    [self removeObserver:self forKeyPath:@"informationalSubStatus"];
    
    [connectionInfo release];
    [_date release];
    if (httpOperationReadStream != NULL) {
        CFRelease(httpOperationReadStream);
    }
    [responseHeaders release];
    [responseData release];
    [responseFileHandle release];
    [informationalStatus release];
    [informationalSubStatus release];
    [rateCalculator release];
    [error release];
    
	[super dealloc];
}

+ (BOOL)accessInstanceVariablesDirectly
{
    return NO;
}

+ (void)initialize
{
    //[self setKeys:[NSArray arrayWithObjects:@"state", nil] triggerChangeNotificationsForDependentKey:@"active"];
    
    [self keyPathsForValuesAffectingValueForKey:@"active"];
}

- (id)initWithOperationInfo:(NSDictionary *)anOperationInfo
{
    self = [super init];
    
    if (self != nil) {
        
        if ([SCSConnectionInfo sharedConnectionInfo] == nil) {
            [self release];
            return nil;
        }
        [self setConnectionInfo:[SCSConnectionInfo sharedConnectionInfo]];
        [self setOperationInfo:anOperationInfo];
        
        [self addObserver:self forKeyPath:@"informationalStatus" options:0 context:NULL];
        [self addObserver:self forKeyPath:@"informationalSubStatus" options:0 context:NULL];
    }
    
    return self;
}

- (id)init
{
    return [self initWithOperationInfo:nil];
}

- (SCSOperationState)state
{
    return state;
}

- (void)setState:(SCSOperationState)aState
{
    state = aState;
    [delegate operationStateDidChange:self];
    
    if (state == SCSOperationPending) {
        [self setInformationalStatus:@"Pending"];
    } else if (state == SCSOperationActive) {
        [self setInformationalStatus:@"Active"];
    } else if (state == SCSOperationPendingRetry) {
        [self setInformationalStatus:@"Pending Retry"];
    } else if (state == SCSOperationError || state == SCSOperationRequiresVirtualHostingEnabled) {
        [self setInformationalStatus:@"Error"];
    } else if (state == SCSOperationCanceled) {
        [self setInformationalStatus:@"Canceled"];
    } else if (state == SCSOperationDone || state == SCSOperationRequiresRedirect) {
        [self setInformationalStatus:@"Done"];
    }
    [delegate operationInformationalStatusDidChange:self];
    
    if (state == SCSOperationRequiresRedirect) {
        [self setInformationalSubStatus:@"Redirect Required"];
    } else if (state == SCSOperationRequiresVirtualHostingEnabled) {
        [self setInformationalSubStatus:@"Virtual Hosting Required"];
    } else {
        [self setInformationalSubStatus:@""];
    }
    [delegate operationInformationalSubStatusDidChange:self];
}

- (void)updateInformationalStatus
{
    
}

- (void)updateInformationalSubStatus
{
    NSMutableString *subStatus = [NSMutableString string];
    NSString *s = [rateCalculator stringForObjectivePercentageCompleted];
    if (s != nil) {
        [subStatus appendFormat:@"%@%% ",s];
    }
    
    s = [rateCalculator stringForCalculatedTransferRate];
    if (s != nil) {
        [subStatus appendFormat:@"(%@ %@/%@) ", s, [rateCalculator stringForShortDisplayUnit], [rateCalculator stringForShortRateUnit]];
    }
    
    s = [rateCalculator stringForEstimatedTimeRemaining];
    if (s != nil) {
        [subStatus appendString:s];
    }
    [self setInformationalSubStatus:subStatus];
}

- (BOOL)active
{
    return ([self state] == SCSOperationActive);
}

- (BOOL)success
{
    // TODO: Correct implementation
	return TRUE;
}

- (BOOL)isRequestOnService
{
    return (([self bucketName] == nil) && ([self key] == nil));
}

#pragma mark -
#pragma mark SCSHTTPUrlBuilder Delegate Methods

- (NSString *)httpUrlBuilderWantsProtocolScheme:(SCSHTTPURLBuilder *)httpUrlBuilder
{
    return [self protocolScheme];
}

- (int)httpUrlBuilderWantsPort:(SCSHTTPURLBuilder *)httpUrlBuilder
{
    return [self portNumber];
}

- (NSString *)httpUrlBuilderWantsHost:(SCSHTTPURLBuilder *)httpUrlBuilder
{
    return [self host];
}

- (NSString *)httpUrlBuilderWantsKey:(SCSHTTPURLBuilder *)httpUrlBuilder
{
    return [self operationKey];
}

- (NSDictionary *)httpUrlBuilderWantsQueryItems:(SCSHTTPURLBuilder *)httpUrlBuilder
{
    return [self requestQueryItems];
}

#pragma mark -
#pragma mark SCSOperation Information Retrieval Methods

- (NSString *)protocolScheme
{
    if ([[self connectionInfo] secureConnection] == YES) {
        return @"https";
    }
    return @"http";
}

- (int)portNumber
{
    return [[self connectionInfo] portNumber];
}

- (NSString *)host
{
    if ([self isRequestOnService] == NO && [[self connectionInfo] virtuallyHosted] && [self virtuallyHostedCapable] && [self bucketName] != nil) {
        NSString *hostName = [NSString stringWithFormat:@"%@.%@", [self bucketName], [[self connectionInfo] hostEndpoint]];
        return hostName;
    }
    return [[self connectionInfo] hostEndpoint];
}

- (NSString *)operationKey
{
    if ([self isRequestOnService] == NO && (([[self connectionInfo] virtuallyHosted] == NO) || ([self virtuallyHostedCapable] == NO)) && [self bucketName] != nil) {
        NSString *keyString = nil;
        if ([self key] != nil) {
            keyString = [NSString stringWithFormat:@"%@/%@", [self bucketName], [self key]];
        } else {
            keyString = [NSString stringWithFormat:@"%@/", [self bucketName]];
        }
        return keyString;
    }
    return [self key];
}

- (NSDictionary *)queryItems
{
    return nil;
}

- (NSString *)requestHTTPVerb
{
    return nil;
}

- (NSDictionary *)additionalHTTPRequestHeaders
{
    return nil;
}

- (BOOL)virtuallyHostedCapable
{
	return true;
}

- (NSString *)bucketName
{
    return nil;
}

- (NSString *)key
{
    return nil;
}

- (NSDictionary *)requestQueryItems
{
    return nil;
}

- (NSData *)requestBodyContentData
{
    return nil;
}

- (NSString *)requestBodyContentFilePath
{
    return nil;
}

- (NSString *)requestBodyContentMD5
{
    return nil;
}

- (NSString *)requestBodyContentType
{
    return nil;
}

- (NSUInteger)requestBodyContentLength
{
    return 0;
}

- (NSString *)responseBodyContentFilePath
{
    return nil;
}

- (long long)responseBodyContentExepctedLength
{
    return 0;
}


#pragma mark -

- (NSDate *)currentLocaleDate {
    
    NSDate* sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate] autorelease];
    
    return destinationDate;
}

- (NSURL *)url
{
    // Make Request String
    SCSHTTPURLBuilder *urlBuilder = [[SCSHTTPURLBuilder alloc] initWithDelegate:self];
    NSURL *builtURL = [urlBuilder url];
    [urlBuilder release];
    
    return builtURL;
}

-(void)stop:(id)sender
{
    if ([self state] >= SCSOperationCanceled || !(httpOperationReadStream)) {
        return;
    }
    
	NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:@"This operation has been cancelled", NSLocalizedDescriptionKey, nil];
	[self setError:[NSError errorWithDomain:SCS_ERROR_DOMAIN code:-1 userInfo:d]];
    
    CFReadStreamSetClient(httpOperationReadStream, 0, NULL, NULL);
    CFReadStreamUnscheduleFromRunLoop(httpOperationReadStream, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    SCSPersistentCFReadStreamPool *sharedPool = [SCSPersistentCFReadStreamPool sharedPersistentCFReadStreamPool];
    [sharedPool removeOpenedPersistentCFReadStream:httpOperationReadStream];
    CFRelease(httpOperationReadStream);
    httpOperationReadStream = NULL;
    
    // Close filestream if available.
    [[self responseFileHandle] closeFile];
    [self setResponseFileHandle:nil];
    
    [self setState:SCSOperationCanceled];
    
    [rateCalculator stopTransferRateCalculator];
}

- (void)start:(id)sender;
{
    if ([self responseBodyContentFilePath] != nil) {
        
        NSFileHandle *fileHandle = nil;
        
        BOOL fileCreated = [[NSFileManager defaultManager] createFileAtPath:[self responseBodyContentFilePath] contents:nil attributes:nil];
        
        if (fileCreated == YES) {
            fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:[self responseBodyContentFilePath]];
        } else {
            BOOL isDirectory = NO;
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self responseBodyContentFilePath] isDirectory:&isDirectory];
            if (fileExists == YES && isDirectory == NO) {
                if ([[NSFileManager defaultManager] isWritableFileAtPath:[self responseBodyContentFilePath]] == YES) {
                    fileHandle = [NSFileHandle fileHandleForWritingAtPath:[self responseBodyContentFilePath]];
                }
            }
        }
        
        if (fileHandle == nil) {
            [self setState:SCSOperationError];
            return;
        }
        
        [self setResponseFileHandle:fileHandle];
    }
    
    NSDate *operationDate = [self currentLocaleDate];
    [self setDate:operationDate];
    
    // Any headers or information to be included with this HTTP message should have happened before this point!
    
	CFHTTPMessageRef httpRequest = [[self connectionInfo] newCFHTTPMessageRefFromOperation:self];
    if (httpRequest == NULL) {
        [self setState:SCSOperationError];
        return;
    }
    
    NSInputStream *inputStream = nil;
    NSData *bodyContentsData = [self requestBodyContentData];
    NSString *bodyContentsFilePath = [self requestBodyContentFilePath];
    if (bodyContentsData != nil) {
        inputStream = [NSInputStream inputStreamWithData:bodyContentsData];
    } else if (bodyContentsFilePath != nil) {
        inputStream = [NSInputStream inputStreamWithFileAtPath:bodyContentsFilePath];
    }
    
    if (inputStream != nil) {
        httpOperationReadStream = CFReadStreamCreateForStreamedHTTPRequest(kCFAllocatorDefault, httpRequest, (CFReadStreamRef)inputStream);
    } else {
        // If there is no body to send there is no need to make a streamed request.
        httpOperationReadStream = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, httpRequest);
        
        // When we are not doing a streamed request and the request is not secure or
        // the request is secure and is a request on the service
        // and the request is virtually hosted and there is a bucket name.
        if (![[self connectionInfo] secureConnection] || ([[self connectionInfo] secureConnection] && [self isRequestOnService] && ![[self connectionInfo] virtuallyHosted] && [self virtuallyHostedCapable] && ![self bucketName])) {
            //            NSLog(@"auto redirecting!");
            CFReadStreamSetProperty(httpOperationReadStream, kCFStreamPropertyHTTPShouldAutoredirect, kCFBooleanTrue);
        }
    }
    
    [self setRequestHeaders:[(NSDictionary *)CFHTTPMessageCopyAllHeaderFields(httpRequest) autorelease]];
    CFRelease(httpRequest);
    
    rateCalculator = [[SCSTransferRateCalculator alloc] init];
    
    // Setup the rate calculator
    if (inputStream != nil) {
        // It is most likely upload data
        [rateCalculator setObjective:[self requestBodyContentLength]];
        // We need the rate calculator to ping us occasionally to update it.
        // To do this we set the rate calculator's delegate to us.
        [rateCalculator setDelegate:self];
    } else {
        // It is most likely download data
        [rateCalculator setObjective:[self responseBodyContentExepctedLength]];
    }
    
    
    // TODO: error checking on creation of read stream.
    
    CFReadStreamSetProperty(httpOperationReadStream, kCFStreamPropertyHTTPAttemptPersistentConnection, kCFBooleanTrue);
    
    if ([self delegate] && [[self delegate] respondsToSelector:@selector(operationQueuePosition:)] == YES) {
        [self setQueuePosition:[[self delegate] operationQueuePosition:self]];
        NSNumber *queuePositionNumber = [[NSNumber alloc] initWithInteger:[self queuePosition]];
        CFReadStreamSetProperty(httpOperationReadStream, SCSPersistentCFReadStreamPoolUniquePeropertyKey, (CFNumberRef)queuePositionNumber);
        [queuePositionNumber release];
    }
    
    // TODO: error checking on setting the stream client
    CFStreamClientContext clientContext = {0, self, NULL, NULL, NULL};
    CFReadStreamSetClient(httpOperationReadStream, SCSOperationNetworkEvents, ReadStreamClientCallBack, &clientContext);
    
    // Schedule the stream
    CFReadStreamScheduleWithRunLoop(httpOperationReadStream, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    
    if (!CFReadStreamOpen(httpOperationReadStream)) {
        CFReadStreamSetClient(httpOperationReadStream, 0, NULL, NULL);
        CFReadStreamUnscheduleFromRunLoop(httpOperationReadStream, CFRunLoopGetMain(), kCFRunLoopCommonModes);
        CFRelease(httpOperationReadStream);
        httpOperationReadStream = NULL;
        return;
    }
    [self setState:SCSOperationActive];
}

- (void)handleStreamOpenCompleted
{
    
    SCSPersistentCFReadStreamPool *sharedPool = [SCSPersistentCFReadStreamPool sharedPersistentCFReadStreamPool];
    if ([sharedPool addOpenedPersistentCFReadStream:httpOperationReadStream inQueuePosition:[self queuePosition]] == NO) {
        //        NSLog(@"Not added");
        CFReadStreamSetClient(httpOperationReadStream, 0, NULL, NULL);
        CFReadStreamUnscheduleFromRunLoop(httpOperationReadStream, CFRunLoopGetMain(), kCFRunLoopCommonModes);
        CFReadStreamClose(httpOperationReadStream);
        CFRelease(httpOperationReadStream);
        httpOperationReadStream = NULL;
        
        // Close filestream if available.
        [[self responseFileHandle] closeFile];
        [self setResponseFileHandle:nil];
        
        [self setState:SCSOperationError];
        return;
    }
    
    [rateCalculator startTransferRateCalculator];
}

- (void)handleStreamHavingBytesAvailable
{
    //    NSLog(@"handleStreamHavingBytesAvailable");
    if (!httpOperationReadStream) {
        return;
    }
    
    UInt8 buffer[65536];
    CFIndex bytesRead = CFReadStreamRead(httpOperationReadStream, buffer, sizeof(buffer));
    if (bytesRead < 0) {
        // TODO: Something?
    } else if (bytesRead > 0) {
        if ([self responseFileHandle] != nil) {
            NSData *receivedData = [NSData dataWithBytesNoCopy:(void *)buffer length:bytesRead freeWhenDone:NO];
            [[self responseFileHandle] writeData:receivedData];
        } else {
            NSData *existingData = [self responseData];
            if (existingData == nil) {
                existingData = [NSData data];
                [self setResponseData:existingData];
            }
            NSMutableData *workingData = [NSMutableData dataWithData:existingData];
            [workingData appendBytes:(const void *)buffer length:bytesRead];
            [self setResponseData:workingData];
        }
        [rateCalculator addBytesTransfered:bytesRead];
        [self updateInformationalSubStatus];
    }
}

- (void)handleStreamHavingEndEncountered
{
    //    NSLog(@"handleStreamHavingEndEncountered");
    
    CFReadStreamSetClient(httpOperationReadStream, 0, NULL, NULL);
    CFReadStreamUnscheduleFromRunLoop(httpOperationReadStream, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    
    CFIndex statusCode = 0;
    
    // Copy out any headers
    CFHTTPMessageRef headerMessage = (CFHTTPMessageRef)CFReadStreamCopyProperty(httpOperationReadStream, kCFStreamPropertyHTTPResponseHeader);
    if (headerMessage != NULL) {
        // Get the HTTP status code
        statusCode = CFHTTPMessageGetResponseStatusCode(headerMessage);
        [self setResponseStatusCode:[NSNumber numberWithLong:statusCode]];
        
        NSDictionary *headerDict = (NSDictionary *)CFHTTPMessageCopyAllHeaderFields(headerMessage);
        if (headerDict != nil) {
            [self setResponseHeaders:headerDict];
            [headerDict release];
            headerDict = nil;
        }
        CFRelease(headerMessage);
        headerMessage = NULL;
    }
    
    SCSOperationState customState = 0;
    BOOL useCustomState = [self didInterpretStateForStreamHavingEndEncountered:&customState];
    if (useCustomState) {
        [self setState:customState];
    } else {
        if (statusCode >= 400) {
            [self setState:SCSOperationError];
            if ([self responseFileHandle]) {
                [[self responseFileHandle] seekToFileOffset:0];
                NSData *data = [[self responseFileHandle] readDataToEndOfFile];
                [self setResponseData:data];
            }
        } else if (statusCode >= 300 && statusCode < 400) {
            if (statusCode == 307) {
                [self setState:SCSOperationRequiresRedirect];
            } else if (statusCode == 301) {
                [self setState:SCSOperationRequiresVirtualHostingEnabled];
            } else {
                [self setState:SCSOperationError];
            }
            if ([self responseFileHandle]) {
                [[self responseFileHandle] seekToFileOffset:0];
                NSData *data = [[self responseFileHandle] readDataToEndOfFile];
                [self setResponseData:data];
            }
        } else {
            [self setState:SCSOperationDone];
        }
    }
    
    // Close filestream if available.
    [[self responseFileHandle] closeFile];
    [self setResponseFileHandle:nil];
    
    [rateCalculator stopTransferRateCalculator];
    
    CFRelease(httpOperationReadStream);
    httpOperationReadStream = NULL;
}

- (void)handleStreamErrorOccurred
{
    //    NSLog(@"handleStreamErrorOccurred");
    //
    //    CFErrorRef errorRef = CFReadStreamCopyError(httpOperationReadStream);
    //    if (errorRef) {
    //        CFRelease(errorRef);
    //    }
    CFReadStreamSetClient(httpOperationReadStream, 0, NULL, NULL);
    CFReadStreamUnscheduleFromRunLoop(httpOperationReadStream, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    SCSPersistentCFReadStreamPool *sharedPool = [SCSPersistentCFReadStreamPool sharedPersistentCFReadStreamPool];
    [sharedPool removeOpenedPersistentCFReadStream:httpOperationReadStream];
    CFRelease(httpOperationReadStream);
    httpOperationReadStream = NULL;
    
    // Close filestream if available.
    [[self responseFileHandle] closeFile];
    [self setResponseFileHandle:nil];
    
    [self setState:SCSOperationError];
    [rateCalculator stopTransferRateCalculator];
}

- (void)handleNetworkEvent:(CFStreamEventType)eventType
{
    switch (eventType) {
        case kCFStreamEventOpenCompleted:
            [self handleStreamOpenCompleted];
            return;
            break;
            
        case kCFStreamEventHasBytesAvailable:
            [self handleStreamHavingBytesAvailable];
            return;
            break;
            
        case kCFStreamEventEndEncountered:
            [self handleStreamHavingEndEncountered];
            return;
            break;
            
        case kCFStreamEventErrorOccurred:
            [self handleStreamErrorOccurred];
            return;
            break;
            
        default:
            //            NSLog(@"default hit - %d", eventType);
            return;
            break;
    }
}

- (void)pingFromTransferRateCalculator:(SCSTransferRateCalculator *)obj
{
    if (!httpOperationReadStream) {
        return;
    }
    NSData *bodyContentsData = [self requestBodyContentData];
    NSString *bodyContentsFilePath = [self requestBodyContentFilePath];
    if (bodyContentsData != nil || bodyContentsFilePath != nil) {
        // It is most likely upload data
        long long previouslyTransfered = [rateCalculator totalTransfered];
        NSNumber *totalTransferedNumber = (NSNumber *)CFReadStreamCopyProperty(httpOperationReadStream, kCFStreamPropertyHTTPRequestBytesWrittenCount);
        long long totalTransfered = [totalTransferedNumber longLongValue];
        [rateCalculator addBytesTransfered:(totalTransfered - previouslyTransfered)];
        [totalTransferedNumber release];
        [self updateInformationalSubStatus];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"informationalStatus"] == YES) {
        [delegate operationInformationalStatusDidChange:self];
    } else if ([keyPath isEqualToString:@"informationalSubStatus"] == YES) {
        [delegate operationInformationalSubStatusDidChange:self];
    }
}

- (BOOL)didInterpretStateForStreamHavingEndEncountered:(SCSOperationState *)theState
{
    return NO;
}

- (NSString *)kind
{
    return nil;
}

@end
