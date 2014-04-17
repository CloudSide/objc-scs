//
//  SCSExtensions.m
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-1.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSExtensions.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>

#define BUFFER_SIZE    4096

static char        base64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

static const short base64DecodingTable[] =
{
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
    -2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
    -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};

@implementation NSDate (SCSExtensions)

- (NSString *)stringWithRFC822Format {
    return [self convertDateToString:self usingFormat:kRFC822DateFormat];
}

- (NSString *)convertDateToString:(NSDate *)date usingFormat:(NSString *)dateFormat {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:dateFormat];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];

    //[dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setLocale:usLocale];
    
    NSString *formatted = [dateFormatter stringFromDate:date];
    
    [dateFormatter release];
    
    return formatted;
}

@end


@implementation NSArray (Comfort)

- (NSArray *)expandPaths
{
	NSMutableArray *a = [NSMutableArray array];
	NSEnumerator *e = [self objectEnumerator];
	NSString *path;
	BOOL dir;
	
	while(path = [e nextObject])
	{
		if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&dir])
		{
			if (!dir)
				[a addObject:path];
			else
			{
				NSString *file;
				NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
				
				while (file = [dirEnum nextObject])
				{
					if (![[file lastPathComponent] hasPrefix:@"."])
					{
						NSString* fullPath = [path stringByAppendingPathComponent:file];
						
						if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&dir])
							if (!dir)
								[a addObject:fullPath];
					}
				}
			}
		}
	}
	return a;
}


- (BOOL)hasObjectSatisfying:(SEL)aSelector withArgument:(id)argument;
{
    NSEnumerator *e = [self objectEnumerator];
    id o;
    while (o = [e nextObject])
    {
        if ([o performSelector:aSelector withObject:argument])
            return TRUE;
    }
    return FALSE;
}

@end

@implementation NSDictionary (URL)

- (NSString *)queryString
{
    if ([self count]==0)
        return @"";
    
    NSMutableString *s = [NSMutableString string];
    NSArray *keys = [self allKeys];
    NSString *k;
    int i;
    
    k = [keys objectAtIndex:0];
    [s appendString:@"?"];
    [s appendString:[k stringByEscapingHTTPReserved]];
    [s appendString:@"="];
    [s appendString:[[self objectForKey:k] stringByEscapingHTTPReserved]];
    
    for (i=1;i<[keys count];i++)
    {
        k = [keys objectAtIndex:i];
        [s appendString:@"&"];
        [s appendString:[k stringByEscapingHTTPReserved]];
        [s appendString:@"="];
        [s appendString:[[self objectForKey:k] stringByEscapingHTTPReserved]];
    }
    return s;
}

@end

@implementation NSMutableDictionary (Comfort)

- (void)safeSetObject:(id)o forKey:(NSString *)k
{
	if ((o==nil)||(k==nil))
		return;
	[self setObject:o forKey:k];
}

- (void)safeSetObject:(id)o forKey:(NSString *)k withValueForNil:(id)d
{
	if (k==nil)
		return;
	if (o!=nil)
		[self setObject:o forKey:k];
	else
		[self setObject:d forKey:k];
}

@end


@implementation NSData (SCSExtensions)

- (NSData *)md5Digest
{
	return nil;
}

- (NSData *)sha1HMacWithKey:(NSString *)key
{
	CCHmacContext context;
    const char    *keyCString = [key cStringUsingEncoding:NSASCIIStringEncoding];
    
    CCHmacInit(&context, kCCHmacAlgSHA1, keyCString, strlen(keyCString));
    CCHmacUpdate(&context, [self bytes], [self length]);
    

    unsigned char digestRaw[CC_SHA1_DIGEST_LENGTH];
    NSInteger digestLength = CC_SHA1_DIGEST_LENGTH;
    
    CCHmacFinal(&context, digestRaw);
    
    NSData *digestData = [NSData dataWithBytes:digestRaw length:digestLength];
    
    return digestData;
}

- (NSString *)encodeBase64
{
    NSMutableString *result;
    unsigned char   *raw;
    unsigned long   length;
    short           i, nCharsToWrite;
    long            cursor;
    unsigned char   inbytes[3], outbytes[4];
    
    length = [self length];
    
    if (length < 1) {
        return @"";
    }
    
    result = [NSMutableString stringWithCapacity:length];
    raw    = (unsigned char *)[self bytes];
    // Take 3 chars at a time, and encode to 4
    for (cursor = 0; cursor < length; cursor += 3) {
        for (i = 0; i < 3; i++) {
            if (cursor + i < length) {
                inbytes[i] = raw[cursor + i];
            }
            else{
                inbytes[i] = 0;
            }
        }
        
        outbytes[0] = (inbytes[0] & 0xFC) >> 2;
        outbytes[1] = ((inbytes[0] & 0x03) << 4) | ((inbytes[1] & 0xF0) >> 4);
        outbytes[2] = ((inbytes[1] & 0x0F) << 2) | ((inbytes[2] & 0xC0) >> 6);
        outbytes[3] = inbytes[2] & 0x3F;
        
        nCharsToWrite = 4;
        
        switch (length - cursor) {
            case 1:
                nCharsToWrite = 2;
                break;
                
            case 2:
                nCharsToWrite = 3;
                break;
        }
        for (i = 0; i < nCharsToWrite; i++) {
            [result appendFormat:@"%c", base64EncodingTable[outbytes[i]]];
        }
        for (i = nCharsToWrite; i < 4; i++) {
            [result appendString:@"="];
        }
    }
    
    return [NSString stringWithString:result];
}


@end

@implementation NSString (SCSExtensions)

