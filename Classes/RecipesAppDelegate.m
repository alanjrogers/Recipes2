/*
     File: RecipesAppDelegate.m 
 Abstract: Application delegate that sets up a tab bar controller with two view controllers -- a navigation controller that in turn loads a table view controller to manage a list of recipes, and a unit converter view controller.
  
  Version: 1.5
*/

#import "RecipesAppDelegate.h"
#import "RecipeListTableViewController.h"
#import "UnitConverterTableViewController.h"

@implementation RecipesAppDelegate {
	NSManagedObjectContext* _managedObjectContext;
	NSManagedObjectModel* _managedObjectModel;
	NSPersistentStoreCoordinator* _persistentStoreCoordinator;
}

@synthesize recipesNavigationController = _recipesNavigationController;
@synthesize window = _window;
@synthesize recipeListController = _recipeListController;
@synthesize converterNavigationController = _converterNavigationController;

#pragma mark -

- (void)switchToRecipesView {
	self.recipeListController.managedObjectContext = self.managedObjectContext;
	self.window.rootViewController = self.recipesNavigationController;
}

- (void)switchToConverterView {
	self.window.rootViewController = self.converterNavigationController;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[self switchToRecipesView];
	[self.window makeKeyAndVisible];
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error;
    if (self.managedObjectContext != nil) {
        if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
	
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return _managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
		
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Recipes.sqlite"];
	/*
	 Set up the store.
	 For the sake of illustration, provide a pre-populated default store.
	 */
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Recipes" ofType:@"sqlite"];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}
	
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	
	NSError *error;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
		
    return _persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)segmentedControlValueChanged:(id)sender {
	if ([(UISegmentedControl*)sender selectedSegmentIndex] == 0) {
		[self switchToRecipesView];
	} else {
		[self switchToConverterView];
	}
}

- (UISegmentedControl*)segmentedControlWithSelectedIndex:(NSUInteger)selectedSegmentIndex {
			
	UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Recipes", @"Converter", nil]];
	
	[segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
	[segmentedControl setSelectedSegmentIndex:selectedSegmentIndex];
	[segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
	
	return [segmentedControl autorelease];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [_managedObjectContext release], _managedObjectContext = nil;
    [_managedObjectModel release], _managedObjectModel = nil;
    [_persistentStoreCoordinator release], _persistentStoreCoordinator = nil;
	[_recipeListController release], _recipeListController = nil;
    [_window release], _window = nil;
	[_recipesNavigationController release], _recipesNavigationController = nil;
	[_converterNavigationController release], _converterNavigationController = nil;
    [super dealloc];
}

@end
