//
//  SCSPersistentCFReadStreamPool.h
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import <Foundation/Foundation.h>

extern CFStringRef SCSPersistentCFReadStreamPoolUniquePeropertyKey;

/*!SCSPersistentCFReadStreamPool */
/*!The SCSPersistentCFReadStreamPool is a data pool for the CFNetwork dealing with the streamed data.
 */
@interface SCSPersistentCFReadStreamPool : NSObject {
    
    NSMutableDictionary *_activePersistentReadStreams;
    NSMutableArray *_overflow;
    NSTimer *_cleanPoolTimer;
}

/*!Get the shared SCSPersistentCFReadStreamPool
 \returns The shared SCSPersistentCFReadStreamPool.
 */
+ (SCSPersistentCFReadStreamPool *)sharedPersistentCFReadStreamPool;

/*!Get whether there is a shared SCSPersistentCFReadStreamPool
 \returns The bool value of whether there is a shared SCSPersistentCFReadStreamPool.
 */
+ (BOOL)sharedPersistentCFReadStreamPoolExists;

/*!Add the opened persistent CFReadStream to the queque.
 \param persistentCFReadStream persistent CFReadStream to be added.
 \param position The position of an added CFReadStream in the queue.
 \returns The bool value of whether the CFReadStream add to the queue successfully.
 */
- (BOOL)addOpenedPersistentCFReadStream:(CFReadStreamRef)persistentCFReadStream inQueuePosition:(NSUInteger)position;

/*!Add the opened persistent CFReadStream to the queque.
 \param persistentCFReadStream persistent CFReadStream to be added.
 \returns The bool value of whether the CFReadStream add to the queue successfully.
 */
- (BOOL)addOpenedPersistentCFReadStream:(CFReadStreamRef)persistentCFReadStream;

/*!Remove the opened persistent CFReadStream from the queque.
 \param persistentCFReadStream persistent CFReadStream to be removed.
 */
- (void)removeOpenedPersistentCFReadStream:(CFReadStreamRef)readStream;

@end
