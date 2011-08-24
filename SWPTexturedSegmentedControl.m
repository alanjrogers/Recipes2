//
//  SWPTexturedSegmentedControl.m
//  Recipes
//
//  Created by Alan Rogers on 23/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWPTexturedSegmentedControl.h"


@interface _SWPTexturedSegment : NSObject

@property (nonatomic, retain) NSString* title;
@property (nonatomic) CGSize size;
@property (nonatomic, retain) UIFont* font;

+ (id)texturedSegmentWithTitle:(NSString*)title;
- (id)initWithTitle:(NSString*)title;

@end

@implementation _SWPTexturedSegment

@synthesize title = _title;
@synthesize font = _font;
@synthesize size = _size;

+ (id)texturedSegmentWithTitle:(NSString*)title {
	return [[[[self class] alloc] initWithTitle:title] autorelease];
}

- (id)initWithTitle:(NSString*)title {
	self = [super init];
	if (self != nil) {
		_title = [title retain];
		_font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
		_size = [_title sizeWithFont:_font];
	}
	return self;
}

- (void)dealloc {
	[_title release], _title = nil;
	[_font release], _font = nil;
	[super dealloc];
}

@end

@interface SWPTexturedSegmentedControl ()

@property (nonatomic, retain) NSArray* items;

- (void)_updateSize;

@end

#define SWP_SEGMENTED_CONTROL_HEIGHT	29.
#define SWP_SEGMENTED_CONTROL_BASELINE	7.

@implementation SWPTexturedSegmentedControl

@synthesize selectedSegmentIndex = _selectedSegmentIndex;
@synthesize items = _items;

- (id)initWithItems:(NSArray *)items {
	if (self = [super init]) {
		_selectedSegmentIndex = UISegmentedControlNoSegment;
		NSMutableArray* tempArray = [NSMutableArray arrayWithCapacity:[items count]];
		
		for (NSString* title in items) {
			[tempArray addObject:[_SWPTexturedSegment texturedSegmentWithTitle:title]];
		}
		_items = [[NSArray alloc] initWithArray:tempArray];
	}
    return self;
}

- (void)dealloc {
	[_items release], _items = nil;
	[super dealloc];
}

#pragma mark - 
#pragma mark Selected Segment

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
	if (_selectedSegmentIndex != selectedSegmentIndex) {
		_selectedSegmentIndex = selectedSegmentIndex;
		
		if (_selectedSegmentIndex != UISegmentedControlNoSegment) {
			[self sendActionsForControlEvents:UIControlEventValueChanged];
		}
	}
}

#pragma mark -
#pragma mark segment widths

- (void)setWidth:(CGFloat)width forSegmentAtIndex:(NSUInteger)segment {
	if ([self.items count] == 0) return;
	
	if (segment == (NSUInteger)UISegmentedControlNoSegment) return;
	
	if (segment > ([self.items count] - 1)) {
		segment = [self.items count] - 1;
	}
	
	_SWPTexturedSegment* texturedSegment = [self.items objectAtIndex:segment];
	
	texturedSegment.size = CGSizeMake(width, texturedSegment.size.height);
	
	[self _updateSize];
}

- (CGFloat)widthForSegmentAtIndex:(NSUInteger)segment {
	if ([self.items count] == 0) return 0.;
	if (segment == (NSUInteger)UISegmentedControlNoSegment) return 0.;
	
	if (segment > ([self.items count] - 1)) {
		segment = [self.items count] - 1;
	}
	
	return ((_SWPTexturedSegment*)[self.items objectAtIndex:segment]).size.width;
}

- (CGFloat)_totalWidth {
	__block CGFloat _totalWidth = 0.;
	NSUInteger itemCount = [self.items count];
	[self.items enumerateObjectsUsingBlock:^(_SWPTexturedSegment* obj, NSUInteger idx, BOOL *stop) {
		_totalWidth += obj.size.width;
		// Add space for the separator
		if (idx < (itemCount - 1)) {
			_totalWidth += 1.;
		}
	}];
	
	return _totalWidth;
}

- (void)_updateSize {
	[self setBounds:CGRectMake(0., 0., [self _totalWidth], SWP_SEGMENTED_CONTROL_HEIGHT)];
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	
	// Background
	UIImage* stretchableImage = [[UIImage imageNamed:@"segmented-stretch"] stretchableImageWithLeftCapWidth:5. topCapHeight:0.];
	[stretchableImage drawInRect:rect];

	// Separator
	
	UIImage* separatorImage = [UIImage imageNamed:@"segmented-divider"];
	
	__block CGFloat x = 0.;
	CGColorRef shadowColor = CGColorCreateCopyWithAlpha([UIColor blackColor].CGColor, 0.45);

	

	NSUInteger itemCount = [self.items count];
	[self.items enumerateObjectsUsingBlock:^(_SWPTexturedSegment* obj, NSUInteger idx, BOOL *stop) {
		CGRect selectionFrame = CGRectMake(x, 0, obj.size.width, SWP_SEGMENTED_CONTROL_HEIGHT);
		
		if (idx == (NSUInteger)[self selectedSegmentIndex]) {
			[[UIColor blackColor] set];
			UIRectCorner roundingCorners = 0;
			if (idx == 0) {
				roundingCorners = (UIRectCornerTopLeft | UIRectCornerBottomLeft);
			} else if (idx == (itemCount - 1)) {
				roundingCorners = (UIRectCornerTopRight | UIRectCornerBottomRight);
			}
			
			UIBezierPath* selectionPath = [UIBezierPath bezierPathWithRoundedRect:selectionFrame 
																byRoundingCorners:roundingCorners
																	  cornerRadii:CGSizeMake(5., 5.)];
			[selectionPath fillWithBlendMode:kCGBlendModeNormal alpha:0.3];
		}
		UIGraphicsPushContext(UIGraphicsGetCurrentContext());
		
		CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeMake(0, -1.), 0, shadowColor);
		[[UIColor whiteColor] set];
		CGRect titleRect = CGRectMake(x, SWP_SEGMENTED_CONTROL_HEIGHT - SWP_SEGMENTED_CONTROL_BASELINE - obj.size.height, obj.size.width, SWP_SEGMENTED_CONTROL_HEIGHT);
		[obj.title drawInRect:titleRect withFont:[UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
		
		UIGraphicsPopContext();

		x += obj.size.width;
		// Draw separators
		if (idx < (itemCount - 1)) {
			[separatorImage drawAtPoint:CGPointMake(x, 0.)];
			x += 1.;
		}
	}];
	
	// TODO: // Draw selection
	
	CGColorRelease(shadowColor);
}

#pragma mark -
#pragma mark Handling touches

// We will mimic the behaviour of UISegmentedControl here
// - action sent on touch down inside
// - any touch down on the control will send the action
// - before sending the action, work out which segmented was touched and select it.

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	// Touch down inside!
	if ([touch phase] == UITouchPhaseBegan) {
		CGPoint touchPoint = [touch locationInView:self];
		__block CGFloat x = 0.;

		[self.items enumerateObjectsUsingBlock:^(_SWPTexturedSegment* obj, NSUInteger idx, BOOL *stop) {
			if (CGRectContainsPoint(CGRectMake(x, 0., obj.size.width, SWP_SEGMENTED_CONTROL_HEIGHT), touchPoint)) {
				[self setSelectedSegmentIndex:idx];
				*stop = YES;
			}
			x += obj.size.width;
		}];
	}
	
	return NO;
}

@end
