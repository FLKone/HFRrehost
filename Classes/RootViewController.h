//
//  RootViewController.h
//  HFRrehost
//
//  Created by Shasta on 15/10/10.
//  Copyright 2010 FLK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "OverlayViewController.h"
#import "ProgressView.h"

@class ImageCellView;


@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIImagePickerControllerDelegate, OverlayViewControllerDelegate> {

@private
    NSFetchedResultsController *fetchedResultsController_;
    NSManagedObjectContext *managedObjectContext_;

	
	OverlayViewController *overlayViewController; // the camera custom overlay view
	ProgressView *progViewController;

	ImageCellView *tmpCell;

}

@property (nonatomic, assign) IBOutlet ImageCellView *tmpCell;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, retain) OverlayViewController *overlayViewController;
@property (nonatomic, retain) ProgressView *progViewController;

@end
