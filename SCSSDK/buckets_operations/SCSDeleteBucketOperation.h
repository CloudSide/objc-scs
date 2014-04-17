//
//  SCSDeleteBucketOperation.h
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSOperation.h"

/*!SCSDeleteBucketOperation */
/*!Subclass of the SCSOperation using for deleting bucket.
 */
@interface SCSDeleteBucketOperation : SCSOperation

/*!Initialize a new SCSDeleteBucketOperation immediately after memory for it has been allocated.
 \param theBucket Bucket to be deleted.
 \returns The initialized SCSDeleteBucketOperation.
 */
- (id)initWithBucket:(SCSBucket *)theBucket;

/*!Get the bucket the operation contains.
 */
@property(readonly, nonatomic, copy) SCSBucket *bucket;

@end
