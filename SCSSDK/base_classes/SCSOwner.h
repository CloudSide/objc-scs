//
//  SCSOwner.h
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-4-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!SCSOwner */
/*!The SCSOwner is whom the buckets and objects belongs to.*/
/*!It contains the user id in the SCS and the display name.
 */
@interface SCSOwner : NSObject {
    
    NSString *_id;
	NSString *_displayName;
}

/*!Initialize a new SCSOwner immediately after memory for it has been allocated.
 \param uid User id of the owner.
 \param name Display name of the owner.
 \returns The initialized SCSOwner.
 */
- (id)initWithID:(NSString *)uid displayName:(NSString *)name;

/*!Get the user id of the owner.*/
@property(readonly, copy) NSString *ID;

/*!Get the display name of the owner.*/
@property(readonly, copy) NSString *displayName;

@end
