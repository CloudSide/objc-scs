//
//  SCSPersistentCFReadStreamPool.m
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSPersistentCFReadStreamPool.h"

#import <sys/socket.h>

CFStringRef SCSPersistentCFReadStreamPoolUniquePeropertyKey = CFSTR("UniqueProperty");

static SCSPersistentCFReadStreamPool *_sharedSCSPersistentCFReadStreamPoolInstance;

static NSInteger SCSTimeBetweenCleanings = 20;
static NSString *SCSPersistentReadStreamKey = @"SCSPersistentReadStreamKey";
static NSString *SCSDateKey = @"SCSDateKey";

@interface SCSPersistentCFReadStreamPool ()
- (void)nukePool;
- (void)disarmCleanPoolTimer;
@end

@implementation SCSPersistentCFReadStreamPool

- (id)init
{
    self = [super init];
    if (self != nil) {
        _activePersistentReadStreams = [[NSMutableDictionary alloc] init];
        _overflow = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [self disarmCleanPoolTimer];
    [self nukePool];
    [_activePersistentReadStreams release];
    [_overflow release];
    [super dealloc];
}

+ (SCSPersistentCFReadStreamPool *)sharedPersistentCFReadStreamPool
{
    if (_sharedSCSPersistentCFReadStreamPoolInstance == nil) {
        _sharedSCSPersistentCFReadStreamPoolInstance = [[SCSPersistentCFReadStreamPool alloc] init];
    }
    return _sharedSCSPersistentCFReadStreamPoolInstance;
}

+ (BOOL)sharedPersistentCFReadStreamPoolExists
{
    if (_sharedSCSPersistentCFReadStreamPoolInstance == nil) {
        return NO;
    }
    return YES;
}

- (void)armCleanPoolTimer
{
    if (_cleanPoolTimer == nil) {
        _cleanPoolTimer = [[NSTimer scheduledTimerWithTimeInterval:SCSTimeBetweenCleanings target:self selector:@selector(cleanPool:) userInfo:nil repeats:NO] retain];
    }
}

-(void)disarmCleanPoolTimer
{
	[_cleanPoolTimer invalidate];
	[_cleanPoolTimer release];
	_cleanPoolTimer = nil;
}

- (BOOL)addOpenedPersistentCFReadStream:(CFReadStreamRef)persistentCFReadStream inQueuePosition:(NSUInteger)position
{
    if (persistentCFReadStream == nil) {
        return NO;
    }
    
    CFStreamStatus streamStatus = CFReadStreamGetStatus(persistentCFReadStream);
    if (streamStatus == kCFStreamStatusNotOpen || streamStatus == kCFStreamStatusAtEnd ||
        streamStatus == kCFStreamStatusClosed || streamStatus == kCFStreamStatusError) {
        return NO;
    }
    
    NSNumber *positionNumber = [NSNumber numberWithUnsignedInteger:position];
    NSDictionary *foundDictionary = [_activePersistentReadStreams objectForKey:positionNumber];
    CFReadStreamRef foundReadStream = (CFReadStreamRef)[foundDictionary objectForKey:SCSPersistentReadStreamKey];
    if (foundReadStream != nil) {
        streamStatus = CFReadStreamGetStatus(foundReadStream);
        if (streamStatus == kCFStreamStatusNotOpen || streamStatus == kCFStreamStatusAtEnd ||
            streamStatus == kCFStreamStatusClosed || streamStatus == kCFStreamStatusError) {
            CFReadStreamClose(foundReadStream);
            NSDate *currentTime = [[NSDate alloc] init];
            NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:(NSInputStream *)persistentCFReadStream, SCSPersistentReadStreamKey, currentTime, SCSDateKey, nil];
            [_activePersistentReadStreams setObject:dictionary forKey:positionNumber];
            [currentTime release];
            [dictionary release];
        } else {
            while ((streamStatus == kCFStreamStatusOpening || streamStatus == kCFStreamStatusOpen ||
                    streamStatus == kCFStreamStatusReading || streamStatus == kCFStreamStatusWriting) && ((++position) < NSUIntegerMax)) {
                positionNumber = [NSNumber numberWithUnsignedInteger:position];
                foundDictionary = [_activePersistentReadStreams objectForKey:positionNumber];
                foundReadStream = (CFReadStreamRef)[foundDictionary objectForKey:SCSPersistentReadStreamKey];
                if (foundReadStream != nil) {
                    streamStatus = CFReadStreamGetStatus(foundReadStream);
                } else {
                    break;
                }
            }
            if (position == NSUIntegerMax) {
                [_overflow addObject:(NSInputStream *)persistentCFReadStream];
            } else {
                if (foundReadStream != nil &&
                    (streamStatus == kCFStreamStatusNotOpen || streamStatus == kCFStreamStatusAtEnd ||
                     streamStatus == kCFStreamStatusClosed || streamStatus == kCFStreamStatusError)) {
                        CFReadStreamClose(foundReadStream);
                    }
                NSDate *currentTime = [[NSDate alloc] init];
                NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:(NSInputStream *)persistentCFReadStream, SCSPersistentReadStreamKey, currentTime, SCSDateKey, nil];
                [_activePersistentReadStreams setObject:dictionary forKey:positionNumber];
                [currentTime release];
                [dictionary release];
            }
        }
    } else {
        NSDate *currentTime = [[NSDate alloc] init];
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:(NSInputStream *)persistentCFReadStream, SCSPersistentReadStreamKey, currentTime, SCSDateKey, nil];
        [_activePersistentReadStreams setObject:dictionary forKey:positionNumber];
        [currentTime release];
        [dictionary release];
    }
    
    // Enable timer firing mechanisim here for cleaning up dead streams.
    [self armCleanPoolTimer];
    
    return YES;
}

