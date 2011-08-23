/*
     File: RecipesAppDelegate.h
 Abstract: Application delegate that sets up a tab bar controller with two view controllers -- a navigation controller that in turn loads a table view controller to manage a list of recipes, and a unit converter view controller.
 
  Version: 1.5
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

// Segmented Control
- (UISegmentedControl*)segmentedControlWithSelectedIndex:(NSUInteger)selectedSegmentIndex;

@end

