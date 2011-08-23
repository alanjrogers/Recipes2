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

/*The default value is UISegmentedControlNoSegment (no segment selected)
 until the user touches a segment. Set this property to -1 to turn off the current selection.
 UISegmentedControl ignores this property when the control is in momentary mode. 
 When the user touches a segment to change the selection, the control event UIControlEventValueChanged is generated;
 if the segmented control is set up to respond to this control event, it sends a action message to its target. */

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
	
	[self.items enumerateObjectsUsingBlock:^(_SWPTexturedSegment* obj, NSUInteger idx, BOOL *stop) {
		_totalWidth += obj.size.width;
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
	
	//UIImage* separatorImage;
	
	__block CGFloat x = 0.;
	
	[self.items enumerateObjectsUsingBlock:^(_SWPTexturedSegment* obj, NSUInteger idx, BOOL *stop) {
		CGRect titleRect = CGRectMake(x, SWP_SEGMENTED_CONTROL_HEIGHT - SWP_SEGMENTED_CONTROL_BASELINE - obj.size.height, obj.size.width, SWP_SEGMENTED_CONTROL_HEIGHT);
		[[UIColor whiteColor] set];
		CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeMake(0, -1.), 0, [UIColor blackColor].CGColor);
		[obj.title drawInRect:titleRect withFont:[UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
		x += obj.size.width;
	}];
	
}

@end
