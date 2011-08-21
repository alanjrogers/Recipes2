/*
     File: RecipesAppDelegate.h
 Abstract: Application delegate that sets up a tab bar controller with two view controllers -- a navigation controller that in turn loads a table view controller to manage a list of recipes, and a unit converter view controller.
 
  Version: 1.5
*/

@class RecipeListTableViewController;
@class UnitConverterTableViewController;

@interface RecipesAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UINavigationController *recipesNavigationController;
@property (nonatomic, retain) IBOutlet UINavigationController *unitConverterNavigationController;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RecipeListTableViewController *recipeListController;
@property (nonatomic, retain) IBOutlet UnitConverterTableViewController *unitConverterViewController;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;

@end

