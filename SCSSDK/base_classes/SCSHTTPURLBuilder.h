//
//  SCSHTTPURLBuilder.h
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-1.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!SCSHTTPURLBuilder */
/*!SCSHTTPURLBuilder is used to build an url for the request from the given protocol scheme, host, object key, query items and port, etc.
 */
@interface SCSHTTPURLBuilder : NSObject {
    
    id delegate;
}

/*!Delegate used to get the protocol scheme, host, object key, query items and port.*/
@property(nonatomic, assign, readwrite) id delegate;

/*!Initialize a new SCSHTTPURLBuilder immediately after memory for it has been allocated.
 \param delegate delegate implementator.
 \returns The initialized SCSHTTPURLBuilder.
 */
- (id)initWithDelegate:(id)delegate;

/*!Get the built url.
 \returns The built url.
 */
- (NSURL *)url;

@end


@interface SCSHTTPURLBuilder (SCSHTTPUrlBuilderDelegateMethods)

/*!Get the protocol scheme passed by the delegate.
 \returns The protocol scheme.
 */
- (NSString *)httpUrlBuilderWantsProtocolScheme:(SCSHTTPURLBuilder *)urlBuilder;

/*!Get the host passed by the delegate.
 \returns The host.
 */
- (NSString *)httpUrlBuilderWantsHost:(SCSHTTPURLBuilder *)urlBuilder;

/*!Get the object key passed by the delegate.
 \returns The object key.
 */
- (NSString *)httpUrlBuilderWantsKey:(SCSHTTPURLBuilder *)urlBuilder; // Does not require '/' as its first char

/*!Get the query items passed by the delegate.
 \returns The query items.
 */
- (NSDictionary *)httpUrlBuilderWantsQueryItems:(SCSHTTPURLBuilder *)urlBuilder;

/*!Get the port number passed by the delegate.
 \returns The port number.
 */
- (int)httpUrlBuilderWantsPort:(SCSHTTPURLBuilder *)urlBuilder;

@end