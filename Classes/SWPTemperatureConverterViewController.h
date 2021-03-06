 /*
     File: SWPTemperatureConverterViewController.h
 Abstract: View controller to display cooking temperatures in Centigrade, Fahrenheit, and Gas Mark.
 
  Version: 2.0
  
 */

@class SWPTemperatureCell;

@interface SWPTemperatureConverterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
  
@property (nonatomic, readonly, retain) NSArray *temperatureData;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet SWPTemperatureCell *temperatureCell;

@end
