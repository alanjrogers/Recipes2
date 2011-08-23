/*
     File: SWPTemperatureCell.m 
 Abstract: A table view cell that displays temperature in Centigrade, Fahrenheit, and Gas Mark.
  
  Version: 2.0

 */

#import "SWPTemperatureCell.h"

@implementation SWPTemperatureCell

@synthesize cLabel = _cLabel, fLabel = _fLabel, gLabel = _gLabel;

- (void)setTemperatureDataFromDictionary:(NSDictionary *)temperatureDictionary {
    // Update text in labels from the dictionary
    self.cLabel.text = [temperatureDictionary objectForKey:@"c"];
    self.fLabel.text = [temperatureDictionary objectForKey:@"f"];
    self.gLabel.text = [temperatureDictionary objectForKey:@"g"];
}


- (void)dealloc {
    [_cLabel release], _cLabel = nil;
    [_fLabel release], _fLabel = nil;
    [_gLabel release], _gLabel = nil;
    [super dealloc];
}

@end