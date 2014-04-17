//
//  AppDelegate.h
//  SCSSDKDemo_IOS
//
//  Created by Littlebox222 on 14-4-10.
//
//

#import <UIKit/UIKit.h>

#import "RootViewController.h"

@class SCSConnectionInfo;
@class SCSOperationQueue;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
    SCSOperationQueue *_queue;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) UINavigationController *navigationController;

@property (nonatomic, retain) RootViewController *rootViewController;


- (SCSOperationQueue *)queue;



@end
