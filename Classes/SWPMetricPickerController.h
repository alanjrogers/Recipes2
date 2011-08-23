/*
     File: SWPMetricPickerController.h
 Abstract: Controller to managed a picker view displaying metric weights.
 
  Version: 2.0
  
 */

@interface SWPMetricPickerController : NSObject <UIPickerViewDataSource, UIPickerViewDelegate> 

@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UILabel *label;

- (UIView *)viewForComponent:(NSInteger)component;
- (void)updateLabel;

@end