- (BOOL)addOpenedPersistentCFReadStream:(CFReadStreamRef)persistentCFReadStream
{
    return [self addOpenedPersistentCFReadStream:persistentCFReadStream inQueuePosition:0];
}

- (void)cleanPool:(NSTimer *)timer
{
    NSLog(@"cleanPool:");
    NSEnumerator *objectEnumerator = [_activePersistentReadStreams objectEnumerator];
    NSDictionary *foundDictionary = nil;
    NSMutableArray *keysToRemove = [[NSMutableArray alloc] init];
    while (foundDictionary = [objectEnumerator nextObject]) {
        CFReadStreamRef foundReadStream = (CFReadStreamRef)[foundDictionary objectForKey:SCSPersistentReadStreamKey];
        CFStreamStatus streamStatus = CFReadStreamGetStatus(foundReadStream);
        if (streamStatus == kCFStreamStatusNotOpen || streamStatus == kCFStreamStatusAtEnd ||
            streamStatus == kCFStreamStatusClosed || streamStatus == kCFStreamStatusError) {
            NSDate *currentTime = [[NSDate alloc] init];
            if ([currentTime timeIntervalSinceDate:[foundDictionary objectForKey:SCSDateKey]] > SCSTimeBetweenCleanings) {
                NSArray *keys = [_activePersistentReadStreams allKeysForObject:foundDictionary];
                [keysToRemove addObjectsFromArray:keys];
                CFReadStreamClose(foundReadStream);
            }
            [currentTime release];
        }
    }
    [_activePersistentReadStreams removeObjectsForKeys:keysToRemove];
    [keysToRemove removeAllObjects];
    
    for (foundDictionary in _overflow) {
        CFReadStreamRef foundReadStream = (CFReadStreamRef)[foundDictionary objectForKey:SCSPersistentReadStreamKey];
        CFStreamStatus streamStatus = CFReadStreamGetStatus(foundReadStream);
        if (streamStatus == kCFStreamStatusNotOpen || streamStatus == kCFStreamStatusAtEnd ||
            streamStatus == kCFStreamStatusClosed || streamStatus == kCFStreamStatusError) {
            NSDate *currentTime = [[NSDate alloc] init];
            if ([currentTime timeIntervalSinceDate:[foundDictionary objectForKey:SCSDateKey]] > SCSTimeBetweenCleanings) {
                [keysToRemove addObject:foundDictionary];
                CFReadStreamClose(foundReadStream);
            }
            [currentTime release];
        }
    }
    [_overflow removeObjectsInArray:keysToRemove];
    [keysToRemove release];
    keysToRemove = nil;
    
    [self disarmCleanPoolTimer];
    
    // If there are still kids in the  pool
    // arm another pool boy to come clean up.
    if ([_activePersistentReadStreams count] > 0 || [_overflow count] > 0) {
        [self armCleanPoolTimer];
    }
}

- (void)removeOpenedPersistentCFReadStream:(CFReadStreamRef)readStream
{
    NSEnumerator *objectEnumerator = [_activePersistentReadStreams objectEnumerator];
    NSDictionary *foundDictionary = nil;
    NSMutableArray *keysToRemove = [[NSMutableArray alloc] init];
    while (foundDictionary = [objectEnumerator nextObject]) {
        CFReadStreamRef foundReadStream = (CFReadStreamRef)[foundDictionary objectForKey:SCSPersistentReadStreamKey];
        if (foundReadStream == readStream) {
            NSArray *keys = [_activePersistentReadStreams allKeysForObject:foundDictionary];
            [keysToRemove addObjectsFromArray:keys];
            CFReadStreamClose(foundReadStream);
        }
    }
    [_activePersistentReadStreams removeObjectsForKeys:keysToRemove];
    [keysToRemove removeAllObjects];
    
    for (foundDictionary in _overflow) {
        CFReadStreamRef foundReadStream = (CFReadStreamRef)[foundDictionary objectForKey:SCSPersistentReadStreamKey];
        if (foundReadStream == readStream) {
            [keysToRemove addObject:foundDictionary];
            CFReadStreamClose(foundReadStream);
        }
    }
    [_overflow removeObjectsInArray:keysToRemove];
    [keysToRemove release];
    keysToRemove = nil;
}

- (void)nukePool
{
    NSEnumerator *objectEnumerator = [_activePersistentReadStreams objectEnumerator];
    NSDictionary *foundDictionary = nil;
    while (foundDictionary = [objectEnumerator nextObject]) {
        CFReadStreamRef foundReadStream = (CFReadStreamRef)[foundDictionary objectForKey:SCSPersistentReadStreamKey];
        CFReadStreamClose(foundReadStream);
    }
    for (foundDictionary in _overflow) {
        CFReadStreamRef foundReadStream = (CFReadStreamRef)[foundDictionary objectForKey:SCSPersistentReadStreamKey];
        CFReadStreamClose(foundReadStream);
    }
}

@end