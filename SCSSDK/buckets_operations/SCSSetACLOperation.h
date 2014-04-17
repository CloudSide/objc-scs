//
//  SCSSetACLOperation.h
//  SCSSDK
//
//  Created by Littlebox222 on 14-4-11.
//
//

#import "SCSOperation.h"

@class SCSACL;

/*!SCSSetACLOperation */
/*!Subclass of the SCSOperation using for setting acl of the bucket or object.
 */
@interface SCSSetACLOperation : SCSOperation

/*!Initialize a new SCSSetACLOperation immediately after memory for it has been allocated.
 \param bucket Bucket for which to set acl.
 \param object Object for which to set acl.When it is nil, set the acl of bucket.
 \param acl ACL to be set to the bucket or object.
 \returns The initialized SCSSetACLOperation.
 */
- (id)initWithBucket:(SCSBucket *)bucket object:(SCSObject *)object acl:(SCSACL *)acl;

@end
