/*
     File: RecipeDetailViewController.m 
 Abstract: Table view controller to manage an editable table view that displays information about a recipe.
 The table view uses different cell types for different row types.
  
  Version: 1.5
  
 */

#import "RecipeDetailViewController.h"

#import "Recipe.h"
#import "Ingredient.h"

#import "InstructionsViewController.h"

@implementation RecipeDetailViewController

@synthesize recipe = _recipe;
@synthesize ingredients = _ingredients;

@synthesize tableHeaderView = _tableHeaderView;
@synthesize photoImageView = _photoImageView;
@synthesize nameTextField = _nameTextField, overviewTextField = _overviewTextField, prepTimeTextField = _prepTimeTextField;

#define TYPE_SECTION 0
#define INGREDIENTS_SECTION 1
#define INSTRUCTIONS_SECTION 2


#pragma mark -
#pragma mark View controller

- (void)viewDidLoad {
	[super viewDidLoad];
    // Create and set the table header view.
    if (self.tableHeaderView == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"DetailHeaderView" owner:self options:nil];
        self.tableView.tableHeaderView = self.tableHeaderView;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
	
    self.photoImageView.image = self.recipe.thumbnailImage;
	self.navigationItem.title = self.recipe.name;
    self.nameTextField.text = self.recipe.name;    
    self.overviewTextField.text = self.recipe.overview;    
    self.prepTimeTextField.text = self.recipe.prepTime;    

	/*
	 Create a mutable array that contains the recipe's ingredients ordered by displayOrder.
	 The table view uses this array to display the ingredients.
	 Core Data relationships are represented by sets, so have no inherent order. 
	 Order is "imposed" using the displayOrder attribute, but it would be inefficient to create and sort 
	 a new array each time the ingredients section had to be laid out or updated.
	 */
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
	
	NSMutableArray *sortedIngredients = [[NSMutableArray alloc] initWithArray:[self.recipe.ingredients allObjects]];
	[sortedIngredients sortUsingDescriptors:sortDescriptors];
	self.ingredients = sortedIngredients;

	[sortDescriptor release];
	[sortDescriptors release];
	[sortedIngredients release];
	
	// Update recipe type and ingredients on return.
    [self.tableView reloadData]; 
}

- (void)viewDidUnload {
    self.tableHeaderView = nil;
	self.photoImageView = nil;
	self.nameTextField = nil;
	self.overviewTextField = nil;
	self.prepTimeTextField = nil;
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Only support portait!
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UITableView Delegate/Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    // Return a title or nil as appropriate for the section.
    switch (section) {
        case TYPE_SECTION:
            title = @"Category";
            break;
        case INGREDIENTS_SECTION:
            title = @"Ingredients";
            break;
        default:
            break;
    }
    return title;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    
    /*
     The number of rows depends on the section.
     In the case of ingredients, if editing, add a row in editing mode to present an "Add Ingredient" cell.
	 */
    switch (section) {
        case TYPE_SECTION:
        case INSTRUCTIONS_SECTION:
            rows = 1;
            break;
        case INGREDIENTS_SECTION:
            rows = [self.recipe.ingredients count];
			break;
		default:
            break;
    }
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
     // For the Ingredients section, if necessary create a new cell and configure it with an additional label for the amount.  Give the cell a different identifier from that used for cells in other sections so that it can be dequeued separately.
    if (indexPath.section == INGREDIENTS_SECTION) {
		NSUInteger ingredientCount = [self.recipe.ingredients count];
        NSInteger row = indexPath.row;
		
        if (indexPath.row < ingredientCount) {
            // If the row is within the range of the number of ingredients for the current recipe, then configure the cell to show the ingredient name and amount.
			static NSString *IngredientsCellIdentifier = @"IngredientsCell";
			
			cell = [tableView dequeueReusableCellWithIdentifier:IngredientsCellIdentifier];
			
			if (cell == nil) {
				 // Create a cell to display an ingredient.
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IngredientsCellIdentifier] autorelease];
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			
            Ingredient *ingredient = [self.ingredients objectAtIndex:row];
            cell.textLabel.text = ingredient.name;
			cell.detailTextLabel.text = ingredient.amount;
        } 
    } else {
         // If necessary create a new cell and configure it appropriately for the section.  Give the cell a different identifier from that used for cells in the Ingredients section so that it can be dequeued separately.
        static NSString *MyIdentifier = @"GenericCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        NSString *text = nil;
        
        switch (indexPath.section) {
            case TYPE_SECTION: // type -- should be selectable -> checkbox
                text = [self.recipe.type valueForKey:@"name"];
                cell.accessoryType = UITableViewCellAccessoryNone;
                break;
            case INSTRUCTIONS_SECTION: // instructions
                text = @"Instructions";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            default:
                break;
        }
        
        cell.textLabel.text = text;
    }
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSIndexPath *rowToSelect = indexPath;
    NSInteger section = indexPath.section;

    if (section != INSTRUCTIONS_SECTION) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        rowToSelect = nil;    
    }
	
	return rowToSelect;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    UIViewController *nextViewController = nil;
    
    /*
     What to do on selection depends on what section the row is in.
     For Type, Instructions, and Ingredients, create and push a new view controller of the type appropriate for the next screen.
     */
    switch (section) {
        case INSTRUCTIONS_SECTION:
            nextViewController = [[InstructionsViewController alloc] initWithNibName:@"InstructionsView" bundle:nil];
            ((InstructionsViewController *)nextViewController).recipe = self.recipe;
            break;
		default:
            break;
    }
    
    // If we got a new view controller, push it .
    if (nextViewController) {
        [self.navigationController pushViewController:nextViewController animated:YES];
        [nextViewController release];
    }
}


#pragma mark -
#pragma mark dealloc

- (void)dealloc {
    [_tableHeaderView release], _tableHeaderView = nil;
    [_photoImageView release], _photoImageView = nil;
    [_nameTextField release], _nameTextField = nil;
    [_overviewTextField release], _overviewTextField = nil;
    [_prepTimeTextField release], _prepTimeTextField = nil;
    [_recipe release], _recipe = nil;
    [_ingredients release], _ingredients = nil;
    [super dealloc];
}

@end
