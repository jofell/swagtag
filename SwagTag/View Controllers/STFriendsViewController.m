//
//  STFriendsViewController.m
//  SwagTag
//
//  Created by Jofell Gallardo on 9/30/12.
//  Copyright (c) 2012 Jofell Gallardo. All rights reserved.
//

#import "STFriendsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "STUIgenerator.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UIImage+Resize.h"
#import "STCoreCalls.h"

@interface STFriendsViewController ()

@property (nonatomic, strong) NSArray *swagNames;
@property (nonatomic, strong) NSArray *swagComments;

@end

@implementation STFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.swagNames = @[
            @"Kirei (iPhone 4S)",
            @"Antonov (Galaxy S3)",
            @"Andrea (Nexus 7)",
            @"Blaine (Blackberry 9930)",
            @"Kendra (Kindle Paperwhite)",
            @"Justin Bieber's Clumper (Clumper 210)",
            @"Joseph Lee's Laptop Bag (Porsche-inspired Clumper)",
            @"Joseph Lee's Messenger (Samsonite Black Label Messenger)",
            @"RJ Miguel's Thesis Pen (Parker Fountain Pen 1918)",
            @"Wifemobile (Toyota Celica)",
        ];
        
        self.swagComments = @[
            @[@"Jopes Gallardo thinks %@ is swag.", @"http://www.avatars.io/facebook/jofell"],
            @[@"Joseph Ross Lee sold %@ to Jopes Gallardo.", @"http://www.avatars.io/facebook/jrosslee"],
            @[@"%@ got a new accessory!", @"http://www.avatars.io/facebook/jofell"],
            @[@"Sam Pinto thinks %@ is swag", @"http://www.avatars.io/facebook/official.sampinto"],
            @[@"Rafael Oca just bought a swag like %@.", @"http://www.avatars.io/facebook/rafaoca"],
            @[@"Christian Besler just bought a swag like %@.", @"http://www.avatars.io/facebook/christian.besler"],
            @[@"Jay Fajardo thinks his swag is better than %@.", @"http://www.avatars.io/facebook/jayfajardo"],
            @[@"Jesse Panganiban gifted a swag similar to %@.", @"http://www.avatars.io/facebook/jpanganibanph"],
            @[@"Justin Bieber thinks %@ is swag.", @"http://www.avatars.io/facebook/JustinBieber"],
            @[@"Barrack Obama thinks his swag is better than %@.", @"http://www.avatars.io/facebook/HackObamaKerdogan"],
        ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.tintColor = [UIColor colorWithWhite:180.0/255.0 alpha:1.0];
    [STUIgenerator generateTitle:@"Friend Swags Feed" forViewController:self];
    
    UIBarButtonItem *barAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                            target:self
                                                                            action:@selector(inviteFriend:)];
    
    
    barAdd.tintColor = [UIColor colorWithWhite:40.0/255.0 alpha:1.0];
    
    self.navigationItem.rightBarButtonItem = barAdd;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    self.mainTableView.separatorColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.tintColor = [UIColor colorWithWhite:180.0/255.0 alpha:1.0];
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Methods

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
    NSInteger item = random_below(10);
    
    NSArray *currItem = [self.swagComments objectAtIndex:message];
    
    cell.textLabel.text = [NSString stringWithFormat:[currItem objectAtIndex:0], [self.swagNames objectAtIndex:item]];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    
    NSURL *url = [NSURL URLWithString:[currItem objectAtIndex:1]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *imageDefault = [[UIImage imageNamed:@"profile"] resizedImage:CGSizeMake(40,40)
                                                     interpolationQuality:kCGInterpolationHigh];
    [cell.imageView setImageWithURL:url placeholderImage:imageDefault];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
}

#pragma mark - Actions

-(IBAction)inviteFriend:(id)sender {
    
    if (!self.friendPickerController) {
        self.friendPickerController = [[FBFriendPickerViewController alloc]
                                       initWithNibName:nil bundle:nil];
        self.friendPickerController.title = @"Select from Facebook";
    }
    
    [self.friendPickerController loadData];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:54.0/255.0
                                                                        green:89/255.0
                                                                         blue:154.0/255.0
                                                                        alpha:1.0];
    [self.navigationController pushViewController:self.friendPickerController
                                         animated:true];
    
    
}
@end
