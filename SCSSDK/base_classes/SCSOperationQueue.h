//
//  SCSOperationQueue.h
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SCSOperation.h"

/*!SCSOperationQueue */
/*!SCSOperationQueue is a queue used to manage SCSOperations
 */

@interface SCSOperationQueue : NSObject <SCSOperationDelegate> {
    
    id _delegate;
	NSMutableArray *_currentOperations;
    NSMutableArray *_activeOperations;
	NSTimer *_timer;
}

/*!Initialize a new SCSOperationQueue immediately after memory for it has been allocated.
 \param delegate Delegate to observe the change of the operation status..
 \returns The initialized SCSOperationQueue.
 */
- (id)initWithDelegate:(id)delegate;

/*!Convenience methods to register object with NSNotificationCenter if the object supports the SCSOperationQueueNotifications.*/
/*!Must call removeQueueListener before object is deallocated.
 \param obj Object need to be listenned.
 */
- (void)addQueueListener:(id)obj;

/*!Remove the object from the NSNotificationCenter.
 \param obj Object need to be removed.
 */
- (void)removeQueueListener:(id)obj;

/*!Add a SCSOperation to the SCSOperationQueue for run.
 \param op Operation need to run.
 */
- (BOOL)addToCurrentOperations:(SCSOperation *)op;

/*!List the SCSOperations in the current queue.
 \returns Operations array in the queue.
 */
- (NSArray *)currentOperations;

@end

@interface NSObject (SCSOperationQueueDelegate)
- (int)maximumNumberOfSimultaneousOperationsForOperationQueue:(SCSOperationQueue *)operationQueue;
@end

@interface NSObject (SCSOperationQueueNotifications)

/*!Observe call back when the running operation's state did change.
 \param notification Notification set to the listenner.
 */
- (void)operationQueueOperationStateDidChange:(NSNotification *)notification;

/*!Observe call back when the running operation's informational state did change.
 \param notification Notification set to the listenner.
 */
- (void)operationQueueOperationInformationalStatusDidChangeNotification:(NSNotification *)notification;

/*!Observe call back when the running operation's informational substate did change.
 \param notification Notification set to the listenner.
 */
- (void)operationQueueOperationInformationalSubStatusDidChangeNotification:(NSNotification *)notification;
@end

/* Notifications */
extern NSString *SCSOperationQueueOperationStateDidChangeNotification;
extern NSString *SCSOperationQueueOperationInformationalStatusDidChangeNotification;
extern NSString *SCSOperationQueueOperationInformationalSubStatusDidChangeNotification;

/* Notification UserInfo Keys */
extern NSString *SCSOperationObjectKey;
extern NSString *SCSOperationObjectForRetryKey;
