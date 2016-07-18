//
//  TableViewCell.h
//  Rehteaw
//
//  Created by Speednet on 12.07.2016.
//  Copyright © 2016 Speednet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"
@protocol TableViewCellDelegate;

@interface TableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *temp;
@property (weak, nonatomic) IBOutlet UILabel *country;
@property (weak, nonatomic) NSString *urlImage;
@property (nonatomic, strong) City *city;

@property (nonatomic, assign) id <TableViewCellDelegate> delegate;

@end

@protocol TableViewCellDelegate <NSObject>
- (void)cellTapped:(TableViewCell*)cell;
@end
