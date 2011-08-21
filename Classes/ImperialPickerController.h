/*
     File: ImperialPickerController.h
 Abstract: Controller to managed a picker view displaying imperial weights.
 
  Version: 1.5
 
 */

@interface ImperialPickerController : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UILabel *label;

- (void)updateLabel;

@end
