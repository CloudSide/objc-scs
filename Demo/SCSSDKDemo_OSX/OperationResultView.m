//
//  OperationResultView.m
//  SCSSDKDemo
//
//  Created by Littlebox222 on 14-4-14.
//
//

#import "OperationResultView.h"

@implementation OperationResultView

@synthesize theTextView = _theTextView;

- (void)dealloc {
    
    [_theTextView release];
    
    [super dealloc];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSSize contentSize = [self contentSize];
        
        [self setBorderType:NSNoBorder];
        [self setHasVerticalScroller:YES];
        [self setHasHorizontalScroller:NO];
        [self setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        
        
        self.theTextView = [[[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, contentSize.width, contentSize.height)] autorelease];
        [_theTextView setMinSize:NSMakeSize(0.0, contentSize.height)];
        [_theTextView setMaxSize:NSMakeSize(FLT_MAX, FLT_MAX)];
        [_theTextView setVerticallyResizable:YES];
        [_theTextView setHorizontallyResizable:NO];
        [_theTextView setAutoresizingMask:NSViewWidthSizable];
        
        [[_theTextView textContainer] setContainerSize:NSMakeSize(contentSize.width, FLT_MAX)];
        [[_theTextView textContainer] setWidthTracksTextView:YES];
        [_theTextView setEditable:NO];
        
        [self setDocumentView:_theTextView];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

@end
