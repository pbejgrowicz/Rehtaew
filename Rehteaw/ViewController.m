//
//  ViewController.m
//  Rehteaw
//
//  Created by Speednet on 12.07.2016.
//  Copyright © 2016 Speednet. All rights reserved.
//

#import "ViewController.h"


static NSString  const *apiKey = @"84a6f0789786632c";

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sideBarButton setTarget: self.revealViewController];
        [self.sideBarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //self.tableView.backgroundColor = [UIColor colorWithRed:60.0f/255.0f green:60.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
    //self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [blurEffectView setFrame:_tableView.bounds];
    self.tableView.backgroundView = blurEffectView;
   self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [ self getFetchResultController];
    
    [self.tableView registerNib:[UINib
                                 nibWithNibName:NSStringFromClass([TableViewCell class]) bundle:
                                 [NSBundle mainBundle]] forCellReuseIdentifier:@"TableViewCell"];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

    
    


    
}

-(void)viewDidAppear:(BOOL)animated
{
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // time-consuming task
            [self refresh:nil];
        [NSThread sleepForTimeInterval:.5];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    


    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error;
    
    NSFetchRequest *req = [[NSFetchRequest alloc]init];
    [req setEntity:[NSEntityDescription entityForName:@"City" inManagedObjectContext:appDelegate.managedObjectContext]];
    NSArray *cities = [appDelegate.managedObjectContext executeFetchRequest:req error:nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    __block int zmienna = 0;
    
    for(City *city in cities){
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
        
        NSString *string = [NSString stringWithFormat:@"%@%@%@%@/%@.json", @"http://api.wunderground.com/api/",apiKey,@"/conditions/lang:PL/q/",city.country ,nameForJSON];
        NSURL *URL = [NSURL URLWithString:string];
        
        
        
        [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            _json = responseObject;
            zmienna += 1;
            NSString *temp = [(NSNumber *)_json[@"current_observation"][@"temp_c"] stringValue];
            city.temp = [NSString stringWithFormat:@"%@ °C",temp];
            city.url = (NSString *)_json[@"current_observation"][@"icon_url"];
            
            if (zmienna == [@([cities count]) intValue])
            {
                [refreshControl endRefreshing];
            }
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        
        
    }
    [appDelegate.managedObjectContext save:&error];
}

- (NSManagedObjectContext *)managedObjectContext
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication
                                                sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext =
    appDelegate.managedObjectContext;
    return managedObjectContext;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller
{

    [self.tableView reloadData];
}

- (void)getFetchResultController
{
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"City" inManagedObjectContext:[self
                                                                                 managedObjectContext]];
    
    NSSortDescriptor *citySort = [[NSSortDescriptor alloc]
                                  initWithKey:@"name" ascending:YES];
    
    NSArray *sortDescription = @[citySort];
    fetchRequest.sortDescriptors = sortDescription;
    
    [fetchRequest setEntity:entity];
    
    if (!self.cityFetchResultController) {
        self.cityFetchResultController = [[NSFetchedResultsController
                                           alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self
                                                                                                          managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
        self.cityFetchResultController.delegate = self;
    }
    
    NSError *error;
    
    if ([self.cityFetchResultController performFetch:&error]) {
        NSLog(@"Data fetched");
    } else {
        NSLog(@"Can't fetched data");
    }
}

//TableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo =
    [self.cityFetchResultController.sections
     objectAtIndexedSubscript:section];
    return [sectionInfo numberOfObjects];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"TableViewCell";
    
    TableViewCell *cell = [tableView
                           dequeueReusableCellWithIdentifier:MyIdentifier];
    
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.delegate = self;
    
    if (cell == nil)
    {
        cell = [TableViewCell new];
    }
    
    City *cityModel = [self.cityFetchResultController
                  objectAtIndexPath:indexPath];
    cell.city = cityModel;
    //RAC(cell, city) = RACObserve(cityModel, self);
    
    NSURL *urlimg = [NSURL URLWithString:cityModel.url];
    NSData *data = [NSData dataWithContentsOfURL:urlimg];
    UIImage *iconImage = [UIImage imageWithData:data];
    [cell.image setImage:iconImage];
    
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:
(NSIndexPath *)indexPath
{
    return 110;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:
(NSIndexPath *)indexPath
{
    City *cityToDelete = [self.cityFetchResultController
                          objectAtIndexPath:indexPath];
    self.cityFetchResultController.delegate = nil;
    
    [[self managedObjectContext] deleteObject:cityToDelete];
    
    if ([cityToDelete isDeleted]) {
        NSError *error;
        if ([[self managedObjectContext] save:&error]) {
            NSError *fetchingError;
            if ([self.cityFetchResultController
                 performFetch:&fetchingError]) {
                NSArray *rowsToDelete = @[indexPath];
                [self.tableView deleteRowsAtIndexPaths:rowsToDelete
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
    self.cityFetchResultController.delegate = self;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self cellTapped:[self.tableView cellForRowAtIndexPath:indexPath]];
}

- (void)cellTapped:(TableViewCell*)cell
{

    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    City *city = [self.cityFetchResultController
                  objectAtIndexPath:indexPath];
    DetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    controller.city = city;
    controller.cellIndexPath = indexPath;
    [self.navigationController pushViewController:controller
                                         animated:YES];

}



@end
