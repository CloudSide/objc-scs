//
//  SCSOwner.m
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSOwner.h"

@interface SCSOwner ()

@property(readwrite, copy) NSString *ID;
@property(readwrite, copy) NSString *displayName;

@end

@implementation SCSOwner

@dynamic ID;
@synthesize displayName = _displayName;


- (id)initWithID:(NSString *)uid displayName:(NSString *)name
{
	self = [super init];
    
    if (self != nil) {
        [self setID:uid];
        [self setDisplayName:name];
    }
    
	return self;
}

- (void)dealloc
{
	[_id release];
	[_displayName release];
	[super dealloc];
}

- (NSString *)ID
{
    return _id;
}

- (void)setID:(NSString *)anId
{
    NSString *newId = [anId copy];
    [_id release];
    _id = newId;
}

@end
