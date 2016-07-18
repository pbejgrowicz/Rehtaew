//
//  ViewController.h
//  Rehteaw
//
//  Created by Speednet on 12.07.2016.
//  Copyright © 2016 Speednet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SWRevealViewController/SWRevealViewController.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "AppDelegate.h"
#import "City.h"
#import "TableViewCell.h"
#import "DetailViewController.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, TableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *cityFetchResultController;
@property (strong, nonatomic) NSDictionary *json;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;

@end

