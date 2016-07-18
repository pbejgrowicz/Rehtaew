//
//  AddCityViewController.h
//  Rehteaw
//
//  Created by Speednet on 12.07.2016.
//  Copyright © 2016 Speednet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "City.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface AddCityViewController : UIViewController

@property (strong, nonatomic) NSDictionary *json;

@end
