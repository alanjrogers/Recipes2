//
//  SWPTexturedSegmentedControl.h
//  Recipes
//
//  Created by Alan Rogers on 23/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWPTexturedSegmentedControl : UIControl

@property (nonatomic) NSInteger selectedSegmentIndex;

- (void)setWidth:(CGFloat)width forSegmentAtIndex:(NSUInteger)segment;
- (CGFloat)widthForSegmentAtIndex:(NSUInteger)segment;

@end
