//
//  STViewController.h
//  SwagTag
//
//  Created by Jofell Gallardo on 9/29/12.
//  Copyright (c) 2012 Jofell Gallardo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
@interface STViewController : UIViewController <iCarouselDataSource, iCarouselDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *plankImg;

@property (strong, nonatomic) iCarousel *mainCarousel;
@property (strong, nonatomic) UIView *prevView;
@property (strong, nonatomic) IBOutlet UITableView *mainTableview;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

- (IBAction)toggleView:(id)sender;

@end
