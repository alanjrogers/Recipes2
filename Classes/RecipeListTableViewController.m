/*
     File: RecipeListTableViewController.m 
 Abstract: Table view controller to manage an editable table view that displays a list of recipes.
 Recipes are displayed in a custom table view cell.
  
  Version: 1.5
 */

#import "RecipeListTableViewController.h"
#import "RecipeDetailViewController.h"
#import "Recipe.h"
#import "RecipeTableViewCell.h"

@implementation RecipeListTableViewController

@synthesize managedObjectContext = _managedObjectContext, fetchedResultsController = _fetchedResultsController;

#pragma mark -
#pragma mark UIViewController overrides

- (void)viewDidLoad {
    // Configure the navigation bar
    self.title = @"Recipes";
       
    // Set the table view's row height
    self.tableView.rowHeight = 44.;
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}		
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Support upright orientation only
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Recipe support

- (void)showRecipe:(Recipe *)recipe animated:(BOOL)animated {
    // Create a detail view controller, set the recipe, then push it.
    RecipeDetailViewController *detailViewController = [[RecipeDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    detailViewController.recipe = recipe;
    
    [self.navigationController pushViewController:detailViewController animated:animated];
    [detailViewController release];
}


#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = [[self.fetchedResultsController sections] count];
    
	if (count == 0) {
		count = 1;
	}
	
    return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
	
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    
    return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Dequeue or if necessary create a RecipeTableViewCell, then set its recipe to the recipe for the current row.
    static NSString *RecipeCellIdentifier = @"RecipeCellIdentifier";
    
    RecipeTableViewCell *recipeCell = (RecipeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:RecipeCellIdentifier];
    if (recipeCell == nil) {
        recipeCell = [[[RecipeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RecipeCellIdentifier] autorelease];
		recipeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	[self configureCell:recipeCell atIndexPath:indexPath];
    
    return recipeCell;
}


- (void)configureCell:(RecipeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell
	Recipe *recipe = (Recipe *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.recipe = recipe;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Recipe *recipe = (Recipe *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self showRecipe:recipe animated:YES];
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    // Set up the fetched results controller if needed.
    if (_fetchedResultsController == nil) {
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
        aFetchedResultsController.delegate = self;
        _fetchedResultsController = [aFetchedResultsController retain];
        
        [aFetchedResultsController release];
        [fetchRequest release];
        [sortDescriptor release];
        [sortDescriptors release];
    }
	
	return _fetchedResultsController;
}    

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[_fetchedResultsController release], _fetchedResultsController = nil;
	[_managedObjectContext release], _managedObjectContext = nil;
    [super dealloc];
}

@end
