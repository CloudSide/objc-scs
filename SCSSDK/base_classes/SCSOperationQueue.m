//
//  SCSOperationQueue.m
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSOperationQueue.h"

#define MAX_ACTIVE_OPERATIONS 4

/* Notifications */
NSString *SCSOperationQueueOperationStateDidChangeNotification =                    @"SCSOperationQueueOperationStateDidChangeNotification";
NSString *SCSOperationQueueOperationInformationalStatusDidChangeNotification =      @"SCSOperationQueueOperationInformationalStatusDidChangeNotification";
NSString *SCSOperationQueueOperationInformationalSubStatusDidChangeNotification =   @"SCSOperationQueueOperationInformationalSubStatusDidChangeNotification";

/* Notification UserInfo Keys */
NSString *SCSOperationObjectKey =           @"SCSOperationObjectKey";
NSString *SCSOperationObjectForRetryKey =   @"SCSOperationObjectForRetryKey";


@interface SCSOperationQueue (PrivateAPI)
- (void)removeFromCurrentOperations:(SCSOperation *)op;
- (void)startQualifiedOperations:(NSTimer *)timer;
- (void)rearmTimer;
- (void)disarmTimer;
@end

@implementation SCSOperationQueue

- (id)initWithDelegate:(id)delegate
{
    self = [super init];
    
    if (self != nil) {
        _delegate = delegate;
        _currentOperations = [[NSMutableArray alloc] init];
        _activeOperations = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id)init
{
    return [self initWithDelegate:nil];
}

- (void)dealloc
{
	[_currentOperations release];
    [_activeOperations release];
	[self disarmTimer];
	[super dealloc];
}

#pragma mark -
#pragma mark Convenience Notification Registration

- (void)addQueueListener:(id)obj
{
    SEL operationQueueOperationStateDidChangeSelector = @selector(operationQueueOperationStateDidChange:);
    if ([obj respondsToSelector:operationQueueOperationStateDidChangeSelector]) {
        [[NSNotificationCenter defaultCenter] addObserver:obj selector:operationQueueOperationStateDidChangeSelector name:SCSOperationQueueOperationStateDidChangeNotification object:self];
    }
    SEL operationQueueOperationInformationalStatusDidChangeSelector = @selector(operationQueueOperationInformationalStatusDidChangeNotification:);
    if ([obj respondsToSelector:operationQueueOperationInformationalStatusDidChangeSelector]) {
        [[NSNotificationCenter defaultCenter] addObserver:obj selector:operationQueueOperationInformationalStatusDidChangeSelector name:SCSOperationQueueOperationInformationalStatusDidChangeNotification object:self];
    }
    SEL operationQueueOperationInformationalSubStatusDidChangeSelector = @selector(operationQueueOperationInformationalSubStatusDidChangeNotification:);
    if ([obj respondsToSelector:operationQueueOperationInformationalSubStatusDidChangeSelector]) {
        [[NSNotificationCenter defaultCenter] addObserver:obj selector:operationQueueOperationInformationalSubStatusDidChangeSelector name:SCSOperationQueueOperationInformationalSubStatusDidChangeNotification object:self];
    }
}

- (void)removeQueueListener:(id)obj
{
    [[NSNotificationCenter defaultCenter] removeObserver:obj name:SCSOperationQueueOperationStateDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:obj name:SCSOperationQueueOperationInformationalStatusDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:obj name:SCSOperationQueueOperationInformationalSubStatusDidChangeNotification object:self];
}

#pragma mark -
#pragma mark SCSOperationDelegate Protocol Methods

- (void)operationStateDidChange:(SCSOperation *)o;
{
    if ([o state] >= SCSOperationCanceled) {
        // Retain object while it's in flux must be released at end!
        [o retain];
        [self removeFromCurrentOperations:o];
        
        if ([o state] == SCSOperationError) {
            // TODO: Figure out if the operation needs to be retried and send a new
            // retry operation object to be retried as S3OperationObjectForRetryKey.
            // It appears valid retry on error codes: OperationAborted, InternalError
            //    if ([o state] == S3OperationError && [o allowsRetry] == YES) {
            //        NSDictionary *errorDict = [[o error] userInfo];
            //        NSString *errorCode = [errorDict objectForKey:S3_ERROR_CODE_KEY];
            //        if ([errorCode isEqualToString:@"InternalError"] == YES || [errorCode isEqualToString:@"OperationAborted"] || errorCode == nil) {
            //            // TODO: Create a retry operation from failed operation and add it to the operations to be performed.
            //            //S3Operation *retryOperation = nil;
            //            //[dict setObject:retryOperation forKey:S3OperationObjectForRetryKey];
            //            //[self addToCurrentOperations:retryOperation];
            //        }
            //    }
        }
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:o, SCSOperationObjectKey, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:SCSOperationQueueOperationStateDidChangeNotification object:self userInfo:dict];
    
    if ([o state] >= SCSOperationCanceled) {
        // Object is out of flux
        [o release];
    }
}

- (void)operationInformationalStatusDidChange:(SCSOperation *)o
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:o, SCSOperationObjectKey, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:SCSOperationQueueOperationInformationalStatusDidChangeNotification object:self userInfo:dict];
}

