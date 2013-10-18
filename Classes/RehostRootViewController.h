//
//  RehostRootViewController.h
//  HFRrehost
//
//  Created by Shasta on 16/10/13.
//
//

#import <UIKit/UIKit.h>

@interface RehostRootViewController : UIViewController <NSFetchedResultsControllerDelegate, UIScrollViewDelegate> {

@private
    NSFetchedResultsController *fetchedResultsController_;
    NSManagedObjectContext *managedObjectContext_;
    
    UIScrollView *imagesScrollView;
    UIView *containerView;
    
}

@property (nonatomic, assign) UIScrollView *imagesScrollView;
@property (nonatomic, assign) UIView *containerView;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
