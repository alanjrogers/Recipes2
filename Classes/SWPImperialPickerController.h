/*
     File: SWPImperialPickerController.h
 Abstract: Controller to managed a picker view displaying imperial weights.
 
  Version: 2.0
 
 */

@interface SWPImperialPickerController : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UILabel *label;

- (void)updateLabel;

@end