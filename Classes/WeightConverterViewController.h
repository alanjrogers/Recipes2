/*
     File: WeightConverterViewController.h
 Abstract: View controller to manage conversion of metric to imperial units of weight and vice versa.
 The controller uses two UIPicker objects to allow the user to select the weight in metric or imperial units.
 
  Version: 1.5
 
 */

@class MetricPickerController;
@class ImperialPickerController;

@interface WeightConverterViewController : UIViewController 

@property (nonatomic, retain) IBOutlet UIView *pickerViewContainer;

@property (nonatomic, retain) IBOutlet MetricPickerController *metricPickerController;
@property (nonatomic, retain) IBOutlet UIView *metricPickerViewContainer;

@property (nonatomic, retain) IBOutlet ImperialPickerController *imperialPickerController;
@property (nonatomic, retain) IBOutlet UIView *imperialPickerViewContainer;

@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)toggleUnit;

@end

