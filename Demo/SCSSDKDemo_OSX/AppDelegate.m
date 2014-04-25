//
//  AppDelegate.m
//  SCSSDKDemo_OSX
//
//  Created by Littlebox222 on 14-4-10.
//
//

#import "AppDelegate.h"

#import "OperationDetailView.h"
#import "OperationResultView.h"
#import "OperationListView.h"


@implementation AppDelegate

@synthesize detailView = _detailView;
@synthesize resultView = _resultView;

- (void)dealloc {
    
    [_detailView release];
    [_resultView release];
    
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
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
    
    OperationListView *operationListView = [[[OperationListView alloc] initWithFrame:NSMakeRect(15, 15, 180, 547)] autorelease];
    [self.window.contentView addSubview:operationListView];
    
    self.detailView = [[[OperationDetailView alloc] initWithFrame:NSMakeRect(200, 462, 570, 100)] autorelease];
    [self.window.contentView addSubview:_detailView];
    
    self.resultView = [[[OperationResultView alloc] initWithFrame:NSMakeRect(200, 15, 570, 437)] autorelease];
    [self.window.contentView addSubview:_resultView];
}

- (NSDictionary *)keys {
    
    return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Config/Config" ofType:@"plist"]];
}

@end
