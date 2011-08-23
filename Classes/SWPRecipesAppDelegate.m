/*
 File: SWPRecipesAppDelegate.h
 Abstract: Application delegate that has: 
 - a navigation controller that in turn loads a table view controller to manage a list of recipes, 
 - a unit converter navigation view controller.
 - Also handles Core Data setup/loading and migration
 
 Version: 2.0
 */

#import "SWPRecipesAppDelegate.h"
#import "SWPRecipeListTableViewController.h"
#import "SWPUnitConverterTableViewController.h"

void HandleCoreDataError(const char* function, const char* file, const int line, NSError* error);

void HandleCoreDataError(const char* function, const char* file, const int line, NSError* error)
{
	// Handle the error...
	NSLog(@"%s:%d - %s - Core Data error: %@", file, line, function, [error localizedDescription]);
	NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
	if(detailedErrors != nil && [detailedErrors count] > 0) 
	{
		for(NSError* detailedError in detailedErrors) 
		{
			NSLog(@"  DetailedError: %@", [detailedError userInfo]);
		}
	}
	else 
	{
		NSLog(@"  %@", [error userInfo]);
	}
}


@implementation SWPRecipesAppDelegate {
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
			HandleCoreDataError(__PRETTY_FUNCTION__, __FILE__, __LINE__, error);
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
	
	NSError *error = nil;
	
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
	
	NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType
																							  URL:storeUrl
																							error:&error];
	
	if (sourceMetadata == nil) {
		HandleCoreDataError(__PRETTY_FUNCTION__, __FILE__, __LINE__, error);
		return nil;
	}
	
	NSManagedObjectModel *destinationModel = [_persistentStoreCoordinator managedObjectModel];
	BOOL pscCompatibile = [destinationModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
	
	if (!pscCompatibile) {
		// need to migrate
		NSManagedObjectModel *sourceModel = [NSManagedObjectModel mergedModelFromBundles:nil forStoreMetadata:sourceMetadata];
		
		if (sourceModel == nil) {
			// deal with error
			return nil;
		}
		
		NSMigrationManager *migrationManager = [[NSMigrationManager alloc] initWithSourceModel:sourceModel destinationModel:destinationModel];
		
		NSMappingModel *mappingModel = [NSMappingModel mappingModelFromBundles:nil forSourceModel:sourceModel destinationModel:destinationModel];
		
		if (mappingModel == nil) {
			// deal with the error
			[migrationManager release];
			return nil;
		}
		NSString *newStorePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"RecipesTemp.sqlite"];
		NSURL* newStoreURL = [NSURL fileURLWithPath:newStorePath];
		
		BOOL ok = [migrationManager migrateStoreFromURL:storeUrl
												   type:NSSQLiteStoreType
												options:nil
									   withMappingModel:mappingModel
									   toDestinationURL:newStoreURL
										destinationType:NSSQLiteStoreType
									 destinationOptions:nil
												  error:&error];
		
		if (!ok) {
			// handle error
			HandleCoreDataError(__PRETTY_FUNCTION__, __FILE__, __LINE__, error);
			[migrationManager release];
			return nil;
		}
		[migrationManager release];
		
		NSString *backupStorePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"RecipesOLD.sqlite"];
		NSURL* backupStoreURL = [NSURL fileURLWithPath:backupStorePath];
		
		[[NSFileManager defaultManager] removeItemAtURL:backupStoreURL error:NULL];
		[[NSFileManager defaultManager] moveItemAtURL:storeUrl toURL:backupStoreURL error:NULL];
		[[NSFileManager defaultManager] moveItemAtURL:newStoreURL toURL:storeUrl error:NULL];
	}
	
	if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		HandleCoreDataError(__PRETTY_FUNCTION__, __FILE__, __LINE__, error);
		return nil;
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
