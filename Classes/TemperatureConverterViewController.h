 /*
     File: TemperatureConverterViewController.h
 Abstract: View controller to display cooking temperatures in Centigrade, Fahrenheit, and Gas Mark.
 
  Version: 1.5
  
 */

@class TemperatureCell;

@interface TemperatureConverterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
  
@property (nonatomic, readonly, retain) NSArray *temperatureData;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet TemperatureCell *temperatureCell;

@end
