/*
     File: WeightConverterViewController.m 
 Abstract: View controller to manage conversion of metric to imperial units of weight and vice versa.
 The controller uses two UIPicker objects to allow the user to select the weight in metric or imperial units.
  
  Version: 1.5
  
 */

#import "SWPWeightConverterViewController.h"

#import "SWPMetricPickerController.h"
#import "SWPImperialPickerController.h"

@interface SWPWeightConverterViewController ()

@property (nonatomic, assign) NSUInteger selectedUnit;

@end

@implementation SWPWeightConverterViewController

@synthesize pickerViewContainer = _pickerViewContainer;
@synthesize imperialPickerController = _imperialPickerController;
@synthesize imperialPickerViewContainer = _imperialPickerViewContainer;
@synthesize metricPickerController = _metricPickerController;
@synthesize metricPickerViewContainer = _metricPickerViewContainer;
@synthesize segmentedControl = _segmentedControl;
@synthesize selectedUnit = _selectedUnit;

#define METRIC_INDEX 0
#define IMPERIAL_INDEX 1

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.title = @"Weight";
	
	// Set the currently-selected unit for self and the segmented control
	self.selectedUnit = METRIC_INDEX;
	self.segmentedControl.selectedSegmentIndex = self.selectedUnit;	
	
	[self toggleUnit];
}


- (void)viewDidUnload {    
	self.pickerViewContainer = nil;
	
	self.metricPickerController = nil;
	self.metricPickerViewContainer = nil;
	
	self.imperialPickerController = nil;
	self.imperialPickerViewContainer = nil;
	
	self.segmentedControl = nil;

	[super viewDidUnload];
}

- (IBAction)toggleUnit {
	
	/*
	 When the user changes the selection in the segmented control, set the appropriate picker as
	 the current subview of the picker container view (and remove the previous one).
	 */
	self.selectedUnit = [self.segmentedControl selectedSegmentIndex];
	if (self.selectedUnit == IMPERIAL_INDEX) {
		[self.metricPickerViewContainer removeFromSuperview];
		[self.pickerViewContainer addSubview:self.imperialPickerViewContainer];
		[self.imperialPickerController updateLabel];
	} else {
		[self.imperialPickerViewContainer removeFromSuperview];
		[self.pickerViewContainer addSubview:self.metricPickerViewContainer];	
		[self.metricPickerController updateLabel];
	}
}

- (void)dealloc {
	[_pickerViewContainer release], _pickerViewContainer = nil;
    
    [_imperialPickerController release], _imperialPickerController = nil;
	[_imperialPickerViewContainer release], _imperialPickerViewContainer = nil;
    
    [_metricPickerController release], _metricPickerController = nil;
	[_metricPickerViewContainer release], _metricPickerViewContainer = nil;
    
	[_segmentedControl release];
	[super dealloc];
}

@end

