//
//  SCSACL.h
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *SCSACLGrantRead;
extern NSString *SCSACLGrantWrite;
extern NSString *SCSACLGrantReadACP;
extern NSString *SCSACLGrantWriteACP;

extern NSString *SCSACLAnonymouseUsersGroupGranteeID;
extern NSString *SCSACLCanonicalUserGroupGranteeID;

extern NSString *SCSFastACLPrivate;
extern NSString *SCSFastACLPublicRead;
extern NSString *SCSFastACLPublicReadWrite;
extern NSString *SCSFastACLAuthenticatedRead;
extern NSString *SCSFastACLBucketOwnerRead;
extern NSString *SCSFastACLBucketOwnerFullControl;


/*!SCSGrantee */
/*!Container for the persons who is set bucket or object policy by the owner
 */
@interface SCSGrantee : NSObject {
	NSString* _uid;
	NSString* _displayName;
}

/*!Initialize a new SCSGrantee immediately after memory for it has been allocated.
 \param uid ID of the user.
 \param displayName display name of the user.
 \returns The initialized SCSGrantee.
 */
- (id)initWithUid:(NSString *)uid displayName:(NSString *)displayName;

/*!Initialize a new SCSGrantee immediately after memory for it has been allocated.
 \param uid ID of the user.
 \returns The initialized SCSGrantee.
 */
- (id)initWithUid:(NSString *)uid;

/*!Get the user id of the SCSGrantee.
 \returns The user id of the SCSGrantee.
 */
- (NSString *)uid;
@end


/*!SCSGrant */
/*!Container for the permissions.
 */
@interface SCSGrant : NSArray {

}

/*!Initialize a new SCSGrant immediately after memory for it has been allocated.
 \param array Array of the permissions for the SCSGrant.
 \returns The initialized SCSGrant.
 */
- (id)initWithGrantArray:(NSArray *)array;

@end

/*!SCSACL */
/*!Container for Grantee and Grants.
 */
@interface SCSACL : NSDictionary {
    
}

/*!Initialize a new SCSACL immediately after memory for it has been allocated.
 \param granteesAndGrants Dictionary for the policy of grantees and grants.
 \returns The initialized SCSACL.
 */
- (id)initWithGranteesAndGrants:(NSDictionary *)granteesAndGrants;

@end
