//
//  AddCityViewController.m
//  Rehteaw
//
//  Created by Speednet on 12.07.2016.
//  Copyright © 2016 Speednet. All rights reserved.
//

#import "AddCityViewController.h"

@interface AddCityViewController ()
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@end

@implementation AddCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self.countryTextField.rac_textSignal
       map:^id(NSString *text) {
           if (text.length == 2)
               _saveButton.enabled = YES;
           else
               _saveButton.enabled = FALSE;
           return @(text.length);

       }]
        subscribeNext:^(id x) {
         NSLog(@"%@", x);
     }];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    //[SVProgressHUD showSuccessWithStatus:@"GOOD!"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)saveCity:(id)sender
{
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // time-consuming task
        if ([self createNewCityWithName:self.cityTextField.text country:self.countryTextField.text]) {
            [self refresh];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"Pobrano"];
            [self.navigationController popViewControllerAnimated:YES];
            
        });
        
    });
    
    
}

- (BOOL)createNewCityWithName:(NSString*)name country:(NSString*)countrySigns
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *managedObjectContext =
    appDelegate.managedObjectContext;
    BOOL result = NO;
    
    City *newCity = [NSEntityDescription
                     insertNewObjectForEntityForName:@"City"
                     inManagedObjectContext:managedObjectContext];
    
    if (!newCity) {
        return NO;
    }
    newCity.url = @"http://icons.wxug.com/i/c/k/partlycloudy.gif";
    newCity.name = name;
    newCity.temp = @"";
    newCity.country = countrySigns;
    
    NSError *error;
    
    if ([managedObjectContext save:&error]) {
        result = YES;
    }
    
    return result;
}

- (void)refresh {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error;
    
    NSFetchRequest *req = [[NSFetchRequest alloc]init];
    [req setEntity:[NSEntityDescription entityForName:@"City" inManagedObjectContext:appDelegate.managedObjectContext]];
    NSArray *cities = [appDelegate.managedObjectContext executeFetchRequest:req error:nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    __block int zmienna = 0;
    
    for(City *city in cities){
        
        if([city.name isEqualToString:self.cityTextField.text])
        {
        NSString *nameForJSON = city.name;
        nameForJSON = [nameForJSON stringByReplacingOccurrencesOfString:@"ą" withString:@"a"];
        nameForJSON = [nameForJSON stringByReplacingOccurrencesOfString:@" " withString:@""];
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
        
        NSString *string = [NSString stringWithFormat:@"%@%@/%@.json", @"http://api.wunderground.com/api/84a6f0789786632c/conditions/lang:PL/q/",city.country ,nameForJSON];
        NSURL *URL = [NSURL URLWithString:string];
        
        
        
        [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            _json = responseObject;
            zmienna += 1;
            NSString *temp = [(NSNumber *)_json[@"current_observation"][@"temp_c"] stringValue];
            city.temp = [NSString stringWithFormat:@"%@ °C",temp];
            
            
            city.url = (NSString *)_json[@"current_observation"][@"icon_url"];
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        }
    
        
        
    }
    [appDelegate.managedObjectContext save:&error];
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
