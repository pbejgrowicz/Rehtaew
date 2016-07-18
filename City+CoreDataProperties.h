//
//  City+CoreDataProperties.h
//  
//
//  Created by Speednet on 12.07.2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "City.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface City (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *temp;
@property (nullable, nonatomic, retain) NSString *country;
@property (nullable, nonatomic, retain) NSString *url;
//@property (nullable, nonatomic, retain) UIImage *image;

@end

NS_ASSUME_NONNULL_END
