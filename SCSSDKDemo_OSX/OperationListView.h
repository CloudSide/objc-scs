//
//  OperationListView.h
//  SCSSDKDemo
//
//  Created by Littlebox222 on 14-4-14.
//
//

#import <Cocoa/Cocoa.h>

@interface OperationListView : NSScrollView <NSTableViewDataSource, NSTableViewDelegate> {
    
    NSTableView *_tableView;
}



@end
