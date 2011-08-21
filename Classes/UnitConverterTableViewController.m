/*
     File: UnitConverterTableViewController.m 
 Abstract: Table view controller to display two table view cells to allow the user to select a unit converter.

  
  Version: 1.5
  
 */

#import "UnitConverterTableViewController.h"

#import "WeightConverterViewController.h"
#import "TemperatureConverterViewController.h"
#import "RecipesAppDelegate.h"

@implementation UnitConverterTableViewController

- (id)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.title = @"Unit Converter";
    }
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Converter";

	UISegmentedControl* segmentedControl = [((RecipesAppDelegate*)[[UIApplication sharedApplication] delegate]) segmentedControlWithSelectedIndex:1];
	
	self.navigationItem.titleView = segmentedControl;
}

// TODO: Figure out how to fix this :P
- (void)viewWillAppear:(BOOL)animated {
	
	[((UISegmentedControl*)self.navigationItem.titleView) setSelectedSegmentIndex:1];
	
	[super viewWillAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#define WeightConverterIndex 0
#define TemperatureConverterIndex 1

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
    }
    
    switch ([indexPath section]) {
        case WeightConverterIndex:
            cell.textLabel.text = @"Weight";
            break;
        case TemperatureConverterIndex:
            cell.textLabel.text = @"Temperature";
            break;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *converterController = nil;
    
    switch ([indexPath section]) {
        case WeightConverterIndex:
            converterController = [[WeightConverterViewController alloc] initWithNibName:@"WeightConverter" bundle:nil];
            break;
        case TemperatureConverterIndex:
            converterController = [[TemperatureConverterViewController alloc] initWithNibName:@"TemperatureConverter" bundle:nil];
            break;
    }
    
    if (converterController) {
        [self.navigationController pushViewController:converterController animated:YES];
		[converterController release];
    }
}

@end