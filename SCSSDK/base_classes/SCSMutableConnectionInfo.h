//
//  SCSMutableConnectionInfo.h
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSConnectionInfo.h"

@interface SCSMutableConnectionInfo : SCSConnectionInfo

@end


@interface SCSMutableConnectionInfo (SCSMutableConnectionInfoExtensionMethods)

/*!A delegate is required.
 */
- (void)setDelegate:(id)delegate;

/*!Sets userInfo that can be grabbed later. May be nil. Especially useful for delegates who store a SCSConnectionInfo in certain collections since it effects (contributes to) equality.
 */
- (void)setUserInfo:(NSDictionary *)userInfo;

/*!Insecure by default Resets the port number value to default for secure or insecure connection.
 */
- (void)setSecureConnection:(BOOL)secure;

/*!Uses default port for either secure or insecure connection unless set after secure connection is set.
 */
- (void)setPortNumber:(int)portNumber;

/*!Sets whether this connection should be vitually hosted or not. Defaults to YES.
 */
- (void)setVirtuallyHosted:(BOOL)yesOrNo;

/*!If a host other than the default SCS host endpoint should be specified.
 */
- (void)setHostEndpoint:(NSString *)host;

@end