//
//  SCSDownloadObjectOperation.h
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSOperation.h"

@class SCSConnectionInfo;
@class SCSObject;

/*!SCSDownloadObjectOperation */
/*!Subclass of the SCSOperation using for downloading the object.
 */
@interface SCSDownloadObjectOperation : SCSOperation

/*!Initialize a new SCSDownloadObjectOperation immediately after memory for it has been allocated.
 \param o Object to be downloaded.
 \param filePath File path for the downloaded object to save.
 \returns The initialized SCSDownloadObjectOperation.
 */
- (id)initWithObject:(SCSObject *)o saveTo:(NSString *)filePath;

/*!Initialize a new SCSDownloadObjectOperation immediately after memory for it has been allocated.
 \param o Object to be downloaded.
 \returns The initialized SCSDownloadObjectOperation.
 */
- (id)initWithObject:(SCSObject *)o;

@end