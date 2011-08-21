 /*
     File: RecipeListTableViewController.h
 Abstract: Table view controller to manage an editable table view that displays a list of recipes.
 Recipes are displayed in a custom table view cell.
 
  Version: 1.5
*/

@class Recipe;
@class RecipeTableViewCell;

@interface RecipeListTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)showRecipe:(Recipe *)recipe animated:(BOOL)animated;
- (void)configureCell:(RecipeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
