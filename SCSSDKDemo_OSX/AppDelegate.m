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

#define kSCSAccessKey              @"YOUR ACCESS KEY"
#define kSCSSecretKey              @"YOUR SECRET KEY"

#ifndef kSCSAccessKey
#error "别忘了填写你的accessKey"
#endif

#ifndef kSCSSecretKey
#error "别忘了填写你的secretKey"
#endif

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
    
    SCSOperationQueue *queue = [[SCSOperationQueue alloc] initWithDelegate:self];
    [SCSOperationQueue setSharedOperationQueue:queue];
    
    if ([kSCSAccessKey isEqualToString:@"YOUR ACCESS KEY"] || [kSCSSecretKey isEqualToString:@"YOUR SECRET KEY"]) {
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"accessKey" ofType:@"plist"]];
        
        if (dictionary == nil) {
            
            NSAssert(dictionary==nil, @"请设置您的accessKey及secretKey");
            return;
            
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
    
    OperationListView *operationListView = [[[OperationListView alloc] initWithFrame:NSMakeRect(15, 15, 180, 460)] autorelease];
    [self.window.contentView addSubview:operationListView];
    
    self.detailView = [[[OperationDetailView alloc] initWithFrame:NSMakeRect(200, 375, 570, 100)] autorelease];
    [self.window.contentView addSubview:_detailView];
    
    self.resultView = [[[OperationResultView alloc] initWithFrame:NSMakeRect(200, 15, 570, 350)] autorelease];
    [self.window.contentView addSubview:_resultView];
}

@end
