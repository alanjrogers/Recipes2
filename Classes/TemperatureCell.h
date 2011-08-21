/*
     File: TemperatureCell.h
 Abstract: A table view cell that displays temperature in Centigrade, Fahrenheit, and Gas Mark.
 
  Version: 1.5
 
 */

@interface TemperatureCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *cLabel;
@property (nonatomic, retain) IBOutlet UILabel *fLabel;
@property (nonatomic, retain) IBOutlet UILabel *gLabel;

- (void)setTemperatureDataFromDictionary:(NSDictionary *)temperatureDictionary;

@end
