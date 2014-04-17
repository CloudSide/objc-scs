//
//  SCSGetACLOperation.h
//  SCSSDK
//
//  Created by Littlebox222 on 14-4-11.
//
//

#import "SCSOperation.h"

@class SCSACL;
/*!SCSGetACLOperation */
/*!Subclass of the SCSOperation using for getting acl of the bucket or object.
 */
@interface SCSGetACLOperation : SCSOperation

/*!Initialize a new SCSGetACLOperation immediately after memory for it has been allocated.
 \param bucket Bucket for which to get acl.
 \param object Object for which to get acl.When it is nil, get the acl of bucket.
 \returns The initialized SCSGetACLOperation.
 */
- (id)initWithBucket:(SCSBucket *)bucket object:(SCSObject *)object;

/*!Get the acl of the bucket or object.
 \returns The acl of the bucket or object.
 */
- (SCSACL *)aclInfo;

@end
