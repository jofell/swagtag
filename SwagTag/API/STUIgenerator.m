//
//  STUIgenerator.m
//  SwagTag
//
//  Created by Jofell Gallardo on 9/30/12.
//  Copyright (c) 2012 Jofell Gallardo. All rights reserved.
//

#import "STUIgenerator.h"

@implementation STUIgenerator

+ (void) generateTitle:(NSString *)title forViewController:(UIViewController *)vc {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100.0, 40.0)];
    label.text = title;
    label.textColor = [UIColor colorWithWhite:84.0/255.0 alpha:1.0];
    label.shadowColor = [UIColor colorWithWhite:240.0/255.0 alpha:0.7];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    vc.navigationItem.titleView = label;
}

@end
