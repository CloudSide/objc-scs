//
//  SCSObject.h
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCSBucket;
@class SCSOwner;
@class SCSListObjectOperation;


// Keys for default metadata

extern NSString *SCSObjectFilePathDataSourceKey;
extern NSString *SCSObjectNSDataSourceKey;

extern NSString *SCSUserDefinedObjectMetadataMissingKey;
extern NSString *SCSObjectMetadataETagKey;
extern NSString *SCSObjectMetadataLastModifiedKey;
extern NSString *SCSObjectMetadataOwnerKey;

extern NSString *SCSObjectMetadataExpireKey;
extern NSString *SCSObjectMetadataDecoveredKey;
extern NSString *SCSObjectMetadataChownKey;
extern NSString *SCSObjectMetadataInfoKey;
extern NSString *SCSObjectMetadataInfoIntKey;
extern NSString *SCSObjectMetadataCacheControlKey;
extern NSString *SCSObjectMetadataContentMD5Key;
extern NSString *SCSObjectMetadataContentTypeKey;
extern NSString *SCSObjectMetadataContentLengthKey;
extern NSString *SCSObjectMetadataSha1Key;
extern NSString *SCSObjectMetadataLengthKey;
extern NSString *SCSObjectMetadataACLKey;
extern NSString *SCSObjectMetadataContentDispositionKey;
extern NSString *SCSObjectMetadataContentEncodingKey;
extern NSString *SCSUserDefinedObjectMetadataPrefixKey;


/*!SCSObject */
/*!Objects are the fundamental entities stored in SCS. Objects are composed of object data and
 metadata. The data portion is opaque to SCS. The metadata is a set of name-value pairs that
 describe the object. These include some default metadata such as the date last modified, and standard
 HTTP metadata such as Content-Type. The developer may also specify custom metadata at the time the
 Object is stored.
 */
@interface SCSObject : NSObject {
    
    NSString *_key;
	SCSBucket *_bucket;
	NSDictionary *_metadata;
	NSDictionary *_dataSourceInfo;
    
    NSDictionary *_aclDict;
}

/*! Initializes an SCSObject with the bucket it is contained in, the key that identifies it in that bucket, user
 defined metadata and metadata that is stored along with the object and a data source that provides the data
 for the object. User defined metadata is transformed internally to a specially formed metadata-key and stored
 with the metadata-key accepted by SCS service.
 \param bucket Bucket that the object is contained in.
 \param key Key that identifies the object in that bucket.
 \param udmd User defined metadata.
 \param md standard HTTP metadata.
 \param info A data source that provides the data for the object.
 \param acl String used for fast setting acl of the object. Could be nil.
 \returns The initialized SCSObject.
 */
- (id)initWithBucket:(SCSBucket *)bucket key:(NSString *)key userDefinedMetadata:(NSDictionary *)udmd metadata:(NSDictionary *)md dataSourceInfo:(NSDictionary *)info fastACL:(NSString *)acl;

/*! Initializes an SCSObject with the bucket it is contained in, the key that identifies it in that bucket, user
 defined metadata and metadata that is stored along with the object and a data source that provides the data
 for the object. User defined metadata is transformed internally to a specially formed metadata-key and stored
 with the metadata-key accepted by SCS service.
 \param bucket Bucket that the object is contained in.
 \param key Key that identifies the object in that bucket.
 \param udmd User defined metadata.
 \param md standard HTTP metadata.
 \param info A data source that provides the data for the object.
 \returns The initialized SCSObject.
 */
- (id)initWithBucket:(SCSBucket *)bucket key:(NSString *)key userDefinedMetadata:(NSDictionary *)udmd metadata:(NSDictionary *)md dataSourceInfo:(NSDictionary *)info;

/*! Initializes an SCSObject with the bucket it is contained in, the key that identifies it in that bucket, user
 defined metadata and metadata that is stored along with the object and a data source that provides the data
 for the object. User defined metadata is transformed internally to a specially formed metadata-key and stored
 with the metadata-key accepted by SCS service.
 \param bucket Bucket that the object is contained in.
 \param key Key that identifies the object in that bucket.
 \param udmd User defined metadata.
 \param md standard HTTP metadata.
 \returns The initialized SCSObject.
 */
- (id)initWithBucket:(SCSBucket *)bucket key:(NSString *)key userDefinedMetadata:(NSDictionary *)udmd metadata:(NSDictionary *)md;

/*! Initializes an SCSObject with the bucket it is contained in, the key that identifies it in that bucket, user
 defined metadata and metadata that is stored along with the object and a data source that provides the data
 for the object. User defined metadata is transformed internally to a specially formed metadata-key and stored
 with the metadata-key accepted by SCS service.
 \param bucket Bucket that the object is contained in.
 \param key Key that identifies the object in that bucket.
 \param udmd User defined metadata.
 \returns The initialized SCSObject.
 */
- (id)initWithBucket:(SCSBucket *)bucket key:(NSString *)key userDefinedMetadata:(NSDictionary *)udmd;

/*! Initializes an SCSObject with the bucket it is contained in, the key that identifies it in that bucket, user
 defined metadata and metadata that is stored along with the object and a data source that provides the data
 for the object. User defined metadata is transformed internally to a specially formed metadata-key and stored
 with the metadata-key accepted by SCS service.
 \param bucket Bucket that the object is contained in.
 \param key Key that identifies the object in that bucket.
 \returns The initialized SCSObject.
 */
- (id)initWithBucket:(SCSBucket *)bucket key:(NSString *)key;

/*!Get the url of the object by url authorization.
 \param sign Whether the url should be signed. If YES, the url would has ssig query. If NO, used for get public object url.
 \param expires The expire time of the url. It could be nil for the public object.
 \param ip The authorized ip that can get the object through the url.
 \param security The url use the http (NO) or https (YES).
 \returns The url of the object by url authorization.
 */
- (NSURL *)urlWithSign:(BOOL)sign expires:(NSDate *)expires ip:(NSString *)ip security:(BOOL)security;

/*!Get the description of the SCSObject.
 \returns The description of the SCSObject.
 */
- (NSString *)description;

/*!Get the bucket which contains the object.*/
@property(readonly, retain) SCSBucket *bucket;

/*!Get the key of the object.*/
@property(readonly, copy) NSString *key;

/*!Get the data source info of the object.*/
@property(readonly, copy) NSDictionary *dataSourceInfo;

/*!Get the metadata of the object.*/
@property(readonly, copy) NSDictionary *metadata;

/*!Get the user defined metadata of the object.*/
@property(readonly, copy) NSDictionary *userDefinedMetadata;

/*!Get the acl dictionary setting by fast acl set to the object.*/
@property (readonly, copy) NSDictionary *aclDict;

/*!Exposes standard SCS metadata in a KVO complient way.
 */
@property(readonly, copy) NSString *acl;
@property(readonly, copy) NSString *contentMD5;
@property(readonly, copy) NSString *contentType;
@property(readonly, copy) NSString *contentLength;
@property(readonly, copy) NSString *etag;
@property(readonly, copy) NSString *lastModified;
@property(readonly, copy) SCSOwner *owner;
@property(readonly, copy) NSString *storageClass;
@property(readonly) BOOL missingMetadata;

@property(readonly, copy) NSString *sha1;
@property(readonly, copy) NSString *expire;

@end
