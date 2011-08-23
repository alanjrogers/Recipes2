/*
 File: SWPExtractImagesMigrationPolicy.m
 Abstract: Core Data migration policy to extract images from the old Recipes database.
 
 Version: 2.0
 */


#import "SWPExtractImagesMigrationPolicy.h"

@implementation SWPExtractImagesMigrationPolicy

- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (BOOL)createDestinationInstancesForSourceInstance:(NSManagedObject *)source entityMapping:(NSEntityMapping *)mapping manager:(NSMigrationManager *)manager error:(NSError **)error
{
	NSManagedObject *newObject = nil;
    NSEntityDescription *sourceInstanceEntity = [source entity];
    
    if ([[sourceInstanceEntity name] isEqualToString:@"Recipe"]) {
		// Create the new object
		newObject = [NSEntityDescription insertNewObjectForEntityForName:[sourceInstanceEntity name]
                                                  inManagedObjectContext:[manager destinationContext]];

		NSDictionary *keyValDict = [source committedValuesForKeys:nil];
        NSArray *allKeys = [[[source entity] attributesByName] allKeys];
        for (NSString* key in allKeys) {
			
			if ([key isEqualToString:@"thumbnailImage"]) 
				continue;
			
			// Get key and value
            id value = [keyValDict objectForKey:key];
            
            if (value != [NSNull null]) 
                [newObject setValue:value forKey:key];
        }
		
		// Save thumbnail to disk 
		NSString* thumbnailFolder = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"images"];
		
		[[NSFileManager defaultManager] createDirectoryAtPath:thumbnailFolder withIntermediateDirectories:YES attributes:nil error:NULL];

		NSString* thumbnailFilename = [[newObject valueForKey:@"name"] stringByAppendingPathExtension:@"png"];
		
		UIImage* thumbnailImage = [source valueForKey:@"thumbnailImage"];
		NSData* imageData = UIImagePNGRepresentation(thumbnailImage);
				
		[imageData writeToFile:[thumbnailFolder stringByAppendingPathComponent:thumbnailFilename] atomically:YES];
		
		[newObject setValue:thumbnailFilename forKey:@"thumbnailPath"];
		
	} else if ([[sourceInstanceEntity name] isEqualToString:@"Image"]) {
		// Create the new object
		newObject = [NSEntityDescription insertNewObjectForEntityForName:[sourceInstanceEntity name]
                                                  inManagedObjectContext:[manager destinationContext]];
		
		NSDictionary *keyValDict = [source committedValuesForKeys:nil];
        NSArray *allKeys = [[[source entity] attributesByName] allKeys];
        for (NSString* key in allKeys) {
			
			if ([key isEqualToString:@"image"]) 
				continue;
			
			// Get key and value
            id value = [keyValDict objectForKey:key];
            
            if (value != [NSNull null]) 
                [newObject setValue:value forKey:key];
        }
		
		// Save thumbnail to disk 
		NSString* thumbnailFolder = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"images"];
		
		[[NSFileManager defaultManager] createDirectoryAtPath:thumbnailFolder withIntermediateDirectories:YES attributes:nil error:NULL];
		
		UIImage* thumbnailImage = [source valueForKey:@"image"];
		NSData* imageData = UIImagePNGRepresentation(thumbnailImage);
		
		NSString* thumbnailFilename = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingPathExtension:@"png"];
		
		[imageData writeToFile:[thumbnailFolder stringByAppendingPathComponent:thumbnailFilename] atomically:YES];
		
		[newObject setValue:thumbnailFilename forKey:@"imagePath"];		
    }
	
	[manager associateSourceInstance:source
			 withDestinationInstance:newObject
					forEntityMapping:mapping];
    
    return YES;

}


@end
