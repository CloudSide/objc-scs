//
//  SCSAddBucketOperation.h
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSOperation.h"

@class SCSBucket;

/*!SCSAddBucketOperation */
/*!Subclass of the SCSOperation using for creating bucket.
 */
@interface SCSAddBucketOperation : SCSOperation

/*!Get the bucket the operation contains.
 */
@property(readonly, nonatomic, copy) SCSBucket *bucket;

/*!Initialize a new SCSAddBucketOperation immediately after memory for it has been allocated.
 \param b Bucket to be created.
 \returns The initialized SCSAddBucketOperation.
 */
- (id)initWithBucket:(SCSBucket *)b;

@end
