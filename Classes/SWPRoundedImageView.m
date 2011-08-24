//
//  SWPRoundedImageView.m
//  Recipes
//
//  Created by Alan Rogers on 24/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWPRoundedImageView.h"

@implementation SWPRoundedImageView

@synthesize image = _image;

- (void)_commonInit {
	[self setOpaque:NO];
	[self setBackgroundColor:[UIColor clearColor]];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if (self != nil) {
		[self _commonInit];
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self != nil) {
		[self _commonInit];
	}
	
	return self;
}

- (void)dealloc {
	[_image release], _image = nil;
	[super dealloc];
}

- (void)setImage:(UIImage *)image {
	if ([_image isEqual:image]) {
		return;
	}
	_image = [image retain];
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	if (self.image == nil) {
		[super drawRect:rect];
	}
	
	UIBezierPath* roundedPath = [UIBezierPath bezierPathWithRoundedRect:rect 
													  byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight
															cornerRadii:CGSizeMake(5., 5.)];
	
	CGContextAddPath(UIGraphicsGetCurrentContext(), [roundedPath CGPath]);
	CGContextClip(UIGraphicsGetCurrentContext());
	
	[self.image drawInRect:rect];

}


@end