- (void)operationInformationalSubStatusDidChange:(SCSOperation *)o
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:o, SCSOperationObjectKey, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:SCSOperationQueueOperationInformationalSubStatusDidChangeNotification object:self userInfo:dict];
}

- (NSUInteger)operationQueuePosition:(SCSOperation *)o
{
    NSUInteger position = [_activeOperations indexOfObject:o];
    return position;
}

#pragma mark -
#pragma mark Key-value coding

- (BOOL)accessInstanceVariablesDirectly
{
    return NO;
}

- (NSArray *)currentOperations
{
    return [NSArray arrayWithArray:_currentOperations];
}

#pragma mark -
#pragma mark High-level operations

-(void)rearmTimer
{
	if (_timer==NULL) {
		_timer = [[NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(startQualifiedOperations:) userInfo:nil repeats:YES] retain];
    }
}

-(void)disarmTimer
{
	[_timer invalidate];
	[_timer release];
	_timer = NULL;
}

- (int)canAcceptPendingOperations
{
	int available = MAX_ACTIVE_OPERATIONS; // fallback
    if (_delegate && [_delegate respondsToSelector:@selector(maximumNumberOfSimultaneousOperationsForOperationQueue:)]) {
        int maxNumber = [_delegate maximumNumberOfSimultaneousOperationsForOperationQueue:self];
        if ((maxNumber > 0) && (maxNumber < 100)) { // Let's be reasonable
            available = maxNumber;
        }
    }
	
	SCSOperation *o;
	for (o in _currentOperations)
	{
		if ([o state]==SCSOperationActive)
		{
			available--;
			if (available == 0)
				return available;
		}
	}
	return available;
}

- (void)removeFromCurrentOperations:(SCSOperation *)op
{
    if ([op state] == SCSOperationActive) {
        return;
    }
    
	[self willChangeValueForKey:@"currentOperations"];
	[_currentOperations removeObject:op];
	[self didChangeValueForKey:@"currentOperations"];
	
    NSUInteger objectIndex = [_activeOperations indexOfObject:op];
    if (objectIndex != NSNotFound) {
        [_activeOperations replaceObjectAtIndex:objectIndex withObject:[NSNull null]];
    }
    
    [self rearmTimer];
}

- (BOOL)addToCurrentOperations:(SCSOperation *)op
{
	[self willChangeValueForKey:@"currentOperations"];
	[_currentOperations addObject:op];
	[self didChangeValueForKey:@"currentOperations"];
    
	// Ensure this operation has the queue as its delegate.
	[op setDelegate:self];
    [self rearmTimer];
    return TRUE;
}

- (void)startQualifiedOperations:(NSTimer *)timer
{
	int slotsAvailable = [self canAcceptPendingOperations];
	SCSOperation *o;
    
    if (slotsAvailable == 0) {
        [self disarmTimer];
        return;
    }
    
    // Pending retries get priority start status.
	for (o in _currentOperations) {
        if (slotsAvailable == 0) {
            break;
        }
        
		if ([o state] == SCSOperationPendingRetry) {
            
            NSUInteger objectIndex = [_activeOperations indexOfObject:[NSNull null]];
            if (objectIndex == NSNotFound) {
                [_activeOperations addObject:o];
            } else {
                [_activeOperations replaceObjectAtIndex:objectIndex withObject:o];
            }
            
			[o start:self];
            slotsAvailable--;
		}
	}
    for (o in _currentOperations) {
        if (slotsAvailable == 0) {
            break;
        }
        
		if ([o state] == SCSOperationPending) {
            
            NSUInteger objectIndex = [_activeOperations indexOfObject:[NSNull null]];
            if (objectIndex == NSNotFound) {
                [_activeOperations addObject:o];
            } else {
                [_activeOperations replaceObjectAtIndex:objectIndex withObject:o];
            }
			[o start:self];
            slotsAvailable--;
		}
	}
    [self disarmTimer];
}

@end
