//
//  SCSConnectionInfo.h
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-3-31.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import <Foundation/Foundation.h>


@class SCSOperation;

/*!SCSConnectionInfo */
/*!SCSConnectionInfo is the class used for containing the basic information for the connection
  including accessKey and secretKey, ect.*/
/*!Used to reate a CFHTTPMessageRef from an SCS operation.
 */
@interface SCSConnectionInfo : NSObject <NSCopying, NSMutableCopying> {

    NSDictionary *_userInfo;
    BOOL _secure;
    int _portNumber;
    BOOL _virtuallyHosted;
    NSString *_host;
    NSString *_accessKey;
    NSString *_secretKey;
}

/*!Get the global static SCSConnectionInfo.
 \returns The global static SCSConnectionInfo.
 */
+ (SCSConnectionInfo *)sharedConnectionInfo;

/*!Set a created SCSConnectionInfo object for singleton parttern.
 \param connectionInfo A created SCSConnectionInfo for global static using.
 */
+ (void)setSharedConnectionInfo:(SCSConnectionInfo *)connectionInfo;

/*!Initialize a new SCSConnectionInfo immediately after memory for it has been allocated.
 \param accessKey User accessKey get from SCS.
 \param secretKey User secretKey get from SCS.
 \returns The initialized SCSConnectionInfo with accessKey and secretKey.
 */
- (id)initWithAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey;

/*!Initialize a new SCSConnectionInfo immediately after memory for it has been allocated.
 \param accessKey User accessKey get from SCS.
 \param secretKey User secretKey get from SCS.
 \param userInfo Contributes to equality; Could be nil.
 \returns The initialized SCSConnectionInfo with accessKey and secretKey.
 */
- (id)initWithAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey userInfo:(id)userInfo;

/*!Initialize a new SCSConnectionInfo immediately after memory for it has been allocated.
 \param accessKey User accessKey get from SCS.
 \param secretKey User secretKey get from SCS.
 \param userInfo Contributes to equality; Could be nil.
 \param secureConnection Whether use SSL for SecureHTTPProtocol; http or https; Insecure by default.
 \returns The initialized SCSConnectionInfo with accessKey and secretKey.
 */
- (id)initWithAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey userInfo:(id)userInfo secureConnection:(BOOL)secureConnection;

/*!Initialize a new SCSConnectionInfo immediately after memory for it has been allocated.
 \param accessKey User accessKey get from SCS.
 \param secretKey User secretKey get from SCS.
 \param userInfo Contributes to equality; Could be nil.
 \param secureConnection Whether use SSL for SecureHTTPProtocol; http or https; Insecure by default.
 \param portNumber Uses default port if 0 depending on secureConnection state.
 \returns The initialized SCSConnectionInfo with accessKey and secretKey.
 */
- (id)initWithAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey userInfo:(id)userInfo secureConnection:(BOOL)secureConnection portNumber:(int)portNumber;

/*!Initialize a new SCSConnectionInfo immediately after memory for it has been allocated.
 \param accessKey User accessKey get from SCS.
 \param secretKey User secretKey get from SCS.
 \param userInfo Contributes to equality; Could be nil.
 \param secureConnection Whether use SSL for SecureHTTPProtocol; http or https; Insecure by default.
 \param portNumber Uses default port if 0 depending on secureConnection state.
 \param virtuallyHosted Whether use custom host endpoint.
 \returns The initialized SCSConnectionInfo with accessKey and secretKey.
 */
- (id)initWithAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey userInfo:(id)userInfo secureConnection:(BOOL)secureConnection portNumber:(int)portNumber virtuallyHosted:(BOOL)virtuallyHosted;

/*!Initialize a new SCSConnectionInfo immediately after memory for it has been allocated.
 \param accessKey User accessKey get from SCS.
 \param secretKey User secretKey get from SCS.
 \param userInfo Contributes to equality; Could be nil.
 \param secureConnection Whether use SSL for SecureHTTPProtocol; http or https; Insecure by default.
 \param portNumber Uses default port if 0 depending on secureConnection state.
 \param virtuallyHosted Whether use custom host endpoint.
 \param host For a host other than the default SCS host endpoint.
 \returns The initialized SCSConnectionInfo with accessKey and secretKey.
 */
- (id)initWithAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey userInfo:(id)userInfo secureConnection:(BOOL)secureConnection portNumber:(int)portNumber virtuallyHosted:(BOOL)virtuallyHosted hostEndpoint:(NSString *)host;

/*!Get whether using the SSL.
 \returns The bool value for whether using the SSL.
 */
- (BOOL)secureConnection;

/*!Get the port number used.
 \returns The portNumber for connection.
 */
- (int)portNumber;

/*!Get the used host endpoint.
 \returns The used hostEndpoint.
 */
- (NSString *)hostEndpoint;

/*!Get whether using the custom host endpoint.
 \returns The bool value for whether using the custom host endpoint.
 */
- (BOOL)virtuallyHosted;

/*!Get the userInfo.
 \returns The userInfo.
 */
- (NSDictionary *)userInfo;

/*!Get the accessKey passed in when initialization.
 \returns The passed in accessKey.
 */
- (NSString *)accessKey;

/*!Get the secretKey passed in when initialization.
 \returns The passed in secretKey.
 */
- (NSString *)secretKey;

/*!Get the description of the SCSConnectionInfo.
 \returns The description of the SCSConnectionInfo.
 */
- (NSString *)description;

/*!Create a CFHTTPMessageRef from an SCS operation; object returned has a retain count of 1
  and must be released by the caller when finished using the object.
 \param operation The operation from which to create a CFHTTPMessageRef.
 \returns The created CFHTTPMessageRef.
 */
- (CFHTTPMessageRef)newCFHTTPMessageRefFromOperation:(SCSOperation *)operation;

/*!Generate the url for a public bucket.
 \param bucket The name of the bucket.
 \param object The name of the object. Here it should be nil.
 \param security The url use the http (NO) or https (YES).
 \returns The url for a public bucket.
 */
- (NSURL *)publicURLWithBucket:(NSString *)bucket object:(NSString *)object security:(BOOL)security;

/*!Generate the authorized url for a private bucket.
 \param bucket The name of the bucket.
 \param object The name of the object. Here it should be nil.
 \param expires The expires time for the url.
 \param ip The authorized ip that can get the bucket through the url.
 \param security The url use the http (NO) or https (YES).
 \returns The authorized url for a private bucket.
 */
- (NSURL *)authorizationURLWithBucket:(NSString *)bucket object:(NSString *)object expires:(NSDate *)expires ip:(NSString *)ip security:(BOOL)security;

@end
