//
//  SCSACL.m
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSACL.h"


NSString *SCSACLGrantRead = @"read";
NSString *SCSACLGrantWrite = @"write";
NSString *SCSACLGrantReadACP = @"read_acp";
NSString *SCSACLGrantWriteACP = @"write_acp";

NSString *SCSACLAnonymouseUsersGroupGranteeID = @"GRPS000000ANONYMOUSE";
NSString *SCSACLCanonicalUserGroupGranteeID = @"GRPS0000000CANONICAL";

NSString *SCSFastACLPrivate =                       @"private";
NSString *SCSFastACLPublicRead =                    @"public-read";
NSString *SCSFastACLPublicReadWrite =               @"public-read-write";
NSString *SCSFastACLAuthenticatedRead =             @"authenticated-read";
NSString *SCSFastACLBucketOwnerRead =               @"bucket-owner-read";
NSString *SCSFastACLBucketOwnerFullControl =        @"bucket-owner-full-control";


@implementation SCSACL

- (id)initWithGranteesAndGrants:(NSDictionary *)granteesAndGrants {
    
    self = (SCSACL *)[[NSDictionary alloc] initWithDictionary:granteesAndGrants];
    
    if (self != nil) {
        
        
	}
    
	return self;
}

@end



@implementation SCSGrantee

- (id)initWithUid:(NSString *)uid displayName:(NSString *)displayName {
    
    self = [super init];
    
    if (self != nil) {
        
        [self setUid:uid];
        [self setDisplayName:displayName];
	}
    
	return self;
    
}

- (id)initWithUid:(NSString *)uid {
    return [self initWithUid:uid displayName:nil];
}

- (void)setUid:(NSString *)uid {
    
    _uid = uid;
}

- (NSString *)uid {
    
    return _uid;
}

- (void)setDisplayName:(NSString *)displayName {
    
    _displayName = displayName;
}

- (NSString *)displayName {
    
    return _displayName;
}

@end


@implementation SCSGrant

- (id)initWithGrantArray:(NSArray *)array {
    
    self = (SCSGrant *)[[NSArray alloc] initWithArray:array];
    
    if (self != nil) {
        
    }
    
    return self;
}

@end
