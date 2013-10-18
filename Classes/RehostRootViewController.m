//
//  RehostRootViewController.m
//  HFRrehost
//
//  Created by Shasta on 16/10/13.
//
//

#import "RehostRootViewController.h"
#import "ImageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ColoredButtonBlue.h"
#import "ColoredButtonBlack.h"
#import "UIImage-Extensions.h"

@interface RehostRootViewController ()

@end

@implementation RehostRootViewController

@synthesize imagesScrollView, containerView;
@synthesize fetchedResultsController=fetchedResultsController_, managedObjectContext=managedObjectContext_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(CGPoint)CGPointForIndex:(int)i {
    float paddingH = ((self.view.frame.size.height - kGridHeight*1.25)/2)/1.25;
    float paddingW = ((self.view.frame.size.width - kGridWidth*1.25)/2)/1.25;
    
    float x = 0;
    float y = 0;
    
//    NSLog(@"mod %d", i%3);
//    NSLog(@"div %d", i/3);
    
    x = paddingW + i%3 * kGridWidth + i%3 * kGridSpacing;
    y = paddingH + i/3 * kGridHeight + i/3 * kGridSpacing;
    
    return CGPointMake(x, y);
}

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
	// Do any additional setup after loading the view.

    self.imagesScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.imagesScrollView.backgroundColor = [UIColor redColor];
    self.imagesScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.imagesScrollView.alwaysBounceVertical = YES;
    
    self.containerView = [[UIView alloc] initWithFrame:self.view.frame];
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
    NSLog(@"nbImg %d", [sectionInfo numberOfObjects]);
    //NSLog(@"obj %@", [sectionInfo objects]);
    
    int nbImg = [sectionInfo numberOfObjects];
    
    float paddingH = ((self.view.frame.size.height - kGridHeight*1.25)/2)/1.25;
    float paddingW = ((self.view.frame.size.width - kGridWidth*1.25)/2)/1.25;
    
    NSLog(@"%f %f", paddingW, paddingH);
