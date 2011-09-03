//
//  SWPTexturedNavigationBar.m
//  Recipes
//
//  Created by Alan Rogers on 23/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWPTexturedNavigationBar.h"
#import "SWPRecipesAppDelegate.h"

#define SWP_BACK_BUTTON_HEIGHT 32.
#define SWP_BACK_BUTTON_MAX_WIDTH 160.

@implementation SWPTexturedNavigationBar {
	UIImage* _backgroundImage;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self != nil) {
		_backgroundImage = [[UIImage imageNamed:@"navigation-background"] retain];
		
		self.clipsToBounds = NO;
		
		UIImageView* shadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation-shadow"]];
		
		CGRect shadowFrame = [self bounds];
		shadowFrame.origin.y = CGRectGetHeight(shadowFrame);
		shadowFrame.size.height = 5.;
		[shadowView setFrame:shadowFrame];
		[shadowView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
		[self addSubview:shadowView];
				
		[shadowView release];
	}
	return self;
}

- (void)dealloc {
	[_backgroundImage release], _backgroundImage = nil;
	[super dealloc];
}

- (void)back:(id)sender {
	// this ain't pretty :)
	SWPRecipesAppDelegate* appDelegate = (SWPRecipesAppDelegate*)[[UIApplication sharedApplication] delegate];
	UINavigationController* topNavigationController = (UINavigationController*)[[appDelegate window] rootViewController];
	if (topNavigationController != nil) {
		[topNavigationController popViewControllerAnimated:YES];
	}
}

- (UIBarButtonItem*)backButtonItemWithTitle:(NSString*)title {
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	CGFloat leftCapWidth = 13.;
	
	// Set the title to use the same font and shadow as the standard back button
	button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
	button.titleLabel.textColor = [UIColor greenColor];
	button.titleLabel.shadowOffset = CGSizeMake(0., -1.);
	button.titleLabel.shadowColor = [UIColor colorWithWhite:0. alpha:0.45];
	
	button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
	button.titleEdgeInsets = UIEdgeInsetsMake(0., 9., 0., 1.);
	
	UIImage* buttonImage = [[UIImage imageNamed:@"backbutton-stretch"] stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:0.];
	UIImage* highlightedButtonImage = [[UIImage imageNamed:@"backbutton-stretch-highlighted"] stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:0.];

	CGSize textSize = [title sizeWithFont:button.titleLabel.font];
	button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y + 2., MIN(textSize.width + leftCapWidth*2., SWP_BACK_BUTTON_MAX_WIDTH), SWP_BACK_BUTTON_HEIGHT);
	[button setTitle:title forState:UIControlStateNormal];
	[button setBackgroundImage:buttonImage forState:UIControlStateNormal];
	[button setBackgroundImage:highlightedButtonImage forState:UIControlStateHighlighted];
	
	[button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];

	return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

- (void)drawRect:(CGRect)rect {
	[_backgroundImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end
