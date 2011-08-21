/*
     File: Ingredient.h
 Abstract: Model class to represent a recipe.
 
  Version: 1.5
 */

@class Recipe;

@interface Ingredient : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *amount;
@property (nonatomic, retain) Recipe *recipe;
@property (nonatomic, retain) NSNumber *displayOrder;

@end



