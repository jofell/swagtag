//
//  STMetaViewController.m
//  SwagTag
//
//  Created by Jofell Gallardo on 9/30/12.
//  Copyright (c) 2012 Jofell Gallardo. All rights reserved.
//

#import "STMetaViewController.h"
#import "STUIgenerator.h"
#import "UIImage+Resize.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "STCoreCalls.h"

@interface STMetaViewController ()

@property (nonatomic, strong) NSArray *swagComments;
@property (nonatomic, strong) NSArray *swagPeeps;
@property (nonatomic, strong) NSString *swagName;

@end

@implementation STMetaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil andSwagName:(NSString *)inSwagName bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.swagComments = @[
            @"%@ thinks %@ is swag.",
            @"%@ sold %@ to Jopes Gallardo.",
            @"%@ got %@ a new accessory!",
            @"%@ thinks %@ is swag",
            @"%@ just bought a swag like %@.",
            @"%@ just bought a swag like %@.",
            @"%@ thinks his swag is better than %@.",
            @"%@ gifted a swag similar to %@.",
            @"%@ thinks %@ is swag.",
            @"%@ thinks his swag is better than %@.",
        ];
        
        self.swagName = inSwagName;
        
        self.swagPeeps = @[
            @[@"Jopes Gallardo", @"http://www.avatars.io/facebook/jofell"],
            @[@"Joseph Ross Lee", @"http://www.avatars.io/facebook/jrosslee"],
            @[@"Brad Pitt", @"http://www.avatars.io/facebook/BradPittOfficialFan"],
            @[@"Sam Pinto", @"http://www.avatars.io/facebook/official.sampinto"],
            @[@"Rafael Oca", @"http://www.avatars.io/facebook/rafaoca"],
            @[@"Christian Besler", @"http://www.avatars.io/facebook/christian.besler"],
            @[@"Jay Fajardo", @"http://www.avatars.io/facebook/jayfajardo"],
            @[@"Jesse Panganiban", @"http://www.avatars.io/facebook/jpanganibanph"],
            @[@"Justin Bieber", @"http://www.avatars.io/facebook/JustinBieber"],
            @[@"Barrack Obama", @"http://www.avatars.io/facebook/HackObamaKerdogan"],
        ];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [STUIgenerator generateTitle:self.swagName forViewController:self];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor colorWithWhite:40.0/255.0 alpha:1.0];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    self.mainTableView.separatorColor = [UIColor colorWithWhite:1.0 alpha:0.1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"feedrow";
    
    UITableViewCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier];
        
        //cell.indentationLevel = 0;
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        cell.textLabel.textColor = [UIColor colorWithWhite:180.0/255.0 alpha:1.0];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:12.0];
        cell.textLabel.shadowColor = [UIColor blackColor];
        cell.textLabel.shadowOffset = CGSizeMake(0.5, 0.5);
        cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
        cell.detailTextLabel.text = @"Just now.";
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:100.0/255.0 alpha:1.0];
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:9.0];
        cell.detailTextLabel.shadowColor = [UIColor blackColor];
        cell.detailTextLabel.shadowOffset = CGSizeMake(0.1, 0.1);
        cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        
    }
    
    cell.imageView.frame = CGRectMake(5, 5, 40, 40);
    
    
    NSInteger message = random_below(10);
    NSInteger person = random_below(10);
    
    NSArray *currPeep = [self.swagPeeps objectAtIndex:person];
    
    cell.textLabel.text = [NSString stringWithFormat:[self.swagComments objectAtIndex:message],
                           [currPeep objectAtIndex:0], self.swagName];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    
    NSURL *url = [NSURL URLWithString:[currPeep objectAtIndex:1]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *imageDefault = [[UIImage imageNamed:@"profile"] resizedImage:CGSizeMake(40,40)
                                                     interpolationQuality:kCGInterpolationHigh];
    [cell.imageView setImageWithURL:url placeholderImage:imageDefault];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
}

@end
