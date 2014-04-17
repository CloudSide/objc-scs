//
//  SCSListObjectOperation.h
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSOperation.h"


/*!SCSListObjectOperation */
/*!Subclass of the SCSOperation using for listing the objects of the bucket.
 */
@interface SCSListObjectOperation : SCSOperation

/*!Initialize a new SCSListObjectOperation immediately after memory for it has been allocated.
 \param theBucket Bucket the object to be listed objects belong to.
 \param theMarker Marker for the page.
 \param thePrefix Prefix for the objects to be listed.
 \param theMaxKeys The max length of the list.
 \param theDelimiter List objects in the fold format according to the string.
 \returns The initialized SCSListObjectOperation.
 */
- (id)initWithBucket:(SCSBucket *)theBucket
              marker:(NSString *)theMarker
              prefix:(NSString *)thePrefix
             maxKeys:(NSInteger)theMaxKeys
           delimiter:(NSString *)theDelimiter;

/*!Initialize a new SCSListObjectOperation immediately after memory for it has been allocated.
 \param theBucket Bucket the to be listed objects belong to.
 \param theMarker Marker for the page.
 \returns The initialized SCSListObjectOperation.
 */
- (id)initWithBucket:(SCSBucket *)bucket marker:(NSString *)marker;

/*!Initialize a new SCSListObjectOperation immediately after memory for it has been allocated.
 \param theBucket Bucket the to be listed objects belong to.
 \returns The initialized SCSListObjectOperation.
 */
- (id)initWithBucket:(SCSBucket *)bucket;

/*!Get the bucket the listed objects belong to.
 \returns The bucket the listed objects belong to.
 */
- (SCSBucket *)bucket;

/*!Get the objects list.
 \returns The objects list.
 */
- (NSArray *)objects;

/*!Get the metadata of the listed objects.
 \returns The metadata of the listed objects.
 */
- (NSMutableDictionary *)metadata;

/*!List for the next page.
 \returns The operation using for listing the next page.
 */
- (SCSListObjectOperation *)operationForNextChunk;

@end
