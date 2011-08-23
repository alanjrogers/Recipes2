/*
     File: Recipe.m 
 Abstract: Model class to represent a recipe.
  
  Version: 1.5
*/

#import "SWPRecipe.h"

@implementation SWPRecipe

@dynamic name, image, overview, thumbnailPath, instructions, ingredients, type, prepTime;

- (UIImage*)thumbnailImage {
	return [UIImage imageNamed:self.thumbnailPath];
}

@end

@implementation ImageToDataTransformer

+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}

- (id)transformedValue:(id)value {
	NSData *data = UIImagePNGRepresentation(value);
	return data;
}

- (id)reverseTransformedValue:(id)value {
	UIImage *uiImage = [[UIImage alloc] initWithData:value];
	return [uiImage autorelease];
}

@end