/*
     File: SWPRecipesAppDelegate.h
 Abstract: Application delegate that has: 
  - a navigation controller that in turn loads a table view controller to manage a list of recipes, 
  - a unit converter navigation view controller.
 
  Version: 2.0
*/

@class SWPRecipeListTableViewController;
@class SWPUnitConverterTableViewController;

@interface SWPRecipesAppDelegate : NSObject <UIApplicationDelegate> 

@property (nonatomic, retain) IBOutlet UINavigationController *recipesNavigationController;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SWPRecipeListTableViewController *recipeListController;
@property (nonatomic, retain) IBOutlet UINavigationController *converterNavigationController;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;

// Segmented Control for switching between converter and Recipes.
- (UISegmentedControl*)segmentedControlWithSelectedIndex:(NSUInteger)selectedSegmentIndex;

@end

extern void HandleCoreDataError(const char* function, const char* file, const int line, NSError* error);
