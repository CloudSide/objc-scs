//
//  SCSGetInfoObjectOperation.h
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-10.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSOperation.h"

/*!SCSGetInfoObjectOperation */
/*!Subclass of the SCSOperation using for getting the information of the object.
 */
@interface SCSGetInfoObjectOperation : SCSOperation

/*!Initialize a new SCSGetInfoObjectOperation immediately after memory for it has been allocated.
 \param o Object to be got information.
 \returns The initialized SCSGetInfoObjectOperation.
 */
- (id)initWithObject:(SCSObject *)o;

/*!Get the information of the object the operation returned.
 \returns The Object containing the object information.
 */
- (SCSObject *)objectInfo;

@end
