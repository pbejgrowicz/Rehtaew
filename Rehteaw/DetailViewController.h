//
//  DetailViewController.h
//  Rehteaw
//
//  Created by Speednet on 12.07.2016.
//  Copyright © 2016 Speednet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "AppDelegate.h"
#import "City.h"

@interface DetailViewController : UIViewController <NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *temperature;
@property (weak, nonatomic) IBOutlet UILabel *humidity;
@property (weak, nonatomic) IBOutlet UILabel *windDir;
@property (weak, nonatomic) IBOutlet UILabel *windSpeed;
@property (weak, nonatomic) IBOutlet UILabel *pressure;
@property (weak, nonatomic) IBOutlet UILabel *elevation;
@property (weak, nonatomic) NSString *name;
@property (weak, nonatomic) NSIndexPath *cellIndexPath;
@property (weak, nonatomic) City *city;
@property (strong, nonatomic) NSFetchedResultsController *cityFetchResultController;

@end
