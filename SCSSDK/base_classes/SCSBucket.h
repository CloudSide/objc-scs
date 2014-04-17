//
//  SCSBucket.h
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCSACL;
@class SCSListBucketOperation;

extern NSString *SCSBucketACLKey;

/*!SCSBucket */
/*!Contains a Bucket Name which is the name of the SCS Bucket.*/
/*!And a Creation Date which is the date that the SCS Bucket was created.*/
/*!And some basic information such as consumed bytes and acl, ect.*/
/*!For more details see http://open.sinastorage.com/?c=doc&a=guide#feature
 */
@interface SCSBucket : NSObject <NSCopying> {
    
    NSString *_name;
	NSDate *_creationDate;
    NSInteger _consumedBytes;
	BOOL _virtuallyHostedCapable;
    
    SCSACL *_acl;
    NSDictionary *_aclDict;
}

/*!Get the acl dictionary setting by fast acl set to the bucket.*/
@property (readonly, copy) NSDictionary *aclDict;

/*!Initialize a new SCSBuchet immediately after memory for it has been allocated.
 \param name Name of the bucket.
 \param date Creation date of the bucket.
 \param consumedBytes Consumed bytes of the bucket.
 \param acl String used for fast setting acl of the bucket.
 \returns The initialized SCS bucket.
 */
- (id)initWithName:(NSString *)name creationDate:(NSDate *)date consumedBytes:(NSInteger)consumedBytes fastAcl:(NSString *)acl;

/*!Initialize a new SCSBuchet immediately after memory for it has been allocated.
 \param name Name of the bucket.
 \param date Creation date of the bucket.
 \param consumedBytes Consumed bytes of the bucket.
 \param acl String used for fast setting acl of the bucket.
 */
- (id)initWithName:(NSString *)name creationDate:(NSDate *)date consumedBytes:(NSInteger)consumedBytes;

/*!Initialize a new SCSBuchet immediately after memory for it has been allocated.
 \param name Name of the bucket.
 \param date Creation date of the bucket.
 \returns The initialized SCS bucket.
 */
- (id)initWithName:(NSString *)name creationDate:(NSDate *)date;

/*!Initialize a new SCSBuchet immediately after memory for it has been allocated.
 \param name Name of the bucket.
 \returns The initialized SCS bucket.
 */
- (id)initWithName:(NSString *)name;

/*!Get the creation date of the bucket.
 \returns The creation date of the bucket.
 */
- (NSDate *)creationDate;

/*!Get the name of the bucket.
 \returns The name of the bucket.
 */
- (NSString *)name;

/*!Get whether the bucket capable the custom host endpoint.
 \returns The bool value for whether the bucket capable the custom host endpoint.
 */
- (BOOL)virtuallyHostedCapable;

/*!Get the SCSACL object set to the bucket.
 \returns The SCSACL object set to the bucket.
 */
- (SCSACL *)acl;

/*!Get the acl dictionary setting by fast acl set to the bucket.
 \returns The acl dictionary set to the bucket.
 */
- (NSDictionary *)aclDict;

/*!Get the description of the SCSBucket.
 \returns The description of the SCSBucket.
 */
- (NSString *)description;

@end
