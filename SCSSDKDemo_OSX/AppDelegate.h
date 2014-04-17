//
//  AppDelegate.h
//  SCSSDKDemo_OSX
//
//  Created by Littlebox222 on 14-4-10.
//
//

#import <Cocoa/Cocoa.h>

#import "OperationDetailView.h"
#import "OperationResultView.h"
#import "SCSSDK.h"


@interface AppDelegate : NSObject <NSApplicationDelegate> {
    
    SCSOperationQueue *_queue;
}

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic, retain) OperationDetailView *detailView;
@property (nonatomic, retain) OperationResultView *resultView;


- (SCSOperationQueue *)queue;

@end
