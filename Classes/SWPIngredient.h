/*
     File: Ingredient.h
 Abstract: Model class to represent a recipe.
 
  Version: 1.5
 */

@class SWPRecipe;

@interface SWPIngredient : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *amount;
@property (nonatomic, retain) SWPRecipe *recipe;
@property (nonatomic, retain) NSNumber *displayOrder;

@end



