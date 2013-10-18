//
//  ImageViewController.m
//  HFRrehost
//
//  Created by Shasta on 16/10/13.
//
//

#import "ImageViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ImageViewController ()

@end

@implementation ImageViewController

@synthesize imageView;
@synthesize managedObject;
@synthesize imageButton;
@synthesize loadingIndicator;

- (id)initWithManagedObject:(NSManagedObject *)object
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.managedObject = object;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //NSLog(@"date %@", [managedObject valueForKey:@"timeStamp"]);
    //self.view.backgroundColor = [UIColor greenColor];
    
    CGRect frame = CGRectMake(0, 0, kGridWidth, kGridHeight);
    self.view.frame = frame;
    self.view.exclusiveTouch = YES;
    //init
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.loadingIndicator.frame = frame;
    self.imageView = [[UIImageView alloc] initWithFrame:frame];
    self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imageButton.frame = frame;

    
    //conf loadingview
    
    [self.loadingIndicator startAnimating];
    
    //conf imageview
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;

    NSString *url = [NSString stringWithString:[[self.managedObject valueForKey:@"nolink_miniature"] description]];
    url = [url stringByReplacingOccurrencesOfString:@"[img]" withString:@""];
    url = [url stringByReplacingOccurrencesOfString:@"[/img]" withString:@""];
    url = [url stringByReplacingOccurrencesOfString:@"hfr-rehost.net" withString:@"reho.st"];
    
    [self.imageView setImageWithURL:[NSURL URLWithString:url] success:^(UIImage *image, BOOL cached) {
        //success
        NSLog(@"SUCCESS %d %@ %@", cached, NSStringFromCGSize(image.size), url);
    } failure:^(NSError *error) {
        NSLog(@"ERROR %@ %@", error, url);
    }];
    
    //conf button
    [self.imageButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchDown];
    [self.imageButton addTarget:self action:@selector(buttonOut:) forControlEvents:UIControlEventTouchUpOutside];
    [self.imageButton addTarget:self action:@selector(buttonOut:) forControlEvents:UIControlEventTouchCancel];
    [self.imageButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.imageButton.exclusiveTouch = YES;
    
    //add in view
    [self.view addSubview:self.loadingIndicator];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.imageButton];

}


- (void) buttonTouched: (id)sender
{
    NSLog(@"UIControlEventTouchDown");
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.imageButton.backgroundColor = [UIColor blackColor];
                         self.imageButton.alpha = 0.5f;
                     }
                     completion:nil];
    

}
- (void) buttonOut: (id)sender
{
    NSLog(@"UIControlEventTouchUpOutside or UIControlEventTouchCancel");
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.imageButton.backgroundColor = nil;
                         self.imageButton.alpha = 1.0f;
                     }
                     completion:nil];
}


- (void) buttonClicked: (id)sender
{
    NSLog(@"UIControlEventTouchUpInside");
    [self buttonOut:sender];
    
    NSString *notificationName = kShowBBCodeNotification;
    NSString *key = @"managedObject";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:self.managedObject forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:dictionary];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
