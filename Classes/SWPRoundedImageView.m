//
//  SWPRoundedImageView.m
//  Recipes
//
//  Created by Alan Rogers on 24/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWPRoundedImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface SWPRoundedImageView ()

@property (nonatomic, retain) CALayer* shapeLayer;

@end

@implementation SWPRoundedImageView

@synthesize image = _image;
@synthesize shapeLayer = _shapeLayer;

- (void)_commonInit {
	[self setOpaque:NO];
	[self.layer setContentsGravity:kCAGravityResizeAspectFill];
	
	CAShapeLayer *shapeLayer = [CAShapeLayer layer];
	[shapeLayer setFillColor:[[UIColor blackColor] CGColor]];
	
	UIBezierPath* roundedPath = [UIBezierPath bezierPathWithRoundedRect:[self bounds] 
													  byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight
															cornerRadii:CGSizeMake(5., 5.)];
	
	
	[shapeLayer setPath:[roundedPath CGPath]];
	
	[self.layer setMask:shapeLayer];
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
	[_shapeLayer release], _shapeLayer = nil;
	[_image release], _image = nil;
	[super dealloc];
}

- (void)setImage:(UIImage *)image {
	if ([_image isEqual:image]) {
		return;
	}
	_image = [image retain];
	
	[(CAShapeLayer*)self.layer setContents:((id)_image.CGImage)];
}


@end
