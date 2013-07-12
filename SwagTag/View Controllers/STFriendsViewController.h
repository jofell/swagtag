//
//  STFriendsViewController.h
//  SwagTag
//
//  Created by Jofell Gallardo on 9/30/12.
//  Copyright (c) 2012 Jofell Gallardo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@interface STFriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;

@end
