//
//  STViewController.m
//  SwagTag
//
//  Created by Jofell Gallardo on 9/29/12.
//  Copyright (c) 2012 Jofell Gallardo. All rights reserved.
//

#import "STViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "STUIgenerator.h"
#import "STCoreCalls.h"
#import "STMetaViewController.h"

@interface STViewController ()

@property (nonatomic, strong) NSArray *swagNames;
@property (nonatomic, strong) NSArray *swagComments;
@property (nonatomic, strong) NSArray *swagFeeds;
@property (nonatomic, strong) NSArray *swagMetas;

@end

@implementation STViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.tintColor = [UIColor colorWithWhite:180.0/255.0 alpha:1.0];
    [STUIgenerator generateTitle:@"My Swags" forViewController:self];

    UIBarButtonItem *barAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                            target:self
                                                                            action:@selector(addSwag:)];
    
    
    barAdd.tintColor = [UIColor colorWithWhite:40.0/255.0 alpha:1.0];
    
    self.navigationItem.rightBarButtonItem = barAdd;
    
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
    
    self.swagMetas = @[
        @"iPhone 4S",
        @"Galaxy S3",
        @"Nexus 7",
        @"Blackberry 9930",
        @"Kindle Paperwhite",
        @"Clumper 210",
        @"Porsche-inspired Clumper",
        @"Samsonite Black Label Messenger",
        @"Parker Fountain Pen 1918",
        @"Toyota Celica",
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
    
    NSMutableArray *swagArray = [NSMutableArray arrayWithArray:self.swagComments];
    
    self.swagFeeds = @[
        [swagArray shuffle], [swagArray shuffle], [swagArray shuffle], [swagArray shuffle], [swagArray shuffle],
        [swagArray shuffle], [swagArray shuffle], [swagArray shuffle], [swagArray shuffle], [swagArray shuffle]
    ];
    
    self.mainCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, -200, 320, 200)];
    self.mainCarousel.delegate = self;
    self.mainCarousel.dataSource = self;

    UIImage *image = [UIImage imageNamed:@"bg.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    self.mainCarousel.contentView.backgroundColor = [UIColor clearColor];
    self.mainCarousel.type = iCarouselTypeRotary;
    self.mainCarousel.vertical = NO;
    self.mainCarousel.bounces = YES;
    self.mainCarousel.decelerationRate = 0.0;
    self.mainCarousel.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.mainCarousel];
    
    [self.mainCarousel reloadData];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    self.mainCarousel.frame = CGRectMake(0, 30, 320, 200);
    [UIView commitAnimations];
    
    self.mainTableview.separatorColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    
    [self performSelector:@selector(bounceBack) withObject:nil afterDelay:0.5];
    
}

- (void) bounceBack {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.mainCarousel.frame = CGRectMake(0, 0, 320, 200);
    [UIView commitAnimations];
    
    [self carouselCurrentItemIndexDidChange:self.mainCarousel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleView:(id)sender {
}

#pragma mark - Carousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 10;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    NSLog(@"Index: %d", index);
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"swag%d.jpeg", index + 1 ]];
    
    image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit
                                        bounds:CGSizeMake(200, 200)
                          interpolationQuality:kCGInterpolationHigh];
    
    imgView.image = [image roundedCornerImage:10 borderSize:0];
    
    UIView *mask = [[UIView alloc] initWithFrame:CGRectMake(0, 99.0 - imgView.image.size.height / 2,
                                                            imgView.image.size.width,
                                                            imgView.image.size.height + 2)];
    
    [mask setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.78]];
    mask.layer.cornerRadius = 10.0;
    mask.tag = 169;
    [imgView addSubview:mask];
    
    return imgView;
}


- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 0;
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * _carousel.itemWidth);
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.2f;
        }
        case iCarouselOptionFadeMax:
        {
            if (_carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionFadeRange:
            return 10.0f;
        default:
        {
            return value;
        }
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    
    if (self.prevView != nil) {
        [self.prevView viewWithTag:169].alpha = 1.0;
    }
    UIImageView *imgView = (UIImageView *)carousel.currentItemView;
    [imgView viewWithTag:169].alpha = 0.0;
    
    self.prevView = imgView;
    
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    self.nameLabel.alpha = 0;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(refreshNameLabel)];
    [UIView commitAnimations];
    
    [self.mainTableview reloadData];
    
}

-(void) refreshNameLabel {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    self.nameLabel.alpha = 1.0;
    self.nameLabel.text = [self.swagNames objectAtIndex:self.mainCarousel.currentItemIndex];
    [UIView commitAnimations];
}

-(void) carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    
    STMetaViewController *metaView = [[STMetaViewController alloc] initWithNibName:@"STMetaViewController"
                                                                       andSwagName:[self.swagMetas objectAtIndex:index]
                                                                            bundle:nil];
    
    [self.navigationController pushViewController:metaView animated:YES];
    
}

#pragma mark - Table View Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"feedrow";
    
    UITableViewCell *cell = [self.mainTableview dequeueReusableCellWithIdentifier:identifier];
    
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
    
    NSInteger currSelected = self.mainCarousel.currentItemIndex;
    NSArray *batchItems = [self.swagFeeds objectAtIndex:currSelected];
    
    NSArray *currItem = [batchItems objectAtIndex:indexPath.row];
    
    cell.imageView.frame = CGRectMake(5, 5, 40, 40);
    cell.textLabel.text = [NSString stringWithFormat:[currItem objectAtIndex:0],
                           [self.swagNames objectAtIndex:currSelected]];
    
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
#pragma mark - Action methods

- (IBAction)addSwag:(id)sender {
    
}

- (IBAction)showFriends:(id)sender {
    
}

@end
