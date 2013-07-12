//
//  STLoginViewController.h
//  SwagTag
//
//  Created by Jofell Gallardo on 9/29/12.
//  Copyright (c) 2012 Jofell Gallardo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface STLoginViewController : UIViewController <RKRequestDelegate>
- (IBAction)loginFacebook:(UIButton *)sender;

@end
