//
//  SCSExtensions.h
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-1.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRFC822DateFormat            @"EEE, dd MMM yyyy HH:mm:ss z"

@interface NSDate (SCSExtensions)

/*!Get the date in form of string with format RFC822.
 \returns The date string.
 */
- (NSString *)stringWithRFC822Format;

/*!Get the date in form of string with user defined format.
 \param date Date to be formatted.
 \param dateFormat Custom format to convert.
 \returns The date string.
 */
- (NSString *)convertDateToString:(NSDate *)date usingFormat:(NSString *)dateFormat;

@end


@interface NSString (Comfort)

/*!Get the long long value of the string.
 \returns The long long value of the string.
 */
- (long long)longLongValue;

@end


@interface NSMutableDictionary (Comfort)

/*!Set the value for key into the dictionary by checking the nil.
 \param o Object to be set.
 \param k Key to be set.
 */
- (void)safeSetObject:(id)o forKey:(NSString *)k;

/*!Set the value for key into the dictionary by checking the nil.
 \param o Object to be set.
 \param k Key to be set.
 \param d Nil object to be set.
 */
- (void)safeSetObject:(id)o forKey:(NSString *)k withValueForNil:(id)d;

@end


@interface NSArray (Comfort)

/*!Set the path for the file from an array.
 \returns The path array.
 */
- (NSArray *)expandPaths;
- (BOOL)hasObjectSatisfying:(SEL)aSelector withArgument:(id)argument;

@end


@interface NSDictionary (URL)

/*!Get the query string from a formed dictionary.
 \returns The query string.
 */
-(NSString *)queryString;

@end


@interface NSData (SCSExtensions)

/*!Get the md5 data of a given data.
 \returns The md5 data.
 */
- (NSData *)md5Digest;

/*!Get the sha1 data with key from a given data.
 \param key The key to calculate the sha1.
 \returns The sha1 data.
 */
- (NSData *)sha1HMacWithKey:(NSString*)key;

/*!Base64 encoding for the data.
 \returns The encoded string.
 */
- (NSString *)encodeBase64;

@end


@interface NSString (SCSExtensions)

/*!Base64 decoding from the string.
 \returns The decoded data.
 */
- (NSData *)decodeBase64;

/*!Get the file size for the given path.
 \returns The file size.
 */
- (NSNumber*)fileSizeForPath;
- (NSString*)mimeTypeForPath;

/*!Get the file size for the given path in the readable format.
 \returns The file size string.
 */
- (NSString*)readableSizeForPath;
+ (NSString*)readableSizeForPaths:(NSArray*)files;
+ (NSString*)readableFileSizeFor:(unsigned long long) size;

/*!Get the common prefix from the given strings.
 \returns The common prefix.
 */
+ (NSString*)commonPrefixWithStrings:(NSArray*)strings;

/*!Get the common path component from the given path strings.
 \returns The common path component.
 */
+ (NSString*)commonPathComponentInPaths:(NSArray*)paths;

@end


@interface NSNumber (Comfort)

/*!Convert the NSNumber to NSString.
 \returns The string converted from the number.
 */
-(NSString*)readableFileSize;

@end


@interface NSString (URL)

/*!Escape all Reserved characters from rfc 2396 except "/" since that's used explicitly in format strings.
 \returns The result string.
 */
- (NSString *)stringByEscapingHTTPReserved;

/*!Escape all Reserved characters from rfc 2396.
 \returns The result string.
 */
- (NSString *)URLEncodedString;
- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding;

@end


@interface NSURL (SCS)

- (NSURL *)URLByAppendingQueryString:(NSString *)queryString;

@end