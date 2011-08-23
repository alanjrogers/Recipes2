//
//  SWPTexturedNavigationBar.m
//  Recipes
//
//  Created by Alan Rogers on 23/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWPTexturedNavigationBar.h"

@implementation SWPTexturedNavigationBar

@synthesize backgroundImage = _backgroundImage;

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self != nil) {
		_backgroundImage = [[UIImage imageNamed:@"navigation-background"] retain];
	}
	return self;
}

- (void)dealloc {
	[_backgroundImage release], _backgroundImage = nil;
	[super dealloc];
}

- (void)drawRect:(CGRect)rect {
	if (self.backgroundImage != nil) {
		[self.backgroundImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	} else {
		[super drawRect:rect];
	}
}

@end