- (NSData *)decodeBase64;
{
    if (nil == self || [self length] < 1) {
        return [NSData data];
    }
    
    const char    *inputPtr;
    unsigned char *buffer;
    
    NSInteger     length;
    
    inputPtr = [self cStringUsingEncoding:NSASCIIStringEncoding];
    length   = strlen(inputPtr);
    char ch;
    NSInteger inputIdx = 0, outputIdx = 0, padIdx;
    
    buffer = calloc(length, sizeof(unsigned char));
    
    while (((ch = *inputPtr++) != '\0') && (length-- > 0)) {
        if (ch == '=') {
            if (*inputPtr != '=' && ((inputIdx % 4) == 1)) {
                free(buffer);
                return nil;
            }
            continue;
        }
        
        ch = base64DecodingTable[ch];
        
        if (ch < 0) { // whitespace or other invalid character
            continue;
        }
        
        switch (inputIdx % 4) {
            case 0:
                buffer[outputIdx] = ch << 2;
                break;
                
            case 1:
                buffer[outputIdx++] |= ch >> 4;
                buffer[outputIdx]    = (ch & 0x0f) << 4;
                break;
                
            case 2:
                buffer[outputIdx++] |= ch >> 2;
                buffer[outputIdx]    = (ch & 0x03) << 6;
                break;
                
            case 3:
                buffer[outputIdx++] |= ch;
                break;
        }
        
        inputIdx++;
    }
    
    padIdx = outputIdx;
    
    if (ch == '=') {
        switch (inputIdx % 4) {
            case 1:
                free(buffer);
                return nil;
                
            case 2:
                padIdx++;
                
            case 3:
                buffer[padIdx] = 0;
        }
    }
    
    NSData *objData = [[[NSData alloc] initWithBytes:buffer length:outputIdx] autorelease];
    free(buffer);
    return objData;
}

- (NSNumber *)fileSizeForPath
{
	//NSDictionary *fileAttributes = [[NSFileManager defaultManager] fileAttributesAtPath:self traverseLink:YES];
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self error:nil];
    
	if (fileAttributes==nil)
		return [NSNumber numberWithLongLong:0];
    else
        return [fileAttributes objectForKey:NSFileSize];
}

- (NSString *)readableSizeForPath
{
	//NSDictionary *fileAttributes = [[NSFileManager defaultManager] fileAttributesAtPath:self traverseLink:YES];
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self error:nil];
	if (fileAttributes==nil)
		return @"Unknown";
	
    return [[fileAttributes objectForKey:NSFileSize] readableFileSize];
}

- (NSString *)mimeTypeForPath
{
	return nil;
}

+ (NSString *)readableSizeForPaths:(NSArray *)files
{
	NSString *path;
	unsigned long long total = 0;
	
	for (path in files)
	{
		//NSDictionary *fileAttributes = [[NSFileManager defaultManager] fileAttributesAtPath:path traverseLink:YES];
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
		if (fileAttributes!=nil)
			total = total + [[fileAttributes objectForKey:NSFileSize] unsignedLongLongValue];
	}
	
    return [NSString readableFileSizeFor:total];
}

+ (NSString *)readableFileSizeFor:(unsigned long long) size
{
	if (size == 0.)
		return @"Empty";
	else
		if (size > 0. && size < 1024.)
			return [NSString stringWithFormat:@"%qu bytes", size];
        else
            if (size >= 1024. && size < pow(1024., 2.))
                return [NSString stringWithFormat:@"%.1f KB", (size / 1024.)];
            else
                if (size >= pow(1024., 2.) && size < pow(1024., 3.))
                    return [NSString stringWithFormat:@"%.2f MB", (size / pow(1024., 2.))];
                else
                    if (size >= pow(1024., 3.))
                        return [NSString stringWithFormat:@"%.3f GB", (size / pow(1024., 3.))];
	
	return @"Unknown";
}

+ (NSString *)commonPathComponentInPaths:(NSArray *)paths
{
	NSString *prefix = [NSString commonPrefixWithStrings:paths];
	NSRange r = [prefix rangeOfString:@"/" options:NSBackwardsSearch];
	if (r.location!=NSNotFound)
		return [prefix substringToIndex:(r.location+1)];
	else
		return @"";
}

+ (NSString *)commonPrefixWithStrings:(NSArray *)strings
{
	int sLength = (int)[strings count];
	int i,j;
	
	if (sLength == 1)
		return [strings objectAtIndex:0];
	else
	{
		NSString* prefix = [strings objectAtIndex:0];
		int maxLength = (int)[prefix length];
		
		for (i = 1; i < sLength; i++)
			if ([[strings objectAtIndex:i] length] < maxLength)
				maxLength = (int)[[strings objectAtIndex:i] length];
		
		for (i = 0; i < maxLength; i++) {
			unichar c = [prefix characterAtIndex:i];
			
			for (j = 1; j < sLength; j++) {
				NSString* compareString = [strings objectAtIndex:j];
				
				if ([compareString characterAtIndex:i] != c) {
                    
                    if (i == 0)
						return @"";
					else
						return [prefix substringToIndex:i];
                }
			}
		}
		
		return [prefix substringToIndex:maxLength];
	}
}

@end


@implementation NSNumber (Comfort)

- (NSString *)readableFileSize
{
	return [NSString readableFileSizeFor:[self unsignedLongLongValue]];
}

@end

@implementation NSString (URL)

- (NSString *)stringByEscapingHTTPReserved
{
	// Escape all Reserved characters from rfc 2396 section 2.2
	// except "/" since that's used explicitly in format strings.
	CFStringRef escapeChars = (CFStringRef)@";?:@&=+$,";
	return [(NSString*)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                               (CFStringRef)self, NULL, escapeChars, kCFStringEncodingUTF8)
			autorelease];
}

@end