//
//  SCSAddObjectRelaxOperation.h
//  SCSSDK
//
//  Created by Littlebox222 on 14-4-16.
//
//

#import "SCSOperation.h"

/*!SCSAddObjectRelaxOperation */
/*!Subclass of the SCSOperation using for relax creating or uploading the object.
 */
@interface SCSAddObjectRelaxOperation : SCSOperation

/*!Initialize a new SCSAddObjectRelaxOperation immediately after memory for it has been allocated.
 \param o Object to be created or uploaded by relax.
 \param sha1 Sha1 of the file to be created or uploaded by relax.
 \param fileSize Size of the file to be created or uploaded by relax.
 \returns The initialized SCSAddObjectRelaxOperation.
 */
- (id)initWithObject:(SCSObject *)o fileSha1:(NSString *)sha1 fileSize:(NSString *)fileSize;

/*!Get the created object.
 */
- (SCSObject *)object;

@end
