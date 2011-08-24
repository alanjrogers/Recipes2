 /*
     File: SWPRecipeListTableViewController.h
 Abstract: Table view controller to manage an editable table view that displays a list of recipes.
 Recipes are displayed in a custom table view cell.
 
  Version: 2.0
*/

@class SWPRecipe;
@class SWPRecipeTableViewCell;

@interface SWPRecipeListTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) IBOutlet SWPRecipeTableViewCell* recipeTableViewCell;

- (void)showRecipe:(SWPRecipe *)recipe animated:(BOOL)animated;
- (void)configureCell:(SWPRecipeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
