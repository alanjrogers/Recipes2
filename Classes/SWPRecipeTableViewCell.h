/*
     File: SWPRecipeTableViewCell.h
 Abstract: A table view cell that displays information about a Recipe.  It uses individual subviews of its content view to show the name, picture, description, and preparation time for each recipe.  If the table view switches to editing mode, the cell reformats itself to move the preparation time off-screen, and resizes the name and description fields accordingly.
 
  Version: 2.0

 */

#import "SWPRecipe.h"

@interface SWPRecipeTableViewCell : UITableViewCell 

@property (nonatomic, retain) SWPRecipe *recipe;

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *overviewLabel;
@property (nonatomic, retain) UILabel *prepTimeLabel;

@end