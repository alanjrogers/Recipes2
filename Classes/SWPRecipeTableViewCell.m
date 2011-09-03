/*
     File: SWPRecipeTableViewCell.m 
 Abstract: A table view cell that displays information about a Recipe.  It uses individual subviews of its content view to show the name, picture, description, and preparation time for each recipe.  If the table view switches to editing mode, the cell reformats itself to move the preparation time off-screen, and resizes the name and description fields accordingly.
  
  Version: 2.0
  
 */

#import "SWPRecipeTableViewCell.h"
#import "SWPRecipe.h"
#import "SWPTopRoundedImageView.h"

#pragma mark -
#pragma mark RecipeTableViewCell implementation

@implementation SWPRecipeTableViewCell
@synthesize recipeImageView = _recipeImageView;

@synthesize recipe = _recipe, nameLabel = _nameLabel, overviewLabel = _overviewLabel, prepTimeLabel = _prepTimeLabel;

- (void)dealloc {
    [_recipe release], _recipe = nil;
    [_nameLabel release], _nameLabel = nil;
    [_overviewLabel release], _overviewLabel = nil;
    [_prepTimeLabel release], _prepTimeLabel = nil;
	[_recipeImageView release];
    [super dealloc];
}

#pragma mark -
#pragma mark Recipe set accessor

- (void)setRecipe:(SWPRecipe *)newRecipe {
    if (newRecipe != _recipe) {
        [_recipe release];
        _recipe = [newRecipe retain];
	}
	self.recipeImageView.image = self.recipe.thumbnailImage;
	self.nameLabel.text = self.recipe.name;
	self.overviewLabel.text = self.recipe.overview;
	self.prepTimeLabel.text = self.recipe.prepTime;
}

@end
