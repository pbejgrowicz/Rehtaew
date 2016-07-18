//
//  LocalizationViewController.h
//  Rehtaew
//
//  Created by Speednet on 15.07.2016.
//  Copyright © 2016 Speednet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWRevealViewController/SWRevealViewController.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface LocalizationViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)getCurrentLocation:(id)sender;

@end
