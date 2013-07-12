//
//  STMetaViewController.h
//  SwagTag
//
//  Created by Jofell Gallardo on 9/30/12.
//  Copyright (c) 2012 Jofell Gallardo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STMetaViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil andSwagName:(NSString *)inSwagName bundle:(NSBundle *)nibBundleOrNil;

@end
