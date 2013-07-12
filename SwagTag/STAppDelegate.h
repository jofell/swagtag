//
//  STAppDelegate.h
//  SwagTag
//
//  Created by Jofell Gallardo on 9/29/12.
//  Copyright (c) 2012 Jofell Gallardo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STLoginViewController.h"

@class STViewController;

extern NSString *const FBSessionStateChangedNotification;

@interface STAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) UIImageView *splash;

@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) UIViewController *friendsViewController;

- (void) setupInitialViews;

@end
