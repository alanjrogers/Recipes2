/*
     File: SWPRecipeListTableViewController.m 
 Abstract: Table view controller to manage an editable table view that displays a list of recipes.
 Recipes are displayed in a custom table view cell.
  
  Version: 2.0
 */

#import "SWPRecipeListTableViewController.h"
#import "SWPRecipeDetailViewController.h"
#import "SWPRecipe.h"
#import "SWPRecipeTableViewCell.h"
#import "SWPRecipesAppDelegate.h"

@implementation SWPRecipeListTableViewController

@synthesize managedObjectContext = _managedObjectContext, fetchedResultsController = _fetchedResultsController;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[_fetchedResultsController release], _fetchedResultsController = nil;
	[_managedObjectContext release], _managedObjectContext = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController overrides

- (void)viewDidLoad {
	[super viewDidLoad];
    // Configure the navigation bar
    self.title = @"Recipes";
	
	UISegmentedControl* segmentedControl = [((SWPRecipesAppDelegate*)[[UIApplication sharedApplication] delegate]) segmentedControlWithSelectedIndex:0];
	
	self.navigationItem.titleView = segmentedControl;
	
    // Set the table view's row height
    self.tableView.rowHeight = 44.;
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		HandleCoreDataError(__PRETTY_FUNCTION__, __FILE__, __LINE__, error);
	}		
}

- (void)viewWillAppear:(BOOL)animated {
	
	[((UISegmentedControl*)self.navigationItem.titleView) setSelectedSegmentIndex:0];
	
	[super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Support upright orientation only
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Recipe support

- (void)showRecipe:(SWPRecipe *)recipe animated:(BOOL)animated {
    // Create a detail view controller, set the recipe, then push it.
    SWPRecipeDetailViewController *detailViewController = [[SWPRecipeDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
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
    
    SWPRecipeTableViewCell *recipeCell = (SWPRecipeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:RecipeCellIdentifier];
    if (recipeCell == nil) {
        recipeCell = [[[SWPRecipeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RecipeCellIdentifier] autorelease];
		recipeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	[self configureCell:recipeCell atIndexPath:indexPath];
    
    return recipeCell;
}

- (void)configureCell:(SWPRecipeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell
	SWPRecipe *recipe = (SWPRecipe *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.recipe = recipe;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	SWPRecipe *recipe = (SWPRecipe *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
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

@end
