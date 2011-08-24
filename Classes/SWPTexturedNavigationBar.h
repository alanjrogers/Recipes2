//
//  SWPTexturedNavigationBar.h
//  Recipes
//
//  Created by Alan Rogers on 23/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWPTexturedNavigationBar : UINavigationBar

@property (nonatomic, retain) UIImage* backgroundImage;

- (UIBarButtonItem*)backButtonItemWithTitle:(NSString*)title;

@end
