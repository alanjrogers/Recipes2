//
//  SWPTopRoundedImageView.m
//  RecipesOne
//
//  Created by Alan Rogers on 3/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWPTopRoundedImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SWPTopRoundedImageView

@synthesize image = _image;

- (void)commonInit {
	[self setOpaque:NO];
	[self setBackgroundColor:[UIColor clearColor]];
	[self.layer setContentsGravity:kCAGravityResizeAspectFill];
	[self.layer setMasksToBounds:YES];

	UIBezierPath* roundedPath = [UIBezierPath bezierPathWithRoundedRect:[self bounds] 
													  byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft 
															cornerRadii:CGSizeMake(5., 5.)];
	
	CAShapeLayer* maskLayer = [CAShapeLayer layer];
	[maskLayer setBackgroundColor:[UIColor blackColor].CGColor];
	[maskLayer setPath:roundedPath.CGPath];
	
	[self.layer setMask:maskLayer];
	
	CALayer* innerShadowLayer = [CALayer layer];
	CGRect innerShadowRect = [self bounds];
	innerShadowRect.origin.y = CGRectGetMaxY(innerShadowRect) - 0.5;
	innerShadowRect.size.height = 1.;
	[innerShadowLayer setFrame:innerShadowRect];
	[innerShadowLayer setBackgroundColor:[UIColor colorWithWhite:0. alpha:0.2].CGColor];
	
	[self.layer addSublayer:innerShadowLayer];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if (self != nil) {
		[self commonInit];
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self != nil) {
		[self commonInit];
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
	[self.layer setContents:(id)_image.CGImage];
}

@end
