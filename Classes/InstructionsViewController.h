/*
     File: InstructionsViewController.h
 Abstract: View controller to manage a text view to allow the user to edit instructions for a recipe.
 
  Version: 1.5
 
 */

@class Recipe;

@interface InstructionsViewController : UIViewController

@property (nonatomic, retain) Recipe *recipe;
@property (nonatomic, retain) IBOutlet UITextView *instructionsText;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;

@end
