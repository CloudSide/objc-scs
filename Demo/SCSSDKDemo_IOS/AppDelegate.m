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
    
    NSString *accessKey = @"Your Access Key";
    NSString *secretKey = @"Your Secret Key";
    
    
    
    
    
    
    /* 您可以添加Config.plist文件到Config目录下，用来存放accessKey与secretKey，若未添加此处可忽略 */
    /* ----------------------------------------------- */
    NSDictionary *dictionary = [self keys];
    
    if (dictionary != nil && [dictionary isKindOfClass:[NSDictionary class]]) {
        
        accessKey = [dictionary objectForKey:@"accessKey"];
        secretKey = [dictionary objectForKey:@"secretKey"];
    }
    
    /* ----------------------------------------------- */
    
    
    
    
    
    
    NSAssert(!([accessKey isEqualToString:@"Your Access Key"] || [secretKey isEqualToString:@"Your Secret Key"]), @"请设置您的accessKey及secretKey");
    
    SCSConnectionInfo *connectionInfo = [[SCSConnectionInfo alloc] initWithAccessKey:accessKey secretKey:secretKey userInfo:nil secureConnection:NO];
    [SCSConnectionInfo setSharedConnectionInfo:[connectionInfo autorelease]];
    
    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
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

- (NSDictionary *)keys {
    
    return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Config/Config" ofType:@"plist"]];
}

@end
