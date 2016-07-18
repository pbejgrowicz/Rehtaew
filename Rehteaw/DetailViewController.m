//
//  DetailViewController.m
//  Rehteaw
//
//  Created by Speednet on 12.07.2016.
//  Copyright © 2016 Speednet. All rights reserved.
//

#import "DetailViewController.h"


static NSString  const *apiKey = @"84a6f0789786632c";

@interface DetailViewController ()
{
    NSDictionary *json;
}
@property (weak, nonatomic) IBOutlet UIView *viewTest;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [blurEffectView setFrame:self.view.bounds];
    [self.view insertSubview:blurEffectView belowSubview:_viewTest];
    self.viewTest.backgroundColor = [UIColor clearColor];
    
    RAC(self.cityName, text) = RACObserve(self, city.name);
    RAC(self.temperature, text) = RACObserve(self, city.temp);

    [self downloadData];
    NSLog(@"%@", self.city.url);
    
}

-(void)downloadData
{
    __block int zmienna =0;
    NSString *nameForJSON = self.city.name;
    nameForJSON = [nameForJSON stringByReplacingOccurrencesOfString:@"ą" withString:@"a"];
    nameForJSON = [nameForJSON stringByReplacingOccurrencesOfString:@"ń" withString:@"n"];
    nameForJSON = [nameForJSON stringByReplacingOccurrencesOfString:@"ś" withString:@"s"];
    nameForJSON = [nameForJSON stringByReplacingOccurrencesOfString:@"ć" withString:@"c"];
    nameForJSON = [nameForJSON stringByReplacingOccurrencesOfString:@"ó" withString:@"o"];
    nameForJSON = [nameForJSON stringByReplacingOccurrencesOfString:@"ę" withString:@"e"];
    nameForJSON = [nameForJSON stringByReplacingOccurrencesOfString:@"ł" withString:@"l"];
    nameForJSON = [nameForJSON stringByReplacingOccurrencesOfString:@"Ą" withString:@"A"];
    nameForJSON = [nameForJSON stringByReplacingOccurrencesOfString:@"Ś" withString:@"S"];
    nameForJSON = [nameForJSON stringByReplacingOccurrencesOfString:@"Ć" withString:@"C"];
    nameForJSON = [nameForJSON stringByReplacingOccurrencesOfString:@"Ó" withString:@"O"];
    nameForJSON = [nameForJSON stringByReplacingOccurrencesOfString:@"Ę" withString:@"E"];
    nameForJSON = [nameForJSON stringByReplacingOccurrencesOfString:@"Ł" withString:@"L"];
    nameForJSON = [nameForJSON stringByReplacingOccurrencesOfString:@"Ń" withString:@"N"];
    nameForJSON = [nameForJSON stringByReplacingOccurrencesOfString:@"ż" withString:@"z"];
    nameForJSON = [nameForJSON stringByReplacingOccurrencesOfString:@"ź" withString:@"z"];
    nameForJSON = [nameForJSON stringByReplacingOccurrencesOfString:@"Ż" withString:@"Z"];
    nameForJSON = [nameForJSON stringByReplacingOccurrencesOfString:@"Ź" withString:@"Z"];
    nameForJSON = [nameForJSON stringByReplacingOccurrencesOfString:@" " withString:@""];
   // NSString *string = [NSString stringWithFormat:@"%@%@/%@.json", BaseURLString, self.city.country,nameForJSON];
    NSString *string = [NSString stringWithFormat:@"%@%@%@%@/%@.json", @"http://api.wunderground.com/api/",apiKey,@"/conditions/lang:PL/q/",self.city.country ,nameForJSON];
    NSURL *URL = [NSURL URLWithString:string];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        json = responseObject;
        zmienna++;
        [self parseData];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
}

-(void)updateCityObject:(NSString*)temperature andImage:(NSString*)url
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext =
    appDelegate.managedObjectContext;
    
    if (managedObjectContext == nil) {
        managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"City" inManagedObjectContext:managedObjectContext]];
    
    NSSortDescriptor *citySort = [[NSSortDescriptor alloc]
                                  initWithKey:@"name" ascending:YES];
    
    NSArray *sortDescription = @[citySort];
    request.sortDescriptors = sortDescription;
    
    NSError *error;
    City *city = [[managedObjectContext executeFetchRequest:request error:&error] objectAtIndex:(long)_cellIndexPath.row];
    
    
    city.temp = [NSString stringWithFormat:@"%@ °C", temperature];
    city.url = url;
    
    
    [managedObjectContext save:&error];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)parseData
{
        NSString *temp = [(NSNumber *)json[@"current_observation"][@"temp_c"] stringValue];
        self.temperature.text = [NSString stringWithFormat:@"%@ °C", temp];
        
        NSString *humi = (NSString *)json[@"current_observation"][@"relative_humidity"];
        self.humidity.text = humi;
        
        NSString *windDirection = (NSString *)json[@"current_observation"][@"wind_dir"];
        if ([windDirection isEqualToString:@"Variable"]) {
            windDirection = @"Zmienny";
        }
        self.windDir.text = windDirection;
        
        NSString *pressureMb = [NSString stringWithFormat:@"%@ hPa",(NSString *)json[@"current_observation"][@"pressure_mb"]];
        self.pressure.text = pressureMb;
        
        NSString *temporary = (NSString *)json[@"current_observation"][@"observation_location"][@"elevation"];
        temporary = [temporary stringByReplacingOccurrencesOfString:@" ft" withString:@""]; //zamiana ft na m
        NSNumber *heigth = @([temporary floatValue]);
        heigth = @([heigth floatValue] / 3.2808);
        NSString *elevation12 = [NSString stringWithFormat:@"%.0f m",[heigth floatValue]];
        self.elevation.text = elevation12;
        
        NSString *windSpd = [NSString stringWithFormat:@"%g kph", [[(NSNumber *)json[@"current_observation"][@"wind_kph"] stringValue] floatValue]];
        self.windSpeed.text = windSpd;
    
    NSString *imageURL = (NSString *)json[@"current_observation"][@"icon_url"];
    
        [self updateCityObject:temp andImage:imageURL];
    
}




#pragma mark - Navigation

//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.    
}


@end
