//
//  CustomCellView.m
//  SCSSDKDemo
//
//  Created by Littlebox222 on 14-4-14.
//
//

#import "CustomCellView.h"

@implementation CustomCellView

@synthesize textLabel = _textLabel;

- (void)dealloc {
    
    [_textLabel release];
    [super dealloc];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.textLabel = [[[NSTextField alloc] initWithFrame:NSMakeRect(0,0,self.frame.size.width, self.frame.size.height)] autorelease];
        [_textLabel setBordered:YES];
        [_textLabel setBezeled:NO];
        [_textLabel setDrawsBackground:NO];
        [_textLabel setEditable:NO];
        [_textLabel setSelectable:NO];
        NSCell *cell = _textLabel.cell;
        [cell setLineBreakMode:NSLineBreakByTruncatingMiddle];
        
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

@end
