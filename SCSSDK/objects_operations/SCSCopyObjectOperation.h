//
//  SCSCopyObjectOperation.h
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSOperation.h"

/*!SCSCopyObjectOperation */
/*!Subclass of the SCSOperation using for copying the object.
 */
@interface SCSCopyObjectOperation : SCSOperation

/*!Initialize a new SCSCopyObjectOperation immediately after memory for it has been allocated.
 \param source Object to be copied.
 \param destination Object to be copied to.
 \returns The initialized SCSCopyObjectOperation.
 */
- (id)initWithObjectfrom:(SCSObject *)source to:(SCSObject *)destination;

@end