//    float x = paddingW;
//    float y = paddingH;
    int i = 0;
    
    NSArray* reversedArray = [[[sectionInfo objects] reverseObjectEnumerator] allObjects];
    
    for (NSManagedObject *managedObject in reversedArray) {
        
        ImageViewController *imc = [[ImageViewController alloc] initWithManagedObject:managedObject];

        CGPoint point = [self CGPointForIndex:i];
        
        CGRect frame = CGRectMake(point.x, point.y, kGridWidth, kGridHeight);
        imc.view.frame = frame;

//        NSLog(@"OK %d %f %f",i, x, y);
        NSLog(@"OK %d %f %f",i, point.x, point.y);
        //NSLog(@"====== =======");
        /*
        x += kGridWidth + kGridSpacing;
        
        if (i > 0 && i%3 == 2) {
            y += kGridHeight + kGridSpacing;
            x = paddingW;
        }
        */
        if (i > 7) {
            break;
        }
        
        [self.containerView addSubview:imc.view];
        i++;
        
        
    }

    // Tell the scroll view the size of the contents

    

    self.imagesScrollView.contentSize = CGSizeMake(640 + paddingW*2, ceil(nbImg/3.0f)*(kGridHeight+kGridSpacing)-kGridSpacing + paddingH*2);
    
    CGRect frameC = self.containerView.frame;
    frameC.size = CGSizeMake(640 + paddingW*2, ceil(nbImg/3.0f)*(kGridHeight+kGridSpacing)-kGridSpacing + paddingH*2);
    self.containerView.frame = frameC;
    
    [self.imagesScrollView addSubview:self.containerView];
    self.imagesScrollView.delegate = self;
    
    float zoom = 0.5;
    
    self.imagesScrollView.minimumZoomScale = zoom;
    self.imagesScrollView.maximumZoomScale = zoom;
    self.imagesScrollView.zoomScale = zoom;
    
    self.imagesScrollView.contentInset=UIEdgeInsetsMake(-paddingH/2, -paddingW/2, -paddingH/2, -paddingW/2);
    //self.imagesScrollView.scrollIndicatorInsets=UIEdgeInsetsMake(paddingH, paddingW, paddingH, paddingW);
    
    //CGPoint bottomOffset = CGPointMake(0, self.imagesScrollView.contentSize.height - self.imagesScrollView.bounds.size.height);
    //[self.imagesScrollView setContentOffset:bottomOffset animated:YES];
    
    [self.view addSubview:self.imagesScrollView];
    
    NSString *notificationName = kShowBBCodeNotification;
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(bbCodeNotificationWithManagedObject:)
     name:notificationName
     object:nil];
    
    // POPUP
    
    UIImage *unselectedBackgroundImage = [[UIImage imageNamed:@"whiteButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(17, 17, 17, 17)];
    [[UISegmentedControl appearance] setBackgroundImage:unselectedBackgroundImage
                                               forState:UIControlStateNormal
                                             barMetrics:UIBarMetricsDefault];
    
    UIImage *selectedBackgroundImage = [[UIImage imageNamed:@"blueButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(17, 17, 17, 17)];
    [[UISegmentedControl appearance] setBackgroundImage:selectedBackgroundImage
                                               forState:UIControlStateSelected
                                             barMetrics:UIBarMetricsDefault];

    [[UISegmentedControl appearance] setDividerImage:[UIImage imageWithColor:[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1]]
                forLeftSegmentState:UIControlStateNormal
                  rightSegmentState:UIControlStateNormal
                         barMetrics:UIBarMetricsDefault];
    
    
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    NSDictionary *attributesNormal = [NSDictionary dictionaryWithObjects:@[font, [UIColor blackColor]] forKeys:@[UITextAttributeFont, UITextAttributeTextColor]];
    NSDictionary *attributesSelected = [NSDictionary dictionaryWithObjects:@[font, [UIColor whiteColor]] forKeys:@[UITextAttributeFont, UITextAttributeTextColor]];

    UIView *popupView = [[UIView alloc] initWithFrame:self.view.frame];
    
    UIView *overlayView = [[UIView alloc] initWithFrame:self.view.frame];
    overlayView.backgroundColor = [UIColor blackColor];
    overlayView.alpha = 0.5f;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [overlayView addGestureRecognizer:tapGestureRecognizer];
    
    UIView *optionsView = [[UIView alloc] initWithFrame:CGRectZero];
    optionsView.backgroundColor = [UIColor whiteColor];
    optionsView.layer.cornerRadius = 5;
    optionsView.layer.masksToBounds = YES;
    
    float optionsWidth = 280.0f;
    float optionsPadding = 10.0f;
    float labelHeight = 15.0f;
    float cointrolHeight = 50.0f;
    float buttonHeight = 40.0f;
    
    
    float offset = optionsPadding;
    
    UILabel *qualityLabel = [[UILabel alloc] initWithFrame:CGRectMake(optionsPadding, offset, optionsWidth - optionsPadding*2, labelHeight)];
    [qualityLabel setText:@"Taille"];
    [qualityLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:13]];
    [qualityLabel setTextAlignment:NSTextAlignmentCenter];
    offset += labelHeight + optionsPadding;
    
    UISegmentedControl *qualityControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Thumb", @"Preview", @"Full", nil]];
    qualityControl.frame = CGRectMake(optionsPadding, offset, optionsWidth-optionsPadding*2, cointrolHeight);
    [qualityControl setSelectedSegmentIndex:1];
    qualityControl.tintColor = [UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1];
    offset += cointrolHeight + optionsPadding;
    
    UILabel *linkLabel = [[UILabel alloc] initWithFrame:CGRectMake(optionsPadding, offset, optionsWidth - optionsPadding*2, labelHeight)];
    [linkLabel setText:@"BBCode"];
    [linkLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:13]];
    [linkLabel setTextAlignment:NSTextAlignmentCenter];
    offset += labelHeight + optionsPadding;

    UISegmentedControl *linkControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"URL+IMG", @"IMG", @"URL", nil]];
    linkControl.frame = CGRectMake(optionsPadding, offset, optionsWidth-optionsPadding*2, cointrolHeight);
    [linkControl setSelectedSegmentIndex:0];
    linkControl.tintColor = [UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1];
    offset += cointrolHeight + optionsPadding*2;

    ColoredButtonBlack *cancelButton = [[ColoredButtonBlack alloc] initWithFrame:CGRectMake(optionsPadding, offset, (optionsWidth-optionsPadding*3)/2, buttonHeight)];
    [cancelButton setTitle:@"Annuler" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    
    ColoredButtonBlue *copyButton = [[ColoredButtonBlue alloc] initWithFrame:CGRectMake(optionsPadding*2 + (optionsWidth-optionsPadding*3)/2, offset, (optionsWidth-optionsPadding*3)/2, buttonHeight)];
    [copyButton setTitle:@"Copier" forState:UIControlStateNormal];
    [copyButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
    
    offset += buttonHeight + optionsPadding;
    
    
    
    
    
    
    [qualityControl setContentPositionAdjustment:UIOffsetMake(- 5, 0)
                                  forSegmentType:UISegmentedControlSegmentLeft
                                      barMetrics:UIBarMetricsDefault];
    [qualityControl setContentPositionAdjustment:UIOffsetMake( 5, 0)
                                  forSegmentType:UISegmentedControlSegmentRight
                                      barMetrics:UIBarMetricsDefault];
    
    [linkControl setContentPositionAdjustment:UIOffsetMake(- 5, 0)
                                  forSegmentType:UISegmentedControlSegmentLeft
                                      barMetrics:UIBarMetricsDefault];
    [linkControl setContentPositionAdjustment:UIOffsetMake( 5, 0)
                                  forSegmentType:UISegmentedControlSegmentRight
                                      barMetrics:UIBarMetricsDefault];
    
    [qualityControl setTitleTextAttributes:attributesNormal
                                  forState:UIControlStateNormal];
    [qualityControl setTitleTextAttributes:attributesSelected
                                  forState:UIControlStateSelected];
    [linkControl setTitleTextAttributes:attributesNormal
                                  forState:UIControlStateNormal];
    [linkControl setTitleTextAttributes:attributesSelected
                                  forState:UIControlStateSelected];
    
    [optionsView addSubview:qualityLabel];
    [optionsView addSubview:qualityControl];
    [optionsView addSubview:linkLabel];
    [optionsView addSubview:linkControl];
    [optionsView addSubview:cancelButton];
    [optionsView addSubview:copyButton];

    optionsView.frame = CGRectMake((self.view.frame.size.width-optionsWidth)/2, (self.view.frame.size.height-offset)/2, optionsWidth, offset);
    
    [popupView addSubview:overlayView];
    [popupView addSubview:optionsView];
    
    //[self.view addSubview:popupView];
    //-- POPUP
    
}

- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
    //Code to handle the gesture

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"pointF %@", NSStringFromCGPoint(scrollView.contentOffset));
}

