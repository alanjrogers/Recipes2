/*
     File: SWPInstructionsViewController.h
 Abstract: View controller to manage a text view to allow the user to edit instructions for a recipe.
 
  Version: 2.0
 
 */

@class SWPRecipe;

@interface SWPInstructionsViewController : UIViewController

@property (nonatomic, retain) SWPRecipe *recipe;
@property (nonatomic, retain) IBOutlet UITextView *instructionsText;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;

@end