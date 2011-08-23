/*
     File: TemperatureConverterViewController.m 
 Abstract: View controller to display cooking temperatures in Centigrade, Fahrenheit, and Gas Mark.
  
  Version: 1.5

 */

#import "SWPTemperatureConverterViewController.h"
#import "SWPTemperatureCell.h"

@implementation SWPTemperatureConverterViewController {
	NSArray* _temperatureData;
}

@synthesize tableView = _tableView, temperatureCell = _temperatureCell;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
    self.title = @"Temperature";
	self.navigationItem.hidesBackButton = NO;
	self.tableView.allowsSelection = NO;
}

- (void)viewDidUnload {    
	self.tableView = nil;
	self.temperatureCell = nil;
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.temperatureData count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    
    // Create a new TemperatureCell if necessary
    SWPTemperatureCell *cell = (SWPTemperatureCell *)[self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"TemperatureCell" owner:self options:nil];
		cell = self.temperatureCell;
		self.temperatureCell = nil;
    }
    
    // Configure the temperature cell with the relevant data
    NSDictionary *temperatureDictionary = [self.temperatureData objectAtIndex:indexPath.row];
    [cell setTemperatureDataFromDictionary:temperatureDictionary];
    return cell;
}

#pragma mark -
#pragma mark Temperature data

- (NSArray *)temperatureData {
	
	if (_temperatureData == nil) {
		// Get the temperature data from the TemperatureData property list.
		NSString *temperatureDataPath = [[NSBundle mainBundle] pathForResource:@"TemperatureData" ofType:@"plist"];
		NSArray *array = [[NSArray alloc] initWithContentsOfFile:temperatureDataPath];
		_temperatureData = [array retain];
		[array release];
	}
	return _temperatureData;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	[_temperatureData release], _temperatureData = nil;
}


- (void)dealloc {
    [_tableView release], _tableView = nil;
    [_temperatureData release], _temperatureData = nil;
    [super dealloc];
}

@end