-(void)bbCodeNotificationWithManagedObject:(NSNotification *)notification {
    NSLog(@"bbCodeNotificationWithManagedObject %@", notification);
    
    float zoom = 1.25;
    
    CGPoint point = [self CGPointForIndex:4];

    NSLog(@"point %@", NSStringFromCGPoint(point));

    float paddingH = ((self.view.frame.size.height - kGridHeight*1.25)/2)/1.25;
    float paddingW = ((self.view.frame.size.width - kGridWidth*1.25)/2)/1.25;

    NSLog(@"H %f W %f", paddingH, paddingW);
    
    point.x -= paddingW;
    point.y -= paddingH;
    
    point.x = point.x * zoom;
    point.y = point.y * zoom;
    
    self.imagesScrollView.contentInset=UIEdgeInsetsZero;

    self.imagesScrollView.minimumZoomScale = zoom;
    self.imagesScrollView.maximumZoomScale = zoom;
    self.imagesScrollView.zoomScale = zoom;
    self.imagesScrollView.scrollEnabled = NO;
    //NSLog(@"point %@", NSStringFromCGPoint(point));
    
    [self.imagesScrollView setContentOffset:point];
    /*
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{

                         
                     }
                     completion:nil];
*/
  //
}


- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that we want to zoom
    return self.containerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.imagesScrollView release];
    [super dealloc];
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController_ != nil) {
        return fetchedResultsController_;
    }
    
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Image" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    //[fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
    NSError *error = nil;
    if (![fetchedResultsController_ performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return fetchedResultsController_;
}


@end
