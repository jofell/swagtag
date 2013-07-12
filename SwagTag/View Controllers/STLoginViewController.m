//
//  STLoginViewController.m
//  SwagTag
//
//  Created by Jofell Gallardo on 9/29/12.
//  Copyright (c) 2012 Jofell Gallardo. All rights reserved.
//

#import "STLoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "STAppDelegate.h"

@interface STLoginViewController ()

@end

@implementation STLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginFacebook:(UIButton *)sender {
    
    [FBSession openActiveSessionWithPermissions:@[@"publish_stream", @"email", @"friends_about_me"]
                                   allowLoginUI:YES
                              completionHandler:^(FBSession *session,
                                                  FBSessionState status,
                                                  NSError *error) {
                                  if (session.isOpen) {
                                      FBRequest *me = [FBRequest requestForMe];
                                      
                                      [me startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                                        NSDictionary<FBGraphUser> *my,
                                                                        NSError *error) {
                                          [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"You've logged in... %@ %@", my.first_name, my.last_name]
                                                                      message:@"You've successfully logged in to Facebook."
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil] show];
                                          
                                          NSDictionary *params = @{
                                                @"access_token" : session.accessToken
                                          };
                                          
                                          RKClient *client = [RKClient sharedClient];
                                          [client.requestCache invalidateAll];
                                          [client.HTTPHeaders removeAllObjects];
                                          
                                          [client post:@"/authentication/success"
                                                params:params
                                              delegate:self];
                                          STAppDelegate *delegate = (STAppDelegate *)[UIApplication sharedApplication].delegate;
                                          [delegate setupInitialViews];
                                          
                                      }];
                                  }
                                  
                              }];
    
}

#pragma mark - RKClient methods

- (void)requestDidStartLoad:(RKRequest *)request {
    NSLog(@"Request: %@", request.URL);
}

- (void)request:(RKRequest *)request didReceiveResponse:(RKResponse *)response {
}


- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    
    NSLog(@"Request: %@", request.HTTPBodyString);
    
    if ([response statusCode] == 200) {
        
        NSError *error = nil;
        NSDictionary *responseDict = [response parsedBody:&error];
        NSLog(@"response: %@", responseDict);
        
        if (error == nil) {
            error = nil;
        }
    } else {
        
        [[[UIAlertView alloc] initWithTitle:@"Login Failed"
                                    message:@"Username and password is not a match."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

-(void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:@"Network Error"
                                message:@"Can't copnnect to Friendster."
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
}


@end
