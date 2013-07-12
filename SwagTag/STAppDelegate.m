//
//  STAppDelegate.m
//  SwagTag
//
//  Created by Jofell Gallardo on 9/29/12.
//  Copyright (c) 2012 Jofell Gallardo. All rights reserved.
//

#import "STAppDelegate.h"
#import "STViewController.h"
#import "STLoginViewController.h"
#import <RestKit/RestKit.h>
#import "STDefaults.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SHSidebarController.h"
#import "STFriendsViewController.h"

NSString *const FBSessionStateChangedNotification = @"co.swagtag.mobile.ios:FBSessionStateChangedNotification";

@implementation STAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    RKClient *client = [RKClient clientWithBaseURLString:ST_OAUTH_BASE_URL];
    client.cachePolicy = RKRequestCachePolicyLoadIfOffline;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([self openFBSession]) {
        [self setupInitialViews];
    } else {
        self.window.rootViewController = [[STLoginViewController alloc] initWithNibName:@"STLoginViewController" bundle:nil];
    }
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) setupInitialViews {
    self.viewController = [[STViewController alloc] initWithNibName:@"STViewController" bundle:nil];
    
    NSDictionary *initVC = @{
    @"vc" :[[UINavigationController alloc] initWithRootViewController:self.viewController],
    @"title" : @"My Swags"
    };
    
    self.friendsViewController = [[STFriendsViewController alloc] initWithNibName:@"STFriendsViewController" bundle:nil];
    
    NSDictionary *friendVC = @{
    @"vc" :[[UINavigationController alloc] initWithRootViewController:self.friendsViewController],
    @"title" : @"Friend Swags"
    };
    
    SHSidebarController *sidebarVC = [[SHSidebarController alloc] initWithArrayOfVC:@[
                                      initVC, friendVC
                                      ]];
    
    
    //self.viewController = [[STLoginViewController alloc] initWithNibName:@"STLoginViewController" bundle:nil];
    
    [NSThread sleepForTimeInterval:1.0];
    
    self.splash = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    self.splash.frame = CGRectMake(0, 0, 320, 480);
    [self.viewController.view addSubview:self.splash];
    [self.viewController.view bringSubviewToFront:self.splash];
    
    self.splash.alpha = 1.0;
    self.window.rootViewController = sidebarVC;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

- (BOOL) openFBSession {
    
    BOOL sessionActive = [FBSession openActiveSessionWithAllowLoginUI:NO];
    
    if (sessionActive) {
        FBCacheDescriptor *friendCacheDescriptor =
        [FBFriendPickerViewController cacheDescriptor];
        [friendCacheDescriptor prefetchAndCacheForSession:FBSession.activeSession];
    }
    
    return sessionActive;
}

@end
