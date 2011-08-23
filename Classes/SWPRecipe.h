/*
     File: SWPRecipe.h
 Abstract: Model class to represent a recipe.
 
  Version: 2.0
 */

@interface ImageToDataTransformer : NSValueTransformer
@end

@interface SWPRecipe : NSManagedObject

@property (nonatomic, retain) NSString *instructions;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *overview;
@property (nonatomic, retain) NSString *prepTime;
@property (nonatomic, retain) NSSet *ingredients;
@property (nonatomic, retain) NSString *thumbnailPath;
@property (nonatomic, readonly) UIImage* thumbnailImage;

@property (nonatomic, retain) NSManagedObject *image;
@property (nonatomic, retain) NSManagedObject *type;

@end

@interface SWPRecipe (CoreDataGeneratedAccessors)
- (void)addIngredientsObject:(NSManagedObject *)value;
- (void)removeIngredientsObject:(NSManagedObject *)value;
- (void)addIngredients:(NSSet *)value;
- (void)removeIngredients:(NSSet *)value;
@end

