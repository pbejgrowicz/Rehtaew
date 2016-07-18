//
//  CityCustomCellTableViewCell.m
//  Rehteaw
//
//  Created by Speednet on 12.07.2016.
//  Copyright © 2016 Speednet. All rights reserved.
//

#import "CityCustomCellTableViewCell.h"

@implementation CityCustomCellTableViewCell

@synthesize cityName;
@synthesize temp;
@synthesize image;
@synthesize country;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
