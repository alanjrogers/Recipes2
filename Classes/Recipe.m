/*
     File: Recipe.m 
 Abstract: Model class to represent a recipe.
  
  Version: 1.5
*/

#import "Recipe.h"

@implementation Recipe

@dynamic name, image, overview, thumbnailImage, instructions, ingredients, type, prepTime;

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