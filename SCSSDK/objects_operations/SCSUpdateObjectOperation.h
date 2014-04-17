//
//  SCSUpdateObjectOperation.h
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-9.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSOperation.h"

/*!SCSUpdateObjectOperation */
/*!Subclass of the SCSOperation using for updating the object.
 */
@interface SCSUpdateObjectOperation : SCSOperation

/*!Initialize a new SCSUpdateObjectOperation immediately after memory for it has been allocated.
 \param o The object to be updated.
 \returns The initialized SCSUpdateObjectOperation.
 */
- (id)initWithObject:(SCSObject *)o;

/*!Get the updated object.
 \returns The updated object.
 */
- (SCSObject *)object;

@end
