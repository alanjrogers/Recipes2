/*
     File: InstructionsViewController.m 
 Abstract: View controller to manage a text view to allow the user to edit instructions for a recipe.
  
  Version: 1.5
  
 */

#import "InstructionsViewController.h"
#import "Recipe.h"

@implementation InstructionsViewController

@synthesize recipe = _recipe;
@synthesize instructionsText = _instructionsText;
@synthesize nameLabel = _nameLabel;

- (void)viewDidLoad {
	[super viewDidLoad];
    UINavigationItem *navigationItem = self.navigationItem;
    navigationItem.title = @"Instructions";
}

- (void)viewDidUnload {
	self.instructionsText = nil;
	self.nameLabel = nil;
	[super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {    
    // Update the views appropriately
    self.nameLabel.text = self.recipe.name;    
    self.instructionsText.text = self.recipe.instructions;    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Support portrait only
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_recipe release], _recipe = nil;
    [_instructionsText release], _instructionsText = nil;
    [_nameLabel release], _nameLabel = nil;
    [super dealloc];
}

@end