//
//  LocalizationViewController.m
//  Rehtaew
//
//  Created by Speednet on 15.07.2016.
//  Copyright © 2016 Speednet. All rights reserved.
//

#import "LocalizationViewController.h"
#define METERS_PER_MILE 1609.344

@interface LocalizationViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *oldLocation;
@property (strong, nonatomic) NSNumber *distance;
@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, retain) MKPolyline *polyline; //your line
@property (nonatomic, retain) MKPolylineView *routeLineView;
@end



@implementation LocalizationViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.activityType = CLActivityTypeFitness;
    self.locationManager.distanceFilter = 10;
    
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }

    [self.locationManager requestLocation];
    self.mapView.showsBuildings = true;
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];

    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
}

- (IBAction)getCurrentLocation:(id)sender
{

    [self.locationManager startUpdatingLocation];
    self.distance = @0;
    self.locations = [NSMutableArray array];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    CLLocationCoordinate2D zoomLocation;
    /*NSLog(@"didUpdateToLocation: %@", [locations lastObject]);
    CLLocation *currentLocation = [locations lastObject];
    if(_oldLocation.coordinate.latitude == 0.0)
        _oldLocation = currentLocation;
    NSLog(@"%f curr", currentLocation.coordinate.longitude);
    NSLog(@"%f prev", _oldLocation.coordinate.longitude);
    
    
    
    if (currentLocation != nil) {
        //self.distance = @([self.distance floatValue] + [currentLocation distanceFromLocation:_oldLocation]/2);
        if(_oldLocation.coordinate.latitude == 0.0)
            _oldLocation = currentLocation;
        
        
        
        //self.distance = self.distance + [currentLocation distanceFromLocation:_oldLocation]
        _speedLabel.text = [NSString stringWithFormat:@"%f km/h",currentLocation.speed * 1.609344];
        _distanceLabel.text = [NSString stringWithFormat:@"%@ m", self.distance];
        
        zoomLocation.latitude = currentLocation.coordinate.latitude;
        zoomLocation.longitude= currentLocation.coordinate.longitude;
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        
        [_mapView setRegion:viewRegion animated:YES];
        
        MKMapCamera *mapCamera = [[MKMapCamera alloc] init];
        mapCamera.centerCoordinate = zoomLocation;
        mapCamera.pitch = 80;
        mapCamera.altitude = 300;
        mapCamera.heading = currentLocation.course;
        
        _mapView.camera = mapCamera;
        
        //_mapView.showsUserLocation = true;
        
        
        
        
    }*/
    
    for (CLLocation *newLocation in locations) {
        if (newLocation.horizontalAccuracy < 20) {
            
            // update distance
            if (self.locations.count > 0) {
                self.distance = @([self.distance floatValue] + [newLocation distanceFromLocation:self.locations.lastObject]);
                NSLog(@"%g", [newLocation distanceFromLocation:self.locations.lastObject]);
                _speedLabel.text = [NSString stringWithFormat:@"%f km/h",newLocation.speed * 1.609344];
                _distanceLabel.text = [NSString stringWithFormat:@"%@ m", self.distance];

            }
            
            [self.locations addObject:newLocation];

            
            zoomLocation.latitude = newLocation.coordinate.latitude;
            zoomLocation.longitude= newLocation.coordinate.longitude;
            
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
            
            [_mapView setRegion:viewRegion animated:YES];
            
            MKMapCamera *mapCamera = [[MKMapCamera alloc] init];
            mapCamera.centerCoordinate = zoomLocation;
            mapCamera.pitch = 80;
            mapCamera.altitude = 300;
            mapCamera.heading = newLocation.course;
            
            _mapView.camera = mapCamera;
            [self drawRoute:self.locations];
        }
        
    }
    
   // _oldLocation = currentLocation;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
    circleRenderer.fillColor = [UIColor greenColor];
    circleRenderer.alpha = 1.f;
    return circleRenderer;
}



- (void)drawRoute:(NSMutableArray *)locations {
    
    CLLocationCoordinate2D coords[self.locations.count];
    
    for (int i = 0; i < self.locations.count; i++) {
        CLLocation *location = [self.locations objectAtIndex:i];
        coords[i] = location.coordinate;
    }
    self.polyline = [MKPolyline polylineWithCoordinates:coords count:self.locations.count];
    [self.mapView addOverlay:self.polyline];
    
    //[self.mapView setVisibleMapRect:[self.polyline boundingMapRect]]; //If you want the route to be visible
    
   [self.mapView addOverlay:self.polyline level:MKOverlayLevelAboveRoads];

}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
