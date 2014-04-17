//
//  SCSDeleteObjectOperation.h
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSOperation.h"

@class SCSConnectionInfo;
@class SCSObject;

/*!SCSDeleteObjectOperation */
/*!Subclass of the SCSOperation using for deleting the object.
 */
@interface SCSDeleteObjectOperation : SCSOperation

/*!Initialize a new SCSDeleteObjectOperation immediately after memory for it has been allocated.
 \param o Object to be deleted.
 \returns The initialized SCSDeleteObjectOperation.
 */
- (id)initWithObject:(SCSObject *)o;

/*!Get the object to be deleted.
 */
- (SCSObject *)object;

@end
