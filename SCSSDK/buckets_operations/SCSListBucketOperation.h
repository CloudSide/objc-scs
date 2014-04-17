//
//  SCSListBucketOperation.h
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSOperation.h"

@class SCSOwner;

/*!SCSListBucketOperation */
/*!Subclass of the SCSOperation using for listing the buckets that belong to the owner.
 */
@interface SCSListBucketOperation : SCSOperation

/*!Initialize a new SCSListBucketOperation immediately after memory for it has been allocated.
 \returns The initialized SCSListBucketOperation.
 */
- (id)init;

/*!Get the bucketList the operation returns.
 \returns The array of bucket list.
 */
- (NSArray *)bucketList;

/*!Get the owner the bucketList belongs to.
 \returns The owner the bucketList belongs to.
 */
- (SCSOwner *)owner;

@end
