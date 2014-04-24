//
//  SCSBucket.m
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSBucket.h"
#import "SCSACL.h"
#import "SCSConnectionInfo.h"
#import "SCSExtensions.h"

NSString *SCSBucketACLKey = @"x-amz-acl";

@interface SCSBucket (SCSBucketPrivateAPI)
- (void)setCreationDate:(NSDate *)aCreationDate;
- (void)setName:(NSString *)aName;
- (void)setConsumedBytes:(NSInteger)consumedBytes;
- (void)setVirtuallyHostedCapable:(BOOL)b;
+ (BOOL)isDNSComptatibleName:(NSString*)name;
@end

@implementation SCSBucket

@synthesize aclDict = _aclDict;

- (id)initWithName:(NSString *)name creationDate:(NSDate *)date consumedBytes:(NSInteger)consumedBytes cannedAcl:(NSString *)acl {
    
    self = [super init];
    
    if (self != nil) {
        if (name == nil) {
            [self release];
            return nil;
        }
        [self setName:name];
        [self setCreationDate:date];
        [self setConsumedBytes:consumedBytes];
		[self setVirtuallyHostedCapable:[SCSBucket isDNSComptatibleName:name]];
        
        if (acl) {            
            [self setAclDict:[[NSDictionary dictionaryWithObject:acl forKey:SCSBucketACLKey] retain]];
        }
	}
    
	return self;
}

- (id)initWithName:(NSString *)name creationDate:(NSDate *)date consumedBytes:(NSInteger)consumedBytes
{
    return [self initWithName:name creationDate:date consumedBytes:consumedBytes cannedAcl:nil];
}

- (id)initWithName:(NSString *)name creationDate:(NSDate *)date
{
	return [self initWithName:name creationDate:date consumedBytes:0];
}

- (id)initWithName:(NSString *)name
{
    return [self initWithName:name creationDate:nil];
}

- (void)dealloc
{
    [_creationDate release];
    [_name release];
    [_acl release];
    [super dealloc];
}

+ (BOOL)isDNSComptatibleName:(NSString*)name;
{	
	return [[name lowercaseString] isEqualToString:name];
}

- (BOOL)virtuallyHostedCapable
{
	return _virtuallyHostedCapable;
}

- (void)setVirtuallyHostedCapable:(BOOL)b
{
	_virtuallyHostedCapable = b;
}

- (NSInteger)consumedBytes
{
    return _consumedBytes;
}

- (void)setConsumedBytes:(NSInteger)consumedBytes
{
    _consumedBytes = consumedBytes;
}

- (NSDate *)creationDate
{
    return _creationDate;
}

- (void)setCreationDate:(NSDate *)aCreationDate
{
    [_creationDate release];
    _creationDate = [aCreationDate retain];
}

- (NSString *)name
{
    return _name;
}

- (void)setName:(NSString *)aName
{
    [_name release];
    _name = [aName retain];
}

- (void)setACL:(SCSACL *)acl {
    
    [_acl release];
    _acl = [acl retain];
}

- (SCSACL *)acl {
    
    return _acl;
}

- (void)setAclDict:(NSDictionary *)aclDict {
    
    [_aclDict release];
    _aclDict = aclDict;
}

- (NSDictionary *)aclDict {
    
    return _aclDict;
}

- (NSUInteger)hash
{
    return [_name hash];
}

- (BOOL)isEqual:(id)obj
{
    if ([obj isKindOfClass:[self class]] == YES) {
        if ([[self name] isEqualToString:[obj name]]) {
            return YES;
        }
    }
    return NO;
}

- (NSURL *)urlWithSign:(BOOL)sign expires:(NSDate *)expires ip:(NSString *)ip security:(BOOL)security {
    
    if (sign) {
        
        return [[SCSConnectionInfo sharedConnectionInfo] authorizationURLWithBucket:self.name object:nil expires:expires ip:ip security:security];
    }
    
    return [[SCSConnectionInfo sharedConnectionInfo] publicURLWithBucket:self.name object:nil security:security];
}

- (id)copyWithZone:(NSZone *)zone {
    return [self retain];
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"Bucket name: %@\nBucket creationDate: %@\nBucket consumedBytes : %ld\n", [self name], [self creationDate], (long)[self consumedBytes]];
}

@end
