//
//  TableViewCell.m
//  Rehteaw
//
//  Created by Speednet on 12.07.2016.
//  Copyright © 2016 Speednet. All rights reserved.
//

#import "TableViewCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "City.h"

@implementation TableViewCell

@synthesize image;
@synthesize cityName;
@synthesize temp;
@synthesize country;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    RAC(self.temp, text) = RACObserve(self, city.temp);
    RAC(self.cityName, text) = RACObserve(self, city.name);
    RAC(self.country, text) = RACObserve(self, city.country);
    RAC(self, urlImage) = RACObserve(self, city.url);
    
    NSURL *urlimg = [NSURL URLWithString:_urlImage];
    NSData *data = [NSData dataWithContentsOfURL:urlimg];
    UIImage *iconImage = [UIImage imageWithData:data];
    [self.image setImage:iconImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
