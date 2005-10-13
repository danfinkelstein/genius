//
//  ColorView.m
//  Genius2
//
//  Created by John R Chang on 2005-10-12.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "ColorView.h"


@implementation ColorView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		_backgroundColor = [[NSColor windowBackgroundColor] retain];
		_frameColor = [[NSColor grayColor] retain];
    }
    return self;
}

- (void) dealloc
{
	[_backgroundColor release];
	[_frameColor release];
	[super dealloc];
}

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
	[_backgroundColor set];
	NSRectFill(rect);
	
	[_frameColor set];
	rect = NSInsetRect(rect, -1.0, 0.0);	// XXX: hack to draw only the top and bottom borders, actually
	NSFrameRect(rect);
}


- (void) setBackgroundColor:(NSColor *)color
{
	[_backgroundColor release];
	_backgroundColor = [color copy];
}

- (void) setFrameColor:(NSColor *)color
{
	[_frameColor release];
	_frameColor = [color copy];
}

@end
