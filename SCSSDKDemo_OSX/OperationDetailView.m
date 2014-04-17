//
//  OperationDetailView.m
//  SCSSDKDemo
//
//  Created by Littlebox222 on 14-4-14.
//
//

#import "OperationDetailView.h"

@implementation OperationDetailView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setEditable:NO];
        [self setFont:[NSFont systemFontOfSize:14]];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

@end
