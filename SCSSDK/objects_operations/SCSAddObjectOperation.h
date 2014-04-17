//
//  SCSAddObjectOperation.h
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSOperation.h"

@class SCSConnectionInfo;
@class SCSObject;

/*!SCSAddObjectOperation */
/*!Subclass of the SCSOperation using for creating or uploading the object.
 */
@interface SCSAddObjectOperation : SCSOperation

/*!Initialize a new SCSAddObjectOperation immediately after memory for it has been allocated.
 \param o Object to be created or uploaded.
 \returns The initialized SCSAddObjectOperation.
 */
- (id)initWithObject:(SCSObject *)o;

/*!Get the created object.
 */
- (SCSObject *)object;

@end
