/*
     File: RecipeDetailViewController.h
 Abstract: Table view controller to manage an editable table view that displays information about a recipe.
 The table view uses different cell types for different row types.
 
  Version: 1.5
 
 */

@class Recipe;

@interface RecipeDetailViewController : UITableViewController <UINavigationControllerDelegate>

@property (nonatomic, retain) Recipe *recipe;
@property (nonatomic, retain) NSMutableArray *ingredients;

@property (nonatomic, retain) IBOutlet UIView *tableHeaderView;
@property (nonatomic, retain) IBOutlet UIButton *photoButton;
@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UITextField *overviewTextField;
@property (nonatomic, retain) IBOutlet UITextField *prepTimeTextField;

@end
