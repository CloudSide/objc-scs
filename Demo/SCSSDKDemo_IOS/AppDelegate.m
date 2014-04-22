//
//  AppDelegate.m
//  SCSSDKDemo_IOS
//
//  Created by Littlebox222 on 14-4-10.
//
//

#import "AppDelegate.h"

#import "SCSConnectionInfo.h"
#import "SCSOperationQueue.h"
#import "SCSListBucketOperation.h"


#define kSCSAccessKey              @"YOUR ACCESS KEY"
#define kSCSSecretKey              @"YOUR SECRET KEY"

#ifndef kSCSAccessKey
#error "别忘了填写你的accessKey"
#endif

#ifndef kSCSSecretKey
#error "别忘了填写你的secretKey"
#endif

@implementation AppDelegate

@synthesize navigationController = _navigationController;
@synthesize rootViewController = _rootViewController;

- (void)dealloc {
    
    [_rootViewController release];
    [_navigationController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    if ([kSCSAccessKey isEqualToString:@"YOUR ACCESS KEY"] || [kSCSSecretKey isEqualToString:@"YOUR SECRET KEY"]) {
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Config/Config" ofType:@"plist"]];
        
        if (dictionary == nil) {
            
            NSAssert(dictionary==nil, @"请设置您的accessKey及secretKey");
            return NO;
            
        }else {
            
            NSString *accessKey = [dictionary objectForKey:@"accessKey"];
            NSString *secretKey = [dictionary objectForKey:@"secretKey"];
            
            SCSConnectionInfo *connectionInfo = [[SCSConnectionInfo alloc] initWithAccessKey:[accessKey retain] secretKey:[secretKey retain] userInfo:nil secureConnection:NO];
            [SCSConnectionInfo setSharedConnectionInfo:[connectionInfo autorelease]];
        }
        
    }else {
        
        SCSConnectionInfo *connectionInfo = [[SCSConnectionInfo alloc] initWithAccessKey:kSCSAccessKey secretKey:kSCSSecretKey userInfo:nil secureConnection:NO];
        [SCSConnectionInfo setSharedConnectionInfo:[connectionInfo autorelease]];
    }
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    self.rootViewController = [[[RootViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:_rootViewController] autorelease];
    
    self.window.rootViewController = self.navigationController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